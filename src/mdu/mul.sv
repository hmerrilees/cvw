module mul #(parameter XLEN) (
  input  logic                clk, reset,
  input  logic                StallM, FlushM,
  input  logic [XLEN-1:0]     ForwardedSrcAE, ForwardedSrcBE, // source A and B from after Forwarding mux
  input  logic [2:0]          Funct3E,                        // type of multiply
  output logic [XLEN*2-1:0]   ProdM                           // double-width product
);

  // Optimized pipeline structure
  logic [XLEN-1:0]      BoothAE;                         // Multiplicand
  logic [XLEN+2:0]      BoothBE;                         // Multiplier with extra bits
  logic                 SignedMulE;                      // Is this a signed multiplication
  logic [2:0]           Funct3M;                         // Saved function type

  // Execute to Memory stage registers
  logic [XLEN-1:0]      BoothAM;                         // Registered multiplicand
  logic [XLEN+2:0]      BoothBM;                         // Registered multiplier
  logic                 SignedMulM;                      // Registered signed flag

  // Booth partial products computed in Memory stage
  logic [XLEN*2-1:0]    ProdFullM;                       // Full product result

  //////////////////////////////
  // Execute Stage: Prepare operands
  //////////////////////////////

  // Determine if this is a signed multiplication based on funct3
  assign SignedMulE = (Funct3E[2:1] != 2'b11);

  // Prepare A and B for Booth encoding
  assign BoothAE = ForwardedSrcAE;
  assign BoothBE = {ForwardedSrcBE, 2'b0}; // Append two bits for Booth encoding

  //////////////////////////////
  // Transfer to Memory Stage - only the operands, not the products
  //////////////////////////////

  flopenrc #(XLEN)   AEReg(clk, reset, FlushM, ~StallM, BoothAE, BoothAM);
  flopenrc #(XLEN+3) BEReg(clk, reset, FlushM, ~StallM, BoothBE, BoothBM);
  flopenrc #(1)      SignedReg(clk, reset, FlushM, ~StallM, SignedMulE, SignedMulM);
  flopenrc #(3)      Funct3Reg(clk, reset, FlushM, ~StallM, Funct3E, Funct3M);

  //////////////////////////////
  // Memory Stage: Generate booth-encoded product
  //////////////////////////////

  // Compute the full product
  booth_encoder_optimized #(XLEN) booth_encoder(
    .A(BoothAM),
    .BwithExtraBits(BoothBM),
    .SignedMul(SignedMulM),
    .Product(ProdFullM)
  );
  
  // Select the appropriate output based on the function type
  always_comb begin
    case (Funct3M)
      3'b000:  ProdM = {{XLEN{ProdFullM[XLEN-1]}}, ProdFullM[XLEN-1:0]};  // MUL - lower bits with sign extension
      3'b001:  ProdM = ProdFullM;                                          // MULH - full product
      3'b010:  ProdM = ProdFullM;                                          // MULHSU - full product
      3'b011:  ProdM = ProdFullM;                                          // MULHU - full product
      default: ProdM = ProdFullM;                                          // Default to full product
    endcase
  end

endmodule

// Optimized Booth Encoder module
module booth_encoder_optimized #(parameter XLEN) (
  input  logic [XLEN-1:0]    A,              // Multiplicand
  input  logic [XLEN+2:0]    BwithExtraBits, // Multiplier with 2 extra bits
  input  logic               SignedMul,      // Signed multiplication flag
  output logic [XLEN*2-1:0]  Product         // Final product
);

  logic signed [XLEN:0] signedA;     // Signed version of A with extension bit
  logic [XLEN:0] unsignedA;          // Unsigned version of A with extension bit
  logic [XLEN:0] extA;               // Selected extended A based on operation type
  logic [XLEN*2-1:0] partialProduct; // Accumulator for partial products
  logic [XLEN+2:0] B;                // Local copy of B with extra bits

  always_comb begin
    // Initialize values
    B = BwithExtraBits;
    
    // Prepare extended versions of A
    signedA = {{1{A[XLEN-1]}}, A};        // Sign-extended A for signed operations
    unsignedA = {1'b0, A};                // Zero-extended A for unsigned operations
    
    // Select appropriate A version based on signed flag
    extA = SignedMul ? signedA : unsignedA;
    
    // Initialize the partial product
    partialProduct = '0;
    
    // Process all bit pairs in the multiplier
    for (int i = 0; i < XLEN; i = i + 1) begin
      // Extract 3 bits for Booth encoding (current, next, and carry)
      logic [2:0] boothBits;
      logic signed [XLEN+1:0] boothVal;
      
      // Get 3 consecutive bits starting from position i
      boothBits = B[i +: 3];
      
      // Apply modified Booth encoding
      case (boothBits)
        3'b000, 3'b111: boothVal = '0;                 // +0
        3'b001, 3'b010: boothVal = extA;               // +A
        3'b011:         boothVal = {extA, 1'b0};       // +2A
        3'b100:         boothVal = ~{extA, 1'b0} + 1;  // -2A
        3'b101, 3'b110: boothVal = ~extA + 1;          // -A
        default:        boothVal = '0;                 // Default case (should never happen)
      endcase
      
      // Accumulate the partial product with proper shifting - USING ADDITION NOT OR
      partialProduct = partialProduct + (boothVal << (i * 2));
    end
    
    // Return the final product
    Product = partialProduct;
  end
endmodule