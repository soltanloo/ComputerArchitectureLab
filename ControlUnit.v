module ControlUnit(
  input s, i,
  input[1:0] mode,
  input[3:0] opCode,
  output WB_EN, MEM_R_EN, MEM_W_EN, EXE_CMD, B, S, Imm
);

  assign MEM_R_EN = mode == 2'b01 && s == 1'b1;
  assign MEM_W_END = mode == 2'b01 && s == 1'b0;

  assign WB_EN = (mode == 2'b0 && (opCode != 4'b1010  && opCode != 4'b1000 )) || (mode == 2'b01 && s == 1'b1);

  assign EXE_CMD = (mode == 2'b0);

  assign B = (mode == 2'b10);

  assign S = mode== 2'b0 ? ((opCode == 4'b1010 || opCode == 4'b1000 ) ? 1'b1 : s) :
              mode == 2'b01 ? s : 0;

  assign Imm = mode == 2'b0 ? i : (mode == 2'b10  ? 1'b1 : 1'b0);

endmodule