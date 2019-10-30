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
  output[31:0] ALU_result, Br_addr,
  output[3:0] status,
);

  wire[3:0] sregIn;
  wire[31:0] val2GenOut;

  assign Br_addr = PC + Signed_imm_24;  // TODO  ? 

  ALU alu(.in1(Val_Rn), .in2(val2GenOut), .EXE_CMD(EXE_CMD), .c(SR[1]), .N(status[3]), .Z(status[2]),
          .C(status[1]), .V(status[0]), .out(ALU_result));

  Val2Generate v2g(.memop(MEM_R_EN | MEM_W_EN), val_rm(Val_Rm),
                    .imm()Signed_imm_24, .shift_operand(Shift_operand), .out(val2GenOut));


endmodule