module reg32(input clk, rst, en, input[31:0] reg_in, output reg[31:0] reg_out);

    always @(posedge clk, posedge rst) begin
        if (rst) reg_out <= 32'd0;
        else begin
            if (en) reg_out <= reg_in;
        end
    end

endmodule

module reg4neg(input clk, rst, en, input[3:0] reg_in, output reg[3:0] reg_out);

    always @(negedge clk, posedge rst) begin
        if (rst) reg_out <= 4'd0;
        else begin
            if (en) reg_out <= reg_in;
        end
    end

endmodule