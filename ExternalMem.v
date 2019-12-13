module ExternalMem (
        SRAM_DQ,						//	SRAM Data bus 16 Bits
		SRAM_ADDR,						//	SRAM Address bus 18 Bits
		SRAM_WE_N,						//	SRAM Write Enable
        clk,
        rst
);
    inout	 [15:0]	SRAM_DQ;				//	SRAM Data bus 16 Bits
    input [5:0]	SRAM_ADDR;				//	SRAM Address bus 18 Bits
    input			SRAM_WE_N;				//	SRAM Write Enable
    input clk;
    input rst;

    reg [15:0] _SRAM_DQ;
    reg [15:0] mem[0:63];

    always @(posedge clk, negedge rst) begin
        if (~SRAM_WE_N) begin
            mem[SRAM_ADDR] <= SRAM_DQ; 
        end
        else begin
            _SRAM_DQ <= mem[SRAM_ADDR];
        end 
    end

    assign SRAM_DQ = SRAM_WE_N ? _SRAM_DQ : 16'bz;  // TODO not sure
endmodule

// TODO write testbench if necessarry

module sramTB();
    reg clk = 0;
    reg rst = 0;
    reg SRAM_WE_N = 1;
    reg[15:0] SRAM_DQ = 16'bz;
    wire[15:0] _SRAM_DQ;
    reg[17:0] SRAM_ADDR = 18'd0;
    ExternalMem exmem(
    .clk(clk),
    .rst(rst),
    .SRAM_ADDR(SRAM_ADDR),
    .SRAM_DQ(_SRAM_DQ),
    .SRAM_WE_N(SRAM_WE_N)
    );

    
    always begin
        #3 clk = ~clk;
    end
    initial begin
        rst    = 0;
        #5 rst = 1;
        #10 rst = 0;
        #10 SRAM_DQ = 16'd213;
        SRAM_WE_N = 0;
        #10 SRAM_ADDR = 16'd2;
        SRAM_DQ = 16'd8472;
        #10 SRAM_ADDR = 16'd0;
        SRAM_DQ = 16'bz;
        SRAM_WE_N = 1;
        #10 SRAM_ADDR = 16'd1;
        #10 SRAM_ADDR = 16'd2;
        #100000 $stop;
    end
    assign _SRAM_DQ = SRAM_DQ;
endmodule