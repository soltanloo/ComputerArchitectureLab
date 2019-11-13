module MEM_Stage_Reg(
  input clk, rst, WB_en_in, MEM_R_en_in,
  input[31:0] ALU_result_in, Mem_read_value_in,
  input[3:0] Dest_in,
  output reg WB_en, MEM_R_en,
  output reg[31:0] ALU_result, Mem_read_value,
  output reg[3:0] Dest
);

  always@(posedge clk, posedge rst) begin
    if(rst) begin
      PC <= 0;
    end
    else begin
      PC <= PC_in;
    end
  end

endmodule