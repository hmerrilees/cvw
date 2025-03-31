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

  wire [2:0]      _Funct3M_reg_q;
  wire [2:0]      _PP4M_reg_q;
  wire [32:0]     _PP3M_reg_q;
  wire [32:0]     _PP2M_reg_q;
  wire [78:0]     _PP1M_reg_q;
  wire [2:0]      _boothDigit_T_16 =
    {2'h0, ForwardedSrcBE[2:0] == 3'h2 | ForwardedSrcBE[2:0] == 3'h1};
  wire [7:0][2:0] _GEN =
    {{3'h0},
     {3'h7},
     {3'h7},
     {3'h6},
     {3'h2},
     {_boothDigit_T_16},
     {_boothDigit_T_16},
     {_boothDigit_T_16}};
  wire [2:0]      boothDigit_1 = _GEN[ForwardedSrcBE[2:0]];
  wire [2:0]      _boothDigit_T_29 =
    {2'h0, ForwardedSrcBE[4:2] == 3'h2 | ForwardedSrcBE[4:2] == 3'h1};
  wire [7:0][2:0] _GEN_0 =
    {{3'h0},
     {3'h7},
     {3'h7},
     {3'h6},
     {3'h2},
     {_boothDigit_T_29},
     {_boothDigit_T_29},
     {_boothDigit_T_29}};
  wire [2:0]      boothDigit_2 = _GEN_0[ForwardedSrcBE[4:2]];
  wire [29:0]     _GEN_1 = ~(ForwardedSrcAE[29:0]);
  wire [2:0]      _boothDigit_T_42 =
    {2'h0, ForwardedSrcBE[6:4] == 3'h2 | ForwardedSrcBE[6:4] == 3'h1};
  wire [7:0][2:0] _GEN_2 =
    {{3'h0},
     {3'h7},
     {3'h7},
     {3'h6},
     {3'h2},
     {_boothDigit_T_42},
     {_boothDigit_T_42},
     {_boothDigit_T_42}};
  wire [2:0]      boothDigit_3 = _GEN_2[ForwardedSrcBE[6:4]];
  wire [27:0]     _GEN_3 = ~(ForwardedSrcAE[27:0]);
  wire [2:0]      _boothDigit_T_55 =
    {2'h0, ForwardedSrcBE[8:6] == 3'h2 | ForwardedSrcBE[8:6] == 3'h1};
  wire [7:0][2:0] _GEN_4 =
    {{3'h0},
     {3'h7},
     {3'h7},
     {3'h6},
     {3'h2},
     {_boothDigit_T_55},
     {_boothDigit_T_55},
     {_boothDigit_T_55}};
  wire [2:0]      boothDigit_4 = _GEN_4[ForwardedSrcBE[8:6]];
  wire [25:0]     _GEN_5 = ~(ForwardedSrcAE[25:0]);
  wire [2:0]      _boothDigit_T_68 =
    {2'h0, ForwardedSrcBE[10:8] == 3'h2 | ForwardedSrcBE[10:8] == 3'h1};
  wire [7:0][2:0] _GEN_6 =
    {{3'h0},
     {3'h7},
     {3'h7},
     {3'h6},
     {3'h2},
     {_boothDigit_T_68},
     {_boothDigit_T_68},
     {_boothDigit_T_68}};
  wire [2:0]      boothDigit_5 = _GEN_6[ForwardedSrcBE[10:8]];
  wire [23:0]     _GEN_7 = ~(ForwardedSrcAE[23:0]);
  wire [2:0]      _boothDigit_T_81 =
    {2'h0, ForwardedSrcBE[12:10] == 3'h2 | ForwardedSrcBE[12:10] == 3'h1};
  wire [7:0][2:0] _GEN_8 =
    {{3'h0},
     {3'h7},
     {3'h7},
     {3'h6},
     {3'h2},
     {_boothDigit_T_81},
     {_boothDigit_T_81},
     {_boothDigit_T_81}};
  wire [2:0]      boothDigit_6 = _GEN_8[ForwardedSrcBE[12:10]];
  wire [21:0]     _GEN_9 = ~(ForwardedSrcAE[21:0]);
  wire [2:0]      _boothDigit_T_94 =
    {2'h0, ForwardedSrcBE[14:12] == 3'h2 | ForwardedSrcBE[14:12] == 3'h1};
  wire [7:0][2:0] _GEN_10 =
    {{3'h0},
     {3'h7},
     {3'h7},
     {3'h6},
     {3'h2},
     {_boothDigit_T_94},
     {_boothDigit_T_94},
     {_boothDigit_T_94}};
  wire [2:0]      boothDigit_7 = _GEN_10[ForwardedSrcBE[14:12]];
  wire [19:0]     _GEN_11 = ~(ForwardedSrcAE[19:0]);
  wire [2:0]      _boothDigit_T_107 =
    {2'h0, ForwardedSrcBE[16:14] == 3'h2 | ForwardedSrcBE[16:14] == 3'h1};
  wire [7:0][2:0] _GEN_12 =
    {{3'h0},
     {3'h7},
     {3'h7},
     {3'h6},
     {3'h2},
     {_boothDigit_T_107},
     {_boothDigit_T_107},
     {_boothDigit_T_107}};
  wire [2:0]      boothDigit_8 = _GEN_12[ForwardedSrcBE[16:14]];
  wire [17:0]     _GEN_13 = ~(ForwardedSrcAE[17:0]);
  wire [2:0]      _boothDigit_T_120 =
    {2'h0, ForwardedSrcBE[18:16] == 3'h2 | ForwardedSrcBE[18:16] == 3'h1};
  wire [7:0][2:0] _GEN_14 =
    {{3'h0},
     {3'h7},
     {3'h7},
     {3'h6},
     {3'h2},
     {_boothDigit_T_120},
     {_boothDigit_T_120},
     {_boothDigit_T_120}};
  wire [2:0]      boothDigit_9 = _GEN_14[ForwardedSrcBE[18:16]];
  wire [15:0]     _GEN_15 = ~(ForwardedSrcAE[15:0]);
  wire [2:0]      _boothDigit_T_133 =
    {2'h0, ForwardedSrcBE[20:18] == 3'h2 | ForwardedSrcBE[20:18] == 3'h1};
  wire [7:0][2:0] _GEN_16 =
    {{3'h0},
     {3'h7},
     {3'h7},
     {3'h6},
     {3'h2},
     {_boothDigit_T_133},
     {_boothDigit_T_133},
     {_boothDigit_T_133}};
  wire [2:0]      boothDigit_10 = _GEN_16[ForwardedSrcBE[20:18]];
  wire [13:0]     _GEN_17 = ~(ForwardedSrcAE[13:0]);
  wire [2:0]      _boothDigit_T_146 =
    {2'h0, ForwardedSrcBE[22:20] == 3'h2 | ForwardedSrcBE[22:20] == 3'h1};
  wire [7:0][2:0] _GEN_18 =
    {{3'h0},
     {3'h7},
     {3'h7},
     {3'h6},
     {3'h2},
     {_boothDigit_T_146},
     {_boothDigit_T_146},
     {_boothDigit_T_146}};
  wire [2:0]      boothDigit_11 = _GEN_18[ForwardedSrcBE[22:20]];
  wire [11:0]     _GEN_19 = ~(ForwardedSrcAE[11:0]);
  wire [2:0]      _boothDigit_T_159 =
    {2'h0, ForwardedSrcBE[24:22] == 3'h2 | ForwardedSrcBE[24:22] == 3'h1};
  wire [7:0][2:0] _GEN_20 =
    {{3'h0},
     {3'h7},
     {3'h7},
     {3'h6},
     {3'h2},
     {_boothDigit_T_159},
     {_boothDigit_T_159},
     {_boothDigit_T_159}};
  wire [2:0]      boothDigit_12 = _GEN_20[ForwardedSrcBE[24:22]];
  wire [9:0]      _GEN_21 = ~(ForwardedSrcAE[9:0]);
  wire [2:0]      _boothDigit_T_172 =
    {2'h0, ForwardedSrcBE[26:24] == 3'h2 | ForwardedSrcBE[26:24] == 3'h1};
  wire [7:0][2:0] _GEN_22 =
    {{3'h0},
     {3'h7},
     {3'h7},
     {3'h6},
     {3'h2},
     {_boothDigit_T_172},
     {_boothDigit_T_172},
     {_boothDigit_T_172}};
  wire [2:0]      boothDigit_13 = _GEN_22[ForwardedSrcBE[26:24]];
  wire [7:0]      _GEN_23 = ~(ForwardedSrcAE[7:0]);
  wire [2:0]      _boothDigit_T_185 =
    {2'h0, ForwardedSrcBE[28:26] == 3'h2 | ForwardedSrcBE[28:26] == 3'h1};
  wire [7:0][2:0] _GEN_24 =
    {{3'h0},
     {3'h7},
     {3'h7},
     {3'h6},
     {3'h2},
     {_boothDigit_T_185},
     {_boothDigit_T_185},
     {_boothDigit_T_185}};
  wire [2:0]      boothDigit_14 = _GEN_24[ForwardedSrcBE[28:26]];
  wire [5:0]      _GEN_25 = ~(ForwardedSrcAE[5:0]);
  wire [2:0]      _boothDigit_T_198 =
    {2'h0, ForwardedSrcBE[30:28] == 3'h2 | ForwardedSrcBE[30:28] == 3'h1};
  wire [7:0][2:0] _GEN_26 =
    {{3'h0},
     {3'h7},
     {3'h7},
     {3'h6},
     {3'h2},
     {_boothDigit_T_198},
     {_boothDigit_T_198},
     {_boothDigit_T_198}};
  wire [2:0]      boothDigit_15 = _GEN_26[ForwardedSrcBE[30:28]];
  wire [3:0]      _GEN_27 = ~(ForwardedSrcAE[3:0]);
  wire [74:0]     _PP1E_T_10 =
    {1'h0,
     {1'h0,
      {1'h0,
       {1'h0,
        {1'h0,
         {1'h0,
          {1'h0,
           {1'h0,
            {1'h0,
             {1'h0,
              {30'h0,
               ForwardedSrcBE[0]
                 ? {{2'h3, ~(ForwardedSrcAE[30:0]), 1'h1} + 34'h1, 1'h0}
                 : {2{ForwardedSrcBE[0]}} == 2'h1
                     ? {2'h0, ForwardedSrcAE[30:0], 2'h0}
                     : 35'h0}
                + {30'h0,
                   boothDigit_1 == 3'h6
                     ? {{~(ForwardedSrcAE[30:0]), 1'h1} + 32'h1, 1'h0}
                     : (&boothDigit_1)
                         ? {1'h1, ~(ForwardedSrcAE[30:0]), 1'h1} + 33'h1
                         : boothDigit_1 == 3'h2
                             ? {ForwardedSrcAE[30:0], 2'h0}
                             : boothDigit_1 == 3'h1
                                 ? {1'h0, ForwardedSrcAE[30:0], 1'h0}
                                 : 33'h0,
                   2'h0}}
               + {31'h0,
                  boothDigit_2 == 3'h6
                    ? {{_GEN_1[28:0], 1'h1} + 30'h1, 1'h0}
                    : (&boothDigit_2)
                        ? {_GEN_1, 1'h1} + 31'h1
                        : boothDigit_2 == 3'h2
                            ? {ForwardedSrcAE[28:0], 2'h0}
                            : boothDigit_2 == 3'h1 ? {ForwardedSrcAE[29:0], 1'h0} : 31'h0,
                  4'h0}}
              + {32'h0,
                 boothDigit_3 == 3'h6
                   ? {{_GEN_3[26:0], 1'h1} + 28'h1, 1'h0}
                   : (&boothDigit_3)
                       ? {_GEN_3, 1'h1} + 29'h1
                       : boothDigit_3 == 3'h2
                           ? {ForwardedSrcAE[26:0], 2'h0}
                           : boothDigit_3 == 3'h1 ? {ForwardedSrcAE[27:0], 1'h0} : 29'h0,
                 6'h0}}
             + {33'h0,
                boothDigit_4 == 3'h6
                  ? {{_GEN_5[24:0], 1'h1} + 26'h1, 1'h0}
                  : (&boothDigit_4)
                      ? {_GEN_5, 1'h1} + 27'h1
                      : boothDigit_4 == 3'h2
                          ? {ForwardedSrcAE[24:0], 2'h0}
                          : boothDigit_4 == 3'h1 ? {ForwardedSrcAE[25:0], 1'h0} : 27'h0,
                8'h0}}
            + {34'h0,
               boothDigit_5 == 3'h6
                 ? {{_GEN_7[22:0], 1'h1} + 24'h1, 1'h0}
                 : (&boothDigit_5)
                     ? {_GEN_7, 1'h1} + 25'h1
                     : boothDigit_5 == 3'h2
                         ? {ForwardedSrcAE[22:0], 2'h0}
                         : boothDigit_5 == 3'h1 ? {ForwardedSrcAE[23:0], 1'h0} : 25'h0,
               10'h0}}
           + {35'h0,
              boothDigit_6 == 3'h6
                ? {{_GEN_9[20:0], 1'h1} + 22'h1, 1'h0}
                : (&boothDigit_6)
                    ? {_GEN_9, 1'h1} + 23'h1
                    : boothDigit_6 == 3'h2
                        ? {ForwardedSrcAE[20:0], 2'h0}
                        : boothDigit_6 == 3'h1 ? {ForwardedSrcAE[21:0], 1'h0} : 23'h0,
              12'h0}}
          + {36'h0,
             boothDigit_7 == 3'h6
               ? {{_GEN_11[18:0], 1'h1} + 20'h1, 1'h0}
               : (&boothDigit_7)
                   ? {_GEN_11, 1'h1} + 21'h1
                   : boothDigit_7 == 3'h2
                       ? {ForwardedSrcAE[18:0], 2'h0}
                       : boothDigit_7 == 3'h1 ? {ForwardedSrcAE[19:0], 1'h0} : 21'h0,
             14'h0}}
         + {37'h0,
            boothDigit_8 == 3'h6
              ? {{_GEN_13[16:0], 1'h1} + 18'h1, 1'h0}
              : (&boothDigit_8)
                  ? {_GEN_13, 1'h1} + 19'h1
                  : boothDigit_8 == 3'h2
                      ? {ForwardedSrcAE[16:0], 2'h0}
                      : boothDigit_8 == 3'h1 ? {ForwardedSrcAE[17:0], 1'h0} : 19'h0,
            16'h0}}
        + {38'h0,
           boothDigit_9 == 3'h6
             ? {{_GEN_15[14:0], 1'h1} + 16'h1, 1'h0}
             : (&boothDigit_9)
                 ? {_GEN_15, 1'h1} + 17'h1
                 : boothDigit_9 == 3'h2
                     ? {ForwardedSrcAE[14:0], 2'h0}
                     : boothDigit_9 == 3'h1 ? {ForwardedSrcAE[15:0], 1'h0} : 17'h0,
           18'h0}}
       + {39'h0,
          boothDigit_10 == 3'h6
            ? {{_GEN_17[12:0], 1'h1} + 14'h1, 1'h0}
            : (&boothDigit_10)
                ? {_GEN_17, 1'h1} + 15'h1
                : boothDigit_10 == 3'h2
                    ? {ForwardedSrcAE[12:0], 2'h0}
                    : boothDigit_10 == 3'h1 ? {ForwardedSrcAE[13:0], 1'h0} : 15'h0,
          20'h0}}
    + {40'h0,
       boothDigit_11 == 3'h6
         ? {{_GEN_19[10:0], 1'h1} + 12'h1, 1'h0}
         : (&boothDigit_11)
             ? {_GEN_19, 1'h1} + 13'h1
             : boothDigit_11 == 3'h2
                 ? {ForwardedSrcAE[10:0], 2'h0}
                 : boothDigit_11 == 3'h1 ? {ForwardedSrcAE[11:0], 1'h0} : 13'h0,
       22'h0};
  wire [30:0]     PA = ForwardedSrcBE[30:0] & {31{ForwardedSrcAE[31]}};
  wire            Pm = ForwardedSrcAE[31] & ForwardedSrcBE[31];
  wire            _GEN_28 = Funct3E == 3'h1;
  wire            _GEN_29 = Funct3E == 3'h2;
  flopenrc #(
    .WIDTH(79)
  ) PP1M_reg (
    .clk   (clk),
    .reset (reset),
    .clear (FlushM),
    .en    (~StallM),
    .d
      ({1'h0,
        {1'h0,
         {1'h0,
          {1'h0, _PP1E_T_10}
            + {41'h0,
               boothDigit_12 == 3'h6
                 ? {{_GEN_21[8:0], 1'h1} + 10'h1, 1'h0}
                 : (&boothDigit_12)
                     ? {_GEN_21, 1'h1} + 11'h1
                     : boothDigit_12 == 3'h2
                         ? {ForwardedSrcAE[8:0], 2'h0}
                         : boothDigit_12 == 3'h1 ? {ForwardedSrcAE[9:0], 1'h0} : 11'h0,
               24'h0}}
           + {42'h0,
              boothDigit_13 == 3'h6
                ? {{_GEN_23[6:0], 1'h1} + 8'h1, 1'h0}
                : (&boothDigit_13)
                    ? {_GEN_23, 1'h1} + 9'h1
                    : boothDigit_13 == 3'h2
                        ? {ForwardedSrcAE[6:0], 2'h0}
                        : boothDigit_13 == 3'h1 ? {ForwardedSrcAE[7:0], 1'h0} : 9'h0,
              26'h0}}
          + {43'h0,
             boothDigit_14 == 3'h6
               ? {{_GEN_25[4:0], 1'h1} + 6'h1, 1'h0}
               : (&boothDigit_14)
                   ? {_GEN_25, 1'h1} + 7'h1
                   : boothDigit_14 == 3'h2
                       ? {ForwardedSrcAE[4:0], 2'h0}
                       : boothDigit_14 == 3'h1 ? {ForwardedSrcAE[5:0], 1'h0} : 7'h0,
             28'h0}}
       + {44'h0,
          boothDigit_15 == 3'h6
            ? {{_GEN_27[2:0], 1'h1} + 4'h1, 1'h0}
            : (&boothDigit_15)
                ? {_GEN_27, 1'h1} + 5'h1
                : boothDigit_15 == 3'h2
                    ? {ForwardedSrcAE[2:0], 2'h0}
                    : boothDigit_15 == 3'h1 ? {ForwardedSrcAE[3:0], 1'h0} : 5'h0,
          30'h0}),
    .q     (_PP1M_reg_q)
  );
  flopenrc #(
    .WIDTH(33)
  ) PP2M_reg (
    .clk   (clk),
    .reset (reset),
    .clear (FlushM),
    .en    (~StallM),
    .d     ({2'h0, _GEN_28 ? ~PA : {31{_GEN_29}} ^ PA}),
    .q     (_PP2M_reg_q)
  );
  flopenrc #(
    .WIDTH(33)
  ) PP3M_reg (
    .clk   (clk),
    .reset (reset),
    .clear (FlushM),
    .en    (~StallM),
    .d     ({2'h0, {31{_GEN_28}} ^ ForwardedSrcAE[30:0] & {31{ForwardedSrcBE[31]}}}),
    .q     (_PP3M_reg_q)
  );
  flopenrc #(
    .WIDTH(3)
  ) PP4M_reg (
    .clk   (clk),
    .reset (reset),
    .clear (FlushM),
    .en    (~StallM),
    .d     (_GEN_28 ? {1'h1, Pm, 1'h1} : _GEN_29 ? {1'h1, ~Pm, 1'h1} : {1'h0, Pm, 1'h0}),
    .q     (_PP4M_reg_q)
  );
  flopenrc #(
    .WIDTH(3)
  ) Funct3M_reg (
    .clk   (clk),
    .reset (reset),
    .clear (FlushM),
    .en    (~StallM),
    .d     (Funct3E),
    .q     (_Funct3M_reg_q)
  );
  assign ProdM =
    _PP1M_reg_q[63:0] + {_PP2M_reg_q, 31'h0} + {_PP3M_reg_q, 31'h0}
    + (_Funct3M_reg_q == 3'h0 | _Funct3M_reg_q == 3'h3
         ? {_PP4M_reg_q[2:1], 62'h0}
         : _Funct3M_reg_q == 3'h1
             ? {_PP4M_reg_q[2:1], 29'h0, _PP4M_reg_q[0], 32'h0}
             : _Funct3M_reg_q == 3'h2
                 ? {_PP4M_reg_q[2:1], 30'h0, _PP4M_reg_q[0], 31'h0}
                 : 64'h0);
endmodule


