module ALU_8(input [7:0] A,input [7:0] B,input clk, input cin,
input [3:0] s, output  A_EQUAL_B,output  A_GREATER_B,output  A_SMALLER_B , 
output  CARRY,output  ZERO , output  OVERFLOW ,output [7:0]F);

reg en_AR,en_LO,en_SH;
wire [7:0]F_AR,F_LO,F_SH;
wire [7:0] F_CON;

ARITH obj1(.en(en_AR),.A(A),.B(B),.cin(cin),.s(s[1:0]),.OVERFLOW(OVERFLOW),.F_AR(F_AR),.CARRY(CARRY),.A_EQUAL_B(A_EQUAL_B)
,.A_GREATER_B(A_GREATER_B),.A_SMALLER_B(A_SMALLER_B),.zero(ZERO));

LOGIC obj2(.en(en_LO),.A(A),.B(B),.s(s[1:0]),.F_LO(F_LO));

SHIFT obj3(.en(en_SH),.s(s[1:0]),.A(A),.F_SH(F_SH));

CONTROL obj4(.F_LO(F_LO),.F_SH(F_SH),.F_AR(F_AR),.s(s[3:2]),.F_CON(F_CON));

REGISTER obj5(.w(F_CON),.clk(clk),.F_R(F));

//assign F = F_CON;
always @(posedge clk)
begin
case(s[3:2])
2'b00:begin en_AR = 1'b1;en_LO = 1'b0;en_SH=1'b0; end
2'b10:begin en_AR = 1'b0;en_LO = 1'b1;en_SH=1'b0; end
2'b11:begin en_AR = 1'b0;en_LO = 1'b0;en_SH=1'b1; end
endcase
$display("w = %b , F_R = %b", obj5.w,obj5.F_R); 
end
endmodule
//enable for arith &logic&shift

/*

*/