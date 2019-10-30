module reg4neg(input clk, rst, en, input[3:0] reg_in, output reg[3:0] reg_out);

    always @(negedge clk, posedge rst) begin
        if (rst) reg_out <= 4'd0;
        else begin
            if (en) reg_out <= reg_in;
        end
    end

endmodule