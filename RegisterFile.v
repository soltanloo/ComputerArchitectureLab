module RegisterFile(
  input clk, rst,
  input[3:0] src1, src2, Dest_wb,
  input[31:0] Result_WB,
  input writeBackEn,
  output[31:0] reg1, reg2,
  output[31:0] sreg1, sreg2, sreg3, sreg4,
  output[31:0] rf0,
  output[31:0] rf1,
  output[31:0] rf2,
  output[31:0] rf3,
  output[31:0] rf4,
  output[31:0] rf5,
  output[31:0] rf6,
  output[31:0] rf7,
  output[31:0] rf8,
  output[31:0] rf9,
  output[31:0] rf10
);

  reg[31:0] registerFile[0:15];
  
  integer i;
  always @(negedge clk, posedge rst) begin
    if (rst) begin
      for (i = 0; i < 15; i= i + 1) begin
        registerFile[i] <= i;
      end
    end
    else if (writeBackEn) begin
      registerFile[Dest_wb] <= Result_WB;
    end
  end

  assign reg1 = registerFile[src1];
  assign reg2 = registerFile[src2];
  assign sreg1 = registerFile[10];
  assign sreg2 = registerFile[8];
  assign sreg3 = registerFile[10];
  assign sreg4 = registerFile[8];

  assign rf0 = registerFile[0];
  assign rf1 = registerFile[1];
  assign rf2 = registerFile[2];
  assign rf3 = registerFile[3];
  assign rf4 = registerFile[4];
  assign rf5 = registerFile[5];
  assign rf6 = registerFile[6];
  assign rf7 = registerFile[7];
  assign rf8 = registerFile[8];
  assign rf9 = registerFile[9];
  assign rf10 = registerFile[10];


endmodule