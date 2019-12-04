module RegisterFile(
  input clk, rst,
  input[3:0] src1, src2, Dest_wb,
  input[31:0] Result_WB,
  input writeBackEn,
  output[31:0] reg1, reg2,
  output[31:0] sreg1, sreg2, sreg3, sreg4
);

  reg[31:0] registerFile[0:15];
  
  integer i;
  always @(negedge clk, posedge rst) begin // FIXME: posedge clk or negedge clk?
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

endmodule