module ALU(input signed [31:0] in1, in2, input[3:0] EXE_CMD, input c, output N, Z, C, V,
  output reg signed[31:0] out);

    parameter ALU_MOV = 1, ALU_MVN = 9, ALU_ADD = 2, ALU_ADC = 3, ALU_SUB = 4,
            ALU_SBC = 5, ALU_AND = 6, ALU_ORR= 7, ALU_EOR = 8,
            ALU_CMP = 4, ALU_TST = 6, ALU_LDR = 2, ALU_STR = 2, ALU_BRANCH = 4'bx;

    reg rC;
  always @(*) begin
    out = 32'sb0;
    rC = 0;
    case (EXE_CMD)
        ALU_MOV: out = in2;
        ALU_MVN: out = ~in2;
        ALU_ADD: {rC, out} = in1 + in2;
        ALU_ADC: {rC, out} = in1 + in2 + c;
        ALU_SUB: {rC, out} = in1 - in2;
        ALU_SBC: {rC, out} = in1 - in2 - c;
        ALU_EOR: out = in1 ^ in2;
        ALU_AND: out = in1 & in2;
        ALU_ORR: out = in1 | in2;
        ALU_CMP: out = in1 - in2;
        ALU_TST: out = in1 & in2;
        ALU_LDR: out = in1 + in2;
    endcase
  end

  assign Z = out == 16'b0 ? 1 : 0;
  assign N = out < 0 ? 1 : 0;
  assign V = in1[31] == (in2[31] ^ (EXE_CMD == ALU_SUB)) && out[31] != in1[31];
  assign C = rC;

endmodule

module ALUTB();
	reg signed [31:0] a, b;
	reg[3:0] op;
    reg c;
	wire signed [31:0] o;
	wire Z, C, N, V;

    parameter ALU_MOV = 1, ALU_MVN = 9, ALU_ADD = 2, ALU_ADC = 3, ALU_SUB = 4,
        ALU_SBC = 5, ALU_AND = 6, ALU_ORR= 7, ALU_EOR = 8,
        ALU_CMP = 4, ALU_TST = 6, ALU_LDR = 2, ALU_STR = 2, ALU_BRANCH = 4'bx;

	
	ALU al(a, b, op, c, N, Z, C, V, o);
	initial begin
	a = -12; b = 20; op = 4'b0; c = 0;
	#10 op = ALU_MOV;
	#10 op = ALU_ADD;
	#10 op = ALU_ADC;
	#10 op = ALU_TST;
	#10 op = ALU_SBC;
	#10 $stop;
	end
endmodule