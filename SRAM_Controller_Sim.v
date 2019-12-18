module SRAM_Controller_Sim(
  input clk,
  input rst,
  input wr_en,
  input rd_en,
  input[31:0] address,
  input[31:0] writeData,
  output reg[31:0] readData,
  output ready,
  inout[15:0] SRAM_DQ,
  output reg[17:0] SRAM_ADDR,
  output SRAM_UB_N,
  output SRAM_LB_N,
  output reg SRAM_WE_N,
  output SRAM_CE_N,
  output SRAM_OE_N
);
  parameter COUNT_LOAD = 3'd2;
  wire[2:0] cout, lgCount;
  wire carry;
  wire[31:0] _newAddr, newAddr;
  assign _newAddr = (address - 32'd1024);
  assign newAddr = {_newAddr[31:2], 2'b0};  // TODO not sure

  reg[15:0] OUT_SRAM_DQ;
  Counter3bit counter(
    .clk(clk),
    .rst(rst),
    .en(rd_en | wr_en),
    .ld(COUNT_LOAD),
    .cout(cout),
    .c(carry)
  );

  assign lgCount = cout - COUNT_LOAD;
  always @(*) begin
    case(lgCount)
      3'd0: begin
        SRAM_WE_N = wr_en ? 1'b0 : 1'b1;
        SRAM_ADDR = newAddr >> 1;
        OUT_SRAM_DQ = wr_en ? writeData[15:0] : 16'bz;
      end
      3'd1: begin
        SRAM_WE_N = wr_en ? 1'b0 : 1'b1;
        SRAM_ADDR = (newAddr >> 1) + 1;
        OUT_SRAM_DQ = wr_en ? writeData[31:16] : 16'bz;
        readData[15:0] = SRAM_DQ[15:0];
      end
      3'd2: begin
        SRAM_WE_N = wr_en ? 1'b0 : 1'b1;
        readData[31:16] = SRAM_DQ[15:0];
      end
      default: begin
        SRAM_WE_N = 1'b1;
        OUT_SRAM_DQ = 16'bz;
        SRAM_ADDR = newAddr >> 1;
      end
    endcase
  end

  assign ready = ~((wr_en || rd_en) && (cout != 3'd7)); // FIXME: not sure
  assign SRAM_UB_N = 0;
  assign SRAM_LB_N = 0;
  assign SRAM_CE_N = 0;
  assign SRAM_OE_N = 0;
  assign SRAM_DQ = SRAM_WE_N ? 16'bz : OUT_SRAM_DQ;

endmodule