module MEM_Stage(
  input clk, MEMread, MEMwrite
  input[31:0] address, data,
  output[31:0] MEM_result
  );

  reg[31:0] registerFile[0:63];
  
  integer i;
  always @(posedge clk) begin // FIXME: posedge or negedge?
    if (MEMwrite) begin
      registerFile[address] <= data;
    end
  end

  assign MEM_result = MEMread ? registerFile[(address - 1024)[31:2]] : MEM_result;

endmodule