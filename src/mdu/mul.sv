module mul #(parameter XLEN) (
  input         clk,
                reset,
                StallM,
                FlushM,
  input  [31:0] ForwardedSrcAE,
                ForwardedSrcBE,
  input  [2:0]  Funct3E,
  output [63:0] ProdM
);

  wire [63:0] _sum2_reg_q;
  wire [63:0] _sum1_reg_q;
  wire [63:0] _PP4M_reg_q;
  wire [63:0] _PP3M_reg_q;
  wire [63:0] _PP2M_reg_q;
  wire [63:0] _PP1M_reg_q;
  wire [30:0] PA = ForwardedSrcAE[31] ? ForwardedSrcBE[30:0] : 31'h0;
  wire        Pm = ForwardedSrcAE[31] & ForwardedSrcBE[31];
  wire        _GEN = Funct3E == 3'h1;
  wire        _GEN_0 = Funct3E == 3'h2;
  flopenrc #(
    .WIDTH(64)
  ) PP1M_reg (
    .clk   (clk),
    .reset (reset),
    .clear (FlushM),
    .en    (~StallM),
    .d     ({33'h0, ForwardedSrcAE[30:0]} * {33'h0, ForwardedSrcBE[30:0]}),
    .q     (_PP1M_reg_q)
  );
  flopenrc #(
    .WIDTH(64)
  ) PP2M_reg (
    .clk   (clk),
    .reset (reset),
    .clear (FlushM),
    .en    (~StallM),
    .d     ({2'h0, _GEN ? ~PA : {31{_GEN_0}} ^ PA, 31'h0}),
    .q     (_PP2M_reg_q)
  );
  flopenrc #(
    .WIDTH(64)
  ) PP3M_reg (
    .clk   (clk),
    .reset (reset),
    .clear (FlushM),
    .en    (~StallM),
    .d
      ({2'h0, {31{_GEN}} ^ (ForwardedSrcBE[31] ? ForwardedSrcAE[30:0] : 31'h0), 31'h0}),
    .q     (_PP3M_reg_q)
  );
  flopenrc #(
    .WIDTH(64)
  ) PP4M_reg (
    .clk   (clk),
    .reset (reset),
    .clear (FlushM),
    .en    (~StallM),
    .d
      (_GEN
         ? {1'h1, Pm, 62'h100000000}
         : _GEN_0 ? {1'h1, ~Pm, 62'h80000000} : {1'h0, Pm, 62'h0}),
    .q     (_PP4M_reg_q)
  );
  flopenrc #(
    .WIDTH(64)
  ) sum1_reg (
    .clk   (clk),
    .reset (reset),
    .clear (FlushM),
    .en    (~StallM),
    .d     (_PP1M_reg_q + _PP2M_reg_q),
    .q     (_sum1_reg_q)
  );
  flopenrc #(
    .WIDTH(64)
  ) sum2_reg (
    .clk   (clk),
    .reset (reset),
    .clear (FlushM),
    .en    (~StallM),
    .d     (_PP3M_reg_q + _PP4M_reg_q),
    .q     (_sum2_reg_q)
  );
  assign ProdM = _sum1_reg_q + _sum2_reg_q;
endmodule

