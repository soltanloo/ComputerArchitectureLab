module Cache_Controller(
    input clk, rst, en, 
    input[31:0] _address, wdata,
    input MEM_R_EN, MEM_W_EN,
    output [31:0] rdata, 
    output ready,

    inout[15:0] SRAM_DQ,
    output[17:0] SRAM_ADDR,
    output SRAM_UB_N,
    output SRAM_LB_N,
    output SRAM_WE_N,
    output SRAM_CE_N,
    output SRAM_OE_N,
    output hit

);

    wire[18:0] address;
    assign address = _address[18:0]; 

    parameter NUM_OF_SETS = 64;
    parameter CACHE_SIZE_KB = 1024;
    parameter NUM_OF_BLOCKS = 128;
    parameter BLOCK_SIZE = 64;
    parameter WORD_SIZE = 32;
    parameter ADDRESS_LENGTH = 19;
    parameter TAG_LENGTH = 10;
    parameter INDEX_LENGTH = 6;
    parameter DATA_LENGTH = 32;

    // LRU + tags + data + valid bits
    parameter LINE_LENGTH= 3 + TAG_LENGTH*2 + DATA_LENGTH*2;
    
    parameter LRU_INDEX_OFFSET= LINE_LENGTH - 1;
    parameter WAY1_VALID_INDEX_OFFSET = LRU_INDEX_OFFSET - 1;
    parameter WAY1_TAG_INDEX_OFFSET = WAY1_VALID_INDEX_OFFSET - 1;
    parameter WAY1_DATA_INDEX_OFFSET = WAY1_TAG_INDEX_OFFSET - TAG_LENGTH;

    parameter WAY2_VALID_INDEX_OFFSET = WAY1_DATA_INDEX_OFFSET - DATA_LENGTH;
    parameter WAY2_TAG_INDEX_OFFSET = WAY2_VALID_INDEX_OFFSET - 1;
    parameter WAY2_DATA_INDEX_OFFSET = WAY2_TAG_INDEX_OFFSET - TAG_LENGTH;

    wire[31:0] sramReadData;
    reg[LINE_LENGTH-1:0] cache[0:63];
    wire[INDEX_LENGTH-1: 0] addressIndex;
    wire[TAG_LENGTH-1: 0] addressTag;

    parameter ADDRESS_INDEX_OFFSET = 18 - TAG_LENGTH;
    assign addressTag = address[18: ADDRESS_INDEX_OFFSET + 1];
    assign addressIndex = 
        address[ADDRESS_INDEX_OFFSET: ADDRESS_INDEX_OFFSET - INDEX_LENGTH - 1];

    wire[LINE_LENGTH-1:0] currentSet;
    assign currentSet = cache[addressIndex];
    
    wire setLRUBit;
    wire[TAG_LENGTH-1:0] way1Tag, way2Tag;
    wire[DATA_LENGTH-1:0] way1Data, way2Data;
    wire way1Valid, way2Valid;

    // parameter T = WAY2_DATA_INDEX_OFFSET;
    // parameter TT = WAY2_DATA_INDEX_OFFSET - DATA_LENGTH - 1;

    assign setLRUBit = currentSet[LRU_INDEX_OFFSET];
    assign way1Tag = currentSet[WAY1_TAG_INDEX_OFFSET: WAY1_TAG_INDEX_OFFSET - (TAG_LENGTH - 1)];
    assign way2Tag = currentSet[WAY2_TAG_INDEX_OFFSET: WAY2_TAG_INDEX_OFFSET - (TAG_LENGTH - 1)];
    assign way1Data = currentSet[WAY1_DATA_INDEX_OFFSET: WAY1_DATA_INDEX_OFFSET - (DATA_LENGTH - 1)];
    assign way2Data = currentSet[WAY2_DATA_INDEX_OFFSET: WAY2_DATA_INDEX_OFFSET - (DATA_LENGTH - 1)];
    assign way1Valid = currentSet[WAY1_VALID_INDEX_OFFSET];
    assign way2Valid = currentSet[WAY2_VALID_INDEX_OFFSET];

    wire way1Hit, way2Hit, boolWay1Hit, boolWay2Hit;
    assign way1Hit = (way1Tag == addressTag) && way1Valid == 1'b1;
    assign way2Hit = (way2Tag == addressTag) && way2Valid == 1'b1;
    assign hit = en && (way1Hit || way2Hit);

    wire[31:0] cacheReadData;
    assign cacheReadData = way1Hit ? way1Data : way2Data;
    assign rdata = hit ? cacheReadData : sramReadData;

    wire cacheFreeze, memReady;
    assign cacheFreeze = ~memReady && ~(MEM_R_EN && hit);  // TODO hit ?
    assign ready = ~cacheFreeze;

    wire sram_write, sram_read;
    assign sram_read = MEM_R_EN && ~hit;
    assign sram_write = MEM_W_EN;   // TODO not sure
    
    integer i;

    always @(posedge clk, posedge rst) begin

        if (rst) begin
            for (i = 0; i <= 63; i= i + 1) begin
                cache[i] <= 0;
            end
        end
        else begin
        if (MEM_R_EN) begin
            // $display("trying to read: %d", address);
            if (hit) begin
                // $display("hit: %d", address);
                cache[addressIndex][LRU_INDEX_OFFSET] <= way2Hit;
            end
            else begin
                // $display("miss: %d", address);
                if (memReady) begin
                    if (cache[addressIndex][LRU_INDEX_OFFSET] == 1'b1) begin
                        // $display("Writing on way1, tag: %d, address: %d, tag offset is %d,%d", addressTag,
                        //     address,
                        //     WAY1_TAG_INDEX_OFFSET,  WAY1_TAG_INDEX_OFFSET - TAG_LENGTH - 1
                        // );
                        cache
                            [addressIndex]
                            [WAY1_TAG_INDEX_OFFSET: WAY1_TAG_INDEX_OFFSET - (TAG_LENGTH - 1)]
                            <= addressTag;
                        cache
                            [addressIndex]
                            [WAY1_DATA_INDEX_OFFSET: WAY1_DATA_INDEX_OFFSET - (DATA_LENGTH - 1)]
                            <= sramReadData;
                        cache
                        [addressIndex]
                            [WAY1_VALID_INDEX_OFFSET] <= 1'b1;
                        cache[addressIndex][LRU_INDEX_OFFSET] <= 1'b0;

                    end
                    else begin
                        // $display("Writing on way2, tag: %d, address: %d, tag offset is %d,%d", addressTag,
                        //     address,
                        //     WAY2_TAG_INDEX_OFFSET,  WAY2_TAG_INDEX_OFFSET - TAG_LENGTH - 1
                        // );
                        // $display("way offsets: %d-%d , %d-%d , %d-%d",
                        //     WAY2_TAG_INDEX_OFFSET, WAY2_TAG_INDEX_OFFSET - TAG_LENGTH - 1,
                        //     WAY2_DATA_INDEX_OFFSET, WAY2_DATA_INDEX_OFFSET - (DATA_LENGTH - 1),
                        //     WAY2_VALID_INDEX_OFFSET, WAY2_VALID_INDEX_OFFSET
                        // );
                        cache
                            [addressIndex]
                            [WAY2_TAG_INDEX_OFFSET: WAY2_TAG_INDEX_OFFSET - (TAG_LENGTH - 1)]
                            <= addressTag;
                        cache
                            [addressIndex]
                            [WAY2_DATA_INDEX_OFFSET: WAY2_DATA_INDEX_OFFSET - (DATA_LENGTH - 1)]
                            <= sramReadData;
                        cache
                        [addressIndex]
                            [WAY2_VALID_INDEX_OFFSET] <= 1'b1;
                        cache[addressIndex][LRU_INDEX_OFFSET] <= 1'b1; // TODO Update on miss ?
                    end
                end
            end
        end
        else if (MEM_W_EN) begin
            if (hit) begin
                if (way1Hit) begin
                    cache
                        [addressIndex]
                        [WAY1_DATA_INDEX_OFFSET: WAY1_DATA_INDEX_OFFSET - (DATA_LENGTH - 1)]
                        <= wdata;

                end
                else begin
                    cache
                        [addressIndex]
                        [WAY2_DATA_INDEX_OFFSET: WAY2_DATA_INDEX_OFFSET - (DATA_LENGTH - 1)]
                        <= wdata;
                    $display("Writing %d to address %d in cache", $signed(wdata), addressIndex);
                end               

            end
            else begin
                // TODO now what ?
            end
        end
        end
    end



 SRAM_Controller sram_controller(
    .clk(clk),
    .rst(rst),
    .wr_en(sram_write),
    .rd_en(sram_read),
    .address(_address),
    .writeData(wdata),
    .readData(sramReadData),
    .ready(memReady),
    .SRAM_DQ(SRAM_DQ),
    .SRAM_ADDR(SRAM_ADDR),
    .SRAM_UB_N(SRAM_UB_N),
    .SRAM_LB_N(SRAM_LB_N),
    .SRAM_WE_N(SRAM_WE_N),
    .SRAM_CE_N(SRAM_CE_N),
    .SRAM_OE_N(SRAM_OE_N)
  );


endmodule