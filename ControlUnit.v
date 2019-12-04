module ControlUnit(
  input s, i,
  input[1:0] mode,
  input[3:0] opCode,
  output WB_EN, MEM_R_EN, MEM_W_EN, B, S, Imm,
  output[3:0] EXE_CMD
);

  // modes 
  parameter ARITHMETIC = 0, MEMOP = 1, BR = 2;
  // ALU commands
  parameter ALU_MOV = 1, ALU_MVN = 9, ALU_ADD = 2, ALU_ADC = 3, ALU_SUB = 4,
              ALU_SBC = 5, ALU_AND = 6, ALU_ORR= 7, ALU_EOR = 8,
              ALU_CMP = 4, ALU_TST = 6, ALU_LDR = 2, ALU_STR = 2, ALU_BRANCH = 4'bx;

  // Opcodes
  parameter NOP= 0, MOV = 13, MVN = 15, ADD = 4, ADC = 5, SUB = 2, SBC = 6, AND = 0, ORR= 12, EOR = 1,
            CMP = 10, TST = 8, LDR = 4, STR = 4, BRANCH = 4'bx;

  wire is_arithmetic_mode, is_memop_mode, is_branch_mode;
  assign is_arithmetic_mode = mode == ARITHMETIC;
  assign is_memop_mode = mode == MEMOP;
  assign is_branch_mode = mode == BR;

  assign MEM_R_EN = is_memop_mode && s == 1'b1;
  assign MEM_W_EN = is_memop_mode && s == 1'b0;

  assign WB_EN = (is_arithmetic_mode && (opCode != CMP  && opCode != TST )) || 
                  (is_memop_mode && s == 1'b1);

  assign EXE_CMD =  (is_arithmetic_mode) ? 
                      opCode == MOV ? ALU_MOV : 
                      opCode == MVN  ? ALU_MVN:
                      opCode == ADD  ? ALU_ADD:
                      opCode == ADC ? ALU_ADC  :
                      opCode == SUB  ? ALU_SUB  :  
                      opCode == SBC ? ALU_SBC  :
                      opCode == AND ? ALU_AND  : 
                      opCode == ORR ? ALU_ORR  :
                      opCode == EOR ? ALU_EOR  :
                      opCode == CMP ? ALU_CMP   :
                      opCode == TST ? ALU_TST    : 4'bx
                  : (is_memop_mode && opCode == LDR) ? ALU_LDR
                  : (mode == BR) ? ALU_BRANCH : 4'bx;

  assign B = (is_branch_mode);

  assign S = mode== ARITHMETIC ? ((opCode == CMP || opCode == TST ) ? 1'b1 : s) :
              is_memop_mode ? s : 1'b0;

  assign Imm = is_arithmetic_mode ? i : (is_branch_mode  ? 1'b1 : 1'b0);

endmodule