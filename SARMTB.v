module SARMTB();
reg clk = 0;
reg rst = 0;
wire SRAM_WE_N;
wire[17:0] SRAM_ADDR;
wire[15:0] _SRAM_DQ;

SARM arm(
  .clk(clk),
  .rst(rst),
  .SRAM_DQ(_SRAM_DQ),						//	SRAM Data bus 16 Bits
  .SRAM_ADDR(SRAM_ADDR),						//	SRAM Address bus 18 Bits
  .SRAM_WE_N(SRAM_WE_N)						//	SRAM Write Enable
);

ExternalMem exmem (
    .SRAM_DQ(_SRAM_DQ),						//	SRAM Data bus 16 Bits
		.SRAM_ADDR(SRAM_ADDR),						//	SRAM Address bus 18 Bits
		.SRAM_WE_N(SRAM_WE_N),						//	SRAM Write Enable
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