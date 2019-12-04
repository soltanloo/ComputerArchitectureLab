module EXE_Stage(
  input clk,
  input[3:0] EXE_CMD,
  input MEM_R_EN, MEM_W_EN,
  input[31:0] PC,
  input[31:0] Val_Rn, Val_Rm,
  input imm,
  input[11:0] Shift_operand,
  input[23:0] Signed_imm_24,
  input[3:0] SR,
  input[31:0] ALU_result_reg,
  input[31:0] WB_WB_DEST,
  input[1:0] sel_src1, sel_src2,
  output[31:0] ALU_result, Br_addr, EXE_out_Val_Rm,
  output[3:0] status
);

  wire[3:0] sregIn, aluIn1, val2GenIn;
  wire[31:0] val2GenOut;

  wire[31:0] Signed_imm_24_Sign_Extension;

  assign Signed_imm_24_Sign_Extension = Signed_imm_24[23] == 1'b1 ? {8'b11111111, Signed_imm_24} : {8'b0, Signed_imm_24};

  assign Br_addr = PC + (Signed_imm_24_Sign_Extension); // FIXME: +4? TODO removed << 2

  assign aluIn1 = sel_src1 == 2'd0 ? Val_Rn : sel_src1 == 2'd1 ? ALU_result_reg 
                  : sel_src1 == 2'd2 ? WB_WB_DEST : 32'bx;
  assign val2GenIn = sel_src2 == 2'd0 ? Val_Rm : sel_src2 == 2'd1 ? ALU_result_reg 
                  : sel_src2 == 2'd2 ? WB_WB_DEST : 32'bx;

  ALU alu(.in1(Val_Rn), .in2(val2GenOut), .EXE_CMD(EXE_CMD), .c(SR[1]), .N(status[3]), .Z(status[2]),
          .C(status[1]), .V(status[0]), .out(ALU_result));

  Val2Generate v2g(.memrw(MEM_R_EN | MEM_W_EN), .Val_Rm(val2GenIn),
                    .imm(imm), .Imm(Signed_imm_24), .Shift_operand(Shift_operand), .out(val2GenOut));

  assign EXE_out_Val_Rm = val2GenIn;
endmodule