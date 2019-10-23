module ID_Stage(
  input clk, rst,
  input[31:0] Instruction,
  input[31:0] Result_WB,
  input writeBackEn,
  input[3:0] Dest_WB,
  input hazard,
  input[3:0] SR,
  input[31:0] PC_in,
  output WB_EB, MEM_R_EN, MEM_W_EN, B, S,
  output[3:0] EXE_CMD,
  output[31:0] Val_Rn, Val_Rm,
  output imm,
  output[11:0] Shift_operand,
  output[23:0] Signed_imm_24,
  output[3:0] Dest,
  output[3:0] src1, src2
  output Two_src,
  output[31:0] PC
);

  
  assign PC = PC_in;
endmodule