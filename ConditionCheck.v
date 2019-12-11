module ConditionCheck(
  input[3:0] cond, statusReg,
  output hasCondition
);
  reg tempHasCondition;
  wire N, ZE, C, V;
  assign N = statusReg[3];
  assign ZE = statusReg[2];
  assign C = statusReg[1];
  assign V = statusReg[0];

  always @(*) begin
    case (cond)
      4'b0000: tempHasCondition <= ZE == 1'b1;
      4'b0001: tempHasCondition <= ZE == 1'b0;
      4'b0010: tempHasCondition <= C == 1'b1;
      4'b0011: tempHasCondition <= C == 1'b0;
      4'b0100: tempHasCondition <= N == 1'b1;
      4'b0101: tempHasCondition <= N == 1'b0;
      4'b0110: tempHasCondition <= V == 1'b1;
      4'b0111: tempHasCondition <= V == 1'b0;
      4'b1000: tempHasCondition <= C == 1'b1 && ZE == 1'b0;
      4'b1001: tempHasCondition <= C == 1'b0 || ZE == 1'b1;
      4'b1010: tempHasCondition <= N == V;
      4'b1011: tempHasCondition <= N != V;
      4'b1100: tempHasCondition <= ZE == 1'b0 && N == V;
      4'b1101: tempHasCondition <= ZE == 1'b1 || N != V;
      4'b1110: tempHasCondition <= 1'b1;
      default: tempHasCondition <= 1'b0;
    endcase
  end

  assign hasCondition = tempHasCondition;

endmodule
