module MEM_Stage_Reg(
  input clk,
  input rst,
  input[31:0] PC_in,
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