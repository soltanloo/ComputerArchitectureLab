module MEM_Stage(
  input clk, MEMread, MEMwrite,
  input[31:0] address, data,
  output[31:0] MEM_result
  );

  reg[7:0] registerFile[0:63];
  wire[31:0] tadd;

  wire[31:0] _tadd;
  assign _tadd = (address - 32'd1024);
  assign tadd = {_tadd[31:2], 2'b0};
  
  always @(posedge clk) begin // FIXME: posedge or negedge?
    if (MEMwrite) begin
      registerFile[tadd] <= data[31:24];
      registerFile[tadd + 1] <= data[23:16];
      registerFile[tadd + 2] <= data[15:8];
      registerFile[tadd + 3] <= data[7:0];
      $display("address: %d, result for %d: %d", address, tadd, $signed({registerFile[tadd], registerFile[tadd + 1], registerFile[tadd + 2], registerFile[tadd + 3]}));
      // {registerFile[tadd], registerFile[tadd + 1], registerFile[tadd + 2], registerFile[tadd + 3]} <= data;
    end
  end
  
  
  assign MEM_result = MEMread ? {registerFile[{tadd[31:2], 2'b00}], registerFile[{tadd[31:2], 2'b01}], registerFile[{tadd[31:2], 2'b10}], registerFile[{tadd[31:2], 2'b11}]}
   : MEM_result;

endmodule