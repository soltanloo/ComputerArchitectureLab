module ID_Stage_Reg(
  input clk, rst, flush,
  input WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN,
  input B_IN, S_IN,
  input[3:0] EXE_CMD_IN,
  input[31:0] PC_in,
  input[31:0] Val_Rn_IN, Val_Rm_IN,
  input imm_IN,
  input[11:0] Shift_operand_IN,
  input[23:0] Signed_imm_24_IN,
  input[3:0] Dest_IN,

  output reg WB_EN, MEM_R_EN, MEM_W_EN, B, S,
  output reg[3:0] EXE_CMD,
  output reg[31:0] Val_Rm, Val_Rn,
  output reg imm,
  output reg[11:0] Shift_operand,
  output reg[23:0] Signed_imm_24,
  output reg[3:0] Dest,
  output reg[31:0] PC
);

  always@(posedge clk, posedge rst) begin
    if(rst) begin
      PC <= 0;
    end
    else begin
      PC <= PC_in;
    end
  end

endmodule