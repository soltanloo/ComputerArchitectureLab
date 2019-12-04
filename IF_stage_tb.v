module iftb();
reg clk = 0, rst, freeze, Branch_taken;

reg[31:0] BranchAddr= 0;
wire[31:0] PC, Instruction;
IF_Stage ifstage(
  clk, rst, 0, 0,
  BranchAddr,
  PC, Instruction
);

always begin
    #3 clk = ~clk;
end
 initial begin
 rst    = 0;

  #5 rst = 1;
  #10 rst = 0;
  #300 $stop;
  $display( "%d;", PC);
  end
endmodule