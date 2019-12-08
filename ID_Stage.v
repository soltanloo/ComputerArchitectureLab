module ID_Stage(
  input clk, rst,
  input[31:0] Instruction,
  input[31:0] Result_WB,
  input writeBackEn,
  input[3:0] Dest_WB,
  input hazard,
  input[3:0] SR,
  input[31:0] PC_in,
  output WB_EN, MEM_R_EN, MEM_W_EN, B, S,
  output[3:0] EXE_CMD,
  output[31:0] Val_Rn, Val_Rm,
  output imm,
  output[11:0] Shift_operand,
  output[23:0] Signed_imm_24,
  output[3:0] Dest, // FIXME: not sure
  output[3:0] src1, src2, // FIXME: not sure
  output Two_src,
  output[3:0] destAddress, // FIXME: not sure
  output[31:0] PC,
  output [31:0] sreg1, sreg2, sreg3, sreg4,
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

  wire[3:0] Rn, Rm;
  wire hasCondition;
  assign Rm = Instruction[3:0];
  assign Rn = Instruction[19:16];
  wire[8:0] tempCommands, commands;
  assign commands = hazard || ~hasCondition ? 6'b0 : tempCommands;
  assign WB_EN = commands[8];
  assign MEM_R_EN = commands[7];
  assign MEM_W_EN = commands[6];
  assign EXE_CMD = commands[5:2];
  assign B = commands[1];
  assign S = commands[0];

  ControlUnit CU(.s(Instruction[20]), .mode(Instruction[27:26]), .opCode(Instruction[24:21]), .WB_EN(tempCommands[8]), .MEM_R_EN(tempCommands[7]), .MEM_W_EN(tempCommands[6]), .EXE_CMD(tempCommands[5:2]), .B(tempCommands[1]), .S(tempCommands[0]));
  ConditionCheck CC(.cond(Instruction[31:28]), .statusReg(SR), .hasCondition(hasCondition));
  RegisterFile RF(.clk(clk), .rst(rst), .src1(Rn), .src2(MEM_W_EN ? Dest : Rm), .Dest_wb(Dest_WB), .Result_WB(Result_WB), .writeBackEn(writeBackEn), .reg1(Val_Rn), .reg2(Val_Rm),
                  .sreg1(sreg1), .sreg2(sreg2), .sreg3(sreg3), .sreg4(sreg4),
                  .rf0(rf0),
                  .rf1(rf1),
                  .rf2(rf2),
                  .rf3(rf3),
                  .rf4(rf4),
                  .rf5(rf5),
                  .rf6(rf6),
                  .rf7(rf7),
                  .rf8(rf8),
                  .rf9(rf9),
                  .rf10(rf10)
                );
  assign src1 = Rn;
  assign src2 = destAddress;
  assign Two_src = MEM_R_EN || ~Instruction[25];
  assign destAddress = MEM_W_EN ? Dest : Rm;
  assign imm = Instruction[25];
  assign Shift_operand = Instruction[11:0];
  assign Signed_imm_24 = Instruction[23:0];
  assign Dest = Instruction[15:12];
  assign PC = PC_in;
endmodule