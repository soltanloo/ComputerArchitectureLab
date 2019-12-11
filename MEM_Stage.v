module MEM_Stage(
  input clk, rst, MEMread, MEMwrite,
  input[31:0] address, data,
  output[31:0] MEM_result,
  output freeze, // TODO: connect to other stages and registers
  inout[15:0] SRAM_DQ,
  output[17:0] SRAM_ADDR,
  output SRAM_UB_N,
  output SRAM_LB_N,
  output SRAM_WE_N,
  output SRAM_CE_N,
  output SRAM_OE_N
  );

  SRAM_Controller sram_controller(
    .clk(clk),
    .rst(rst),
    .wr_en(MEMwrite),
    .rd_en(MEMread),
    .address(address),
    .writeData(data),
    .readData(MEM_result),
    .ready(freeze),
    .SRAM_DQ(SRAM_DQ),
    .SRAM_ADDR(SRAM_ADDR),
    .SRAM_UB_N(SRAM_UB_N),
    .SRAM_LB_N(SRAM_LB_N),
    .SRAM_WE_N(SRAM_WE_N),
    .SRAM_CE_N(SRAM_CE_N),
    .SRAM_OE_N(SRAM_OE_N)
  );

endmodule