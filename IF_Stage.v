module IF_Stage(
  input clk, rst, freeze, Branch_taken,
  input[31:0] BranchAddr,
  output[31:0] PC, Instruction
);

  wire[31:0] pcMem[0:5];
  wire[31:0] pc_in, pc_out;

  assign pcMem[0] = 32'b00000000001000100000000000000000;
  assign pcMem[1] = 32'b000000_00011_00100_00000_00000000000;
  assign pcMem[2] = 32'b000000_00101_00110_00000_00000000000;
  assign pcMem[3] = 32'b000000_00111_01000_00010_00000000000;
  assign pcMem[4] = 32'b000000_01001_01010_00011_00000000000;
  assign pcMem[5] = 32'b000000_01101_01110_00000_00000000000;

  reg32 pc(.clk(clk), .rst(rst), .en(~freeze), .reg_in(pc_in), .reg_out(pc_out))
  assign PC = pc_out + 4;
  assign pc_in = Branch_taken ? BranchAddr : PC;
  assign Instruction = freeze ? pcMem[PC] : 32'bz;
  

endmodule