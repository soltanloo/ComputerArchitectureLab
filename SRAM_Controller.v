module SRAM_Controller(
  input clk,
  input rst,
  input wr_en,
  input rd_en,
  input[31:0] address,
  input[31:0] writeData,
  output[31:0] readData,
  output ready,
  inout[15:0] SRAM_DQ,
  output[17:0] SRAM_ADDR,
  output SRAM_UB_N,
  output SRAM_LB_N,
  output SRAM_WE_N,
  output SRAM_CE_N,
  output SRAM_OE_N
);
  reg _WE;
  reg[31:0] readDataBuffer;
  reg[2:0] count;
  wire[31:0] _newAddr, newAddr;
  assign _newAddr = (address - 32'd1024);
  assign newAddr = {_newAddr[31:1], 1'b0};

  always @(posedge clk, posedge rst) begin
    if(rst) begin
      count <= 0;
    end
    else if(count == 6) begin
      count <= 0;
    end
    else begin
      if (wr_en) begin
        case (count)
          1: SRAM_DQ <= writeData[15:0]; SRAM_ADDR <= newAddr; SRAM_WE_N <= 0;
          2: SRAM_DQ <= writeData[31:16]; SRAM_ADDR <= (newAddr + 1); SRAM_WE_N <= 0;
          default: SRAM_WE_N <= 1;
        endcase
        count <=count + 1;
      end
      if (rd_en) begin
        SRAM_DQ <= 16'bZ;
        case (count)
          1: SRAM_ADDR <= {newAddr[31:1], 1'b0}; SRAM_WE_N <= 1;
          2: readDataBuffer[15:0] <= SRAM_DQ; SRAM_ADDR <= {newAddr[31:1], 1'b1}; SRAM_WE_N <= 1;
          3: readDataBuffer[31:16] <= SRAM_DQ; SRAM_WE_N <= 1;
          default: SRAM_WE_N <= 1;
        endcase
        count <=count + 1;
      end
    end
  end

  assign ready = ~((wr_en || rd_en) && (count < 6)); // FIXME: not sure
  assign SRAM_UB_N = 0;
  assign SRAM_LB_N = 0;
  assign SRAM_CE_N = 0;
  assign SRAM_OE_N = 0;
  assign SRAM_WE_N = _WE;

endmodule