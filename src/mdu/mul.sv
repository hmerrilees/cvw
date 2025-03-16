///////////////////////////////////////////
// mul.sv
//
// Written: David_Harris@hmc.edu 16 February 2021
// Modified: 
//
// Purpose: Integer multiplication
// 
// Documentation: RISC-V System on Chip Design
//
// A component of the CORE-V-WALLY configurable RISC-V project.
// https://github.com/openhwgroup/cvw
// 
// Copyright (C) 2021-23 Harvey Mudd College & Oklahoma State University
//
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the "License"); you may not use this file 
// except in compliance with the License, or, at your option, the Apache License version 2.0. You 
// may obtain a copy of the License at
//
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, any work distributed under the 
// License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
// either express or implied. See the License for the specific language governing permissions 
// and limitations under the License.
////////////////////////////////////////////////////////////////////////////////////////////////

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
  logic [XLEN*2-1:0]    ProdPartialM;                    // Single partial product accumulator

  //////////////////////////////
  // Execute Stage: Prepare operands 
  //////////////////////////////

  // Determine if this is a signed multiplication based on funct3
  assign SignedMulE = (Funct3E[2:1] != 2'b11);
  
  // Prepare A and B for Booth encoding
  assign BoothAE = SignedMulE ? ForwardedSrcAE : {1'b0, ForwardedSrcAE[XLEN-2:0]};
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
  
  // Simplified booth encoding in Memory stage
  booth_encoder_optimized #(XLEN) booth_encoder(
    .A(BoothAM),
    .BwithExtraBits(BoothBM),
    .SignedMul(SignedMulM),
    .Product(ProdM)
  );
  
endmodule

// Optimized Booth Encoder module
module booth_encoder_optimized #(parameter XLEN) (
  input  logic [XLEN-1:0]    A,              // Multiplicand
  input  logic [XLEN+2:0]    BwithExtraBits, // Multiplier with 2 extra bits
  input  logic               SignedMul,      // Signed multiplication flag
  output logic [XLEN*2-1:0]  Product         // Final product
);
  
  logic signed [XLEN+1:0] extA;              // Extended A for signed operations
  logic [XLEN*2-1:0] partialProduct;         // Single accumulator for partial products
  
  // Sign extend A for signed multiplication
  always_comb begin
    // Declare all variables at the beginning of the block
    automatic int i;
    automatic logic [2:0] boothBits;
    automatic logic [XLEN+1:0] boothVal;
    
    // Sign extension based on multiplication type
    extA = SignedMul ? {{2{A[XLEN-1]}}, A} : {2'b00, A};
      
    // Initialize partial product
    partialProduct = '0;
    
    // Process booth encodings
    for (i = 0; i < XLEN/2; i++) begin
      // Direct bit selection instead of function call
      boothBits = BwithExtraBits[i*2 +: 3];
      
      // Modified Booth encoding
      case (boothBits)
        3'b000: boothVal = '0;                 // 0
        3'b001: boothVal = extA;               // A
        3'b010: boothVal = extA;               // A
        3'b011: boothVal = extA << 1;          // 2A
        3'b100: boothVal = ~(extA << 1) + 1'b1;// -2A
        3'b101: boothVal = ~extA + 1'b1;       // -A
        3'b110: boothVal = ~extA + 1'b1;       // -A
        3'b111: boothVal = '0;                 // 0
      endcase
      
      // Simplified parameterized shift and accumulate - using a single accumulator
      partialProduct = partialProduct | (boothVal << (i*2));
    end
    
    // Assign the final product
    Product = partialProduct;
  end
endmodule
