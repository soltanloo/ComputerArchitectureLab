module Counter3bit(input clk, rst, en, input[2:0] ld, output reg[2:0] cout, output reg c);

    always @(posedge clk, negedge rst) begin
        if (rst) {c, cout} <= {1'b0, ld};
        else if (en) begin
            if (cout == 3'd7)  {c, cout} <= {1'b1, ld};
            else {c, cout} <= cout + 3'd1;
        end
    end
endmodule