module IF_Stage(
  input clk, rst, freeze, Branch_taken,
  input[31:0] BranchAddr,
  output[31:0] PC, Instruction,
  output out_clk
);
  
  assign out_clk = clk;
  wire[31:0] pc_in, pc_out;
  reg[31:0] ins;
  

  always @( * ) begin
    case (pc_out)
      0: ins <= 32'b000000_00001_00010_00000_00000000000;
      1: ins <= 32'b000000_00011_00100_00000_00000000000;
      2: ins <= 32'b000000_00101_00110_00000_00000000000;
      3: ins <= 32'b000000_00111_01000_00010_00000000000;
      4: ins <= 32'b000000_01001_01010_00011_00000000000;
      5: ins <= 32'b000000_01101_01110_00000_00000000000;
      default: ins <= 32'b000000_01101_01110_00000_00000000000;
    endcase
  end
  assign Instruction= ins;

  reg32 pc(.clk(clk), .rst(rst), .en(~freeze), .reg_in(pc_in), .reg_out(pc_out));
  assign PC = pc_out + 1;
  assign pc_in = Branch_taken ? BranchAddr : pc_out >= 32'd5 ? 0 : PC ;


endmodule