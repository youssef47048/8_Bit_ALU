module CONTROL(output [7:0]F_CON, input wire[1:0]s,
input wire [7:0] F_AR,input wire [7:0] F_LO,input wire [7:0] F_SH
);
wire [7:0] FM_LO_SH;
MUX_2_1 LO_SH(.w1(F_LO),.w2(F_SH),.s(s[0]),.F_M(FM_LO_SH));
MUX_2_1 AR_LH(.w1(F_AR),.w2(FM_LO_SH),.s(s[1]),.F_M(F_CON));
endmodule