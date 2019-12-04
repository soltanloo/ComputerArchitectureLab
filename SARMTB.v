module SARMTB();
reg clk = 0;
reg rst = 0;

SARM arm(
  .clk(clk),
  .rst(rst)
);

always begin
    #3 clk = ~clk;
end
 initial begin
  rst    = 0;
  #5 rst = 1;
  #10 rst = 0;
  #100000 $stop;
  end
endmodule