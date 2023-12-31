module MUX_2_1(
input  [7:0] w1,input [7:0] w2,input s,
output [7:0] F_M
);
 assign F_M = ((s) ? w2:w1);




endmodule
