module XOR_gate(input A, input B, output Y);
    assign Y = A ^ B;
endmodule

module AND_gate(input A, input B, output Y);
    assign Y = A & B;
endmodule

module OR_gate(input A, input B, output Y);
    assign Y = A | B;
endmodule

module NOT_gate(input A, output Y);
    assign Y = ~A;
endmodule

module FullAdder(input A, input B, input Cin, output Sum, output Cout);
    // XOR gates for sum and intermediate carry
    XOR_gate xor1(A, B, S0);
    XOR_gate xor2(S0, Cin, Sum);

    // AND gates for generating carries
    AND_gate and1(A, B, C1);
    AND_gate and2(S0, Cin, C2);
    AND_gate and3(A, Cin, C3);

    // OR gates for final carry-out
    OR_gate or1(C1, C2, C4);
    OR_gate or2(C3, C4, Cout);
endmodule

module EightBitFullAdder(input [7:0] A, input [7:0] B, input Cin, output [7:0] Sum, output Cout,output OVERFLOW);
    wire [7:0] C;

    // Instantiate eight full adders
    FullAdder f0(A[0], B[0], Cin, Sum[0], C[0]);
    FullAdder f1(A[1], B[1], C[0], Sum[1], C[1]);
    FullAdder f2(A[2], B[2], C[1], Sum[2], C[2]);
    FullAdder f3(A[3], B[3], C[2], Sum[3], C[3]);
    FullAdder f4(A[4], B[4], C[3], Sum[4], C[4]);
    FullAdder f5(A[5], B[5], C[4], Sum[5], C[5]);
    FullAdder f6(A[6], B[6], C[5], Sum[6], C[6]);
    FullAdder f7(A[7], B[7], C[6], Sum[7], Cout);
//assign OVERFLOW = C[6]^Cout;i will do it behav
endmodule

module FullSubtractor(input A, input B, input Bin, output Dif, output Bout);
    wire D1, D2, D3, B1, B2;

    // XOR gates for difference and intermediate borrow
    XOR_gate xor1(A, B, D1);
    XOR_gate xor2(D1, Bin, Dif);

    // AND gates for generating borrows
    AND_gate and1(~A, B, B1);
    AND_gate and2(~D1, Bin, B2);
    AND_gate and3(A, Bin, D2);

    // OR gates for final borrow-out
    OR_gate or1(B1, B2, Bout);
    OR_gate or2(D2, Bout, D3);
endmodule

module EightBitFullSubtractor(input [7:0] A, input [7:0] B, input Bin, output [7:0] Dif, output Bout,output OVERFLOW);
    wire [7:0] Bouts;

    // Instantiate eight full subtractors
    FullSubtractor fs0(A[0], B[0], Bin, Dif[0], Bouts[0]);
    FullSubtractor fs1(A[1], B[1], Bouts[0], Dif[1], Bouts[1]);
    FullSubtractor fs2(A[2], B[2], Bouts[1], Dif[2], Bouts[2]);
    FullSubtractor fs3(A[3], B[3], Bouts[2], Dif[3], Bouts[3]);
    FullSubtractor fs4(A[4], B[4], Bouts[3], Dif[4], Bouts[4]);
    FullSubtractor fs5(A[5], B[5], Bouts[4], Dif[5], Bouts[5]);
    FullSubtractor fs6(A[6], B[6], Bouts[5], Dif[6], Bouts[6]);
    FullSubtractor fs7(A[7], B[7], Bouts[6], Dif[7], Bout);
//xor (OVERFLOW,Bouts[6],Bout);i will do it behav
endmodule

module TwosComplement(input [7:0] A, output [7:0] TwosComp ,output T_C,output OVERFLOW);
    wire [7:0] onesComplement;
    wire [7:0] C;
  
    // ones' complement using XOR gates
XOR_gate xor0(A[0], 1'b1, onesComplement[0]);
XOR_gate xor1(A[1], 1'b1, onesComplement[1]);
XOR_gate xor2(A[2], 1'b1, onesComplement[2]);
XOR_gate xor3(A[3], 1'b1, onesComplement[3]);
XOR_gate xor4(A[4], 1'b1, onesComplement[4]);
XOR_gate xor5(A[5], 1'b1, onesComplement[5]);
XOR_gate xor6(A[6], 1'b1, onesComplement[6]);
XOR_gate xor7(A[7], 1'b1, onesComplement[7]);

FullAdder fa0(onesComplement[0], 1'b1, 1'b0, TwosComp[0], C[0]);
FullAdder fa1(onesComplement[1], 1'b0, C[0], TwosComp[1], C[1]);
FullAdder fa2(onesComplement[2], 1'b0, C[1], TwosComp[2], C[2]);
FullAdder fa3(onesComplement[3], 1'b0, C[2], TwosComp[3], C[3]);
FullAdder fa4(onesComplement[4], 1'b0, C[3], TwosComp[4], C[4]);
FullAdder fa5(onesComplement[5], 1'b0, C[4], TwosComp[5], C[5]);
FullAdder fa6(onesComplement[6], 1'b0, C[5], TwosComp[6], C[6]);
FullAdder fa7(onesComplement[7], 1'b0, C[6], TwosComp[7], T_C);
//assign OVERFLOW = C[6]^T_C;i will do it behav
endmodule


module ARITH(input  en,input [7:0] A, input [7:0] B, input cin ,
 input [1:0]s,output reg OVERFLOW, output reg [7:0] F_AR ,output reg CARRY ,
output reg A_EQUAL_B,output reg A_GREATER_B,output reg A_SMALLER_B,
output reg zero
);
wire [7:0] Sum;
wire Cout,oa;
wire [7:0] Subtr;
wire Bout,os;
wire [7:0] TwosComp;
wire T_C,ot;

// Instantiate the 8-bit full adder
EightBitFullAdder fa(A, B, cin, Sum,Cout,oa);
EightBitFullSubtractor sub(A,B,cin,Subtr,Bout,os);
TwosComplement tw(B,TwosComp,T_C,ot);
always @(*)

begin
if(en == 1'b1)begin
A_EQUAL_B <= (A==B ? 1'b1:1'b0);
A_GREATER_B <= (A>B ? 1'b1:1'b0);
A_SMALLER_B <= (A<B ? 1'b1:1'b0);
if(en)begin

end
case(s)
2'b00: begin 
F_AR <= Sum;
CARRY <= Cout;
OVERFLOW <= oa;

end
2'b01:begin
 F_AR <= Subtr;
CARRY <= Bout;
OVERFLOW <= os;
end
2'b11: begin
F_AR <= TwosComp;
CARRY <= T_C;
OVERFLOW <= ot;
end
endcase
if(~F_AR[7]&A[7]&B[7])OVERFLOW <= 1'b1;///COMMENT
	else OVERFLOW <= 1'b0;
zero <= (F_AR==8'b0 ? 1'b1:1'b0);
end
end
endmodule
