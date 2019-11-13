module MEM_Stage(
  input clk, MEMread, MEMwrite
  input[31:0] address, data,
  output[31:0] MEM_result
  );

  reg[31:0] registerFile[0:63];
  
  integer i;
  always @(negedge clk, posedge rst) begin
    if (rst) begin
      for (i = 0; i < 15; i= i + 1) begin
        registerFile[i] <= 32'b0;
      end
    end
    else if (MEMwrite) begin
      registerFile[address] <= data;
    end
  end

  assign MEM_result = MEMread ? registerFile[(address - 1024)[31:2]] : MEM_result;

endmodule