
module ALU_8(input [7:0] A,input [7:0] B,input clk, input cin,
input [3:0] s, output reg A_EQUAL_B,output reg A_GREATER_B,output reg A_SMALLER_B , 
output reg CARRY,output reg ZERO , output reg OVERFLOW ,
output reg[7:0] F);

always @(posedge clk)
begin
//ARITHMETIC
if(s[3:2] == 2'b00)
begin
A_EQUAL_B <= (A==B ? 1'b1:1'b0);
A_GREATER_B <= (A>B ? 1'b1:1'b0);
A_SMALLER_B <= (A<B ? 1'b1:1'b0);
//A+B
	if(s[1:0] == 2'b00)
	begin
	{CARRY,F} <= A+B+cin;  
	if(F==8'b0)ZERO <= 1'b1;
	else ZERO <= 1'b0;
	if(~F[7]&A[7]&B[7])OVERFLOW <= 1'b1;///COMMENT
	else OVERFLOW <= 1'b0;
	end
//A-B
	else if(s[1:0] == 2'b01)
	begin
	{CARRY,F} <= A-B;
	ZERO <= (F==8'b0 ? 1'b1:1'b0);
	if(~F[7]&A[7]&B[7])OVERFLOW <= 1'b1;///COMMENT
	else OVERFLOW <= 1'b0;
	end
//2's complement 
	else if(s[1:0] == 2'b11)
	begin
	{CARRY,F} <= ~B+8'b00000001;
	ZERO <= (F==8'b0 ? 1'b1:1'b0);
	if(~F[7]&A[7]&B[7])OVERFLOW <= 1'b1;///COMMENT
	else OVERFLOW <= 1'b0;
	end
end

//LOGIC UNIT
else if(s[3:2] == 2'b10)
begin
	if(s[1:0] == 2'b00)
	begin
	F <= A&B;
	end
	if(s[1:0] == 2'b01)
	begin
	F <= A^B;
	end
	if(s[1:0] == 2'b10)
	begin
	F <= A|B;
	end
	if(s[1:0] == 2'b11)
	begin
	F <= ~B;
	end
	
end
//shift UNIT
else if(s[3:2] == 2'b11)
begin
//right rotate
	if(s[1:0] == 2'b00)
	begin
	F <= {A[0],A[7:1]};
	end
	//left rotate
	if(s[1:0] == 2'b01)
	begin
	F <= {A[6:0],A[7]};
	end
	//right shift
	if(s[1:0] == 2'b10)
	begin
	F <=  A>>1;
	end
	//left shift
	if(s[1:0] == 2'b11)
	begin
	F <=  A<<1;
	end
end

end
endmodule


module ALU_8_tb();
reg cin , clk;
reg [7:0] A;
reg [7:0] B;
reg [3:0] S;
wire [7:0] F;
wire  A_EQUAL_B, A_GREATER_B, A_SMALLER_B , CARRY, ZERO ,  OVERFLOW ;

ALU_8 obj(.A(A), .B(B),.cin(cin), .s(S),.F(F),.OVERFLOW(OVERFLOW),.ZERO(ZERO),.CARRY(CARRY),
.A_SMALLER_B(A_SMALLER_B),.A_GREATER_B(A_GREATER_B),.A_EQUAL_B(A_EQUAL_B),.clk(clk));

initial begin
    clk = 1;
    forever #1 clk = ~clk; // Invert every 5 time units (adjust as needed)
  end

initial
begin
A = 8'b11111111; B = 8'b11111111; cin = 1'b0; S = 4'b0000; //ADD carry = 1
#2
check(8'b11111110);
A = 8'b00000010; B = 8'b00000011;cin = 1'b0  ; S = 4'b0001; //SUB  2-3
#2
check('b11111111);
A = 8'b00000010; B = 8'b00000011; S = 4'b0011; //2's complement
#2
check(8'b11111101);
A = 8'b00000010;B=8'b00000011; S = 4'b1000; //AND
#2
check(8'b00000010);
A = 8'b00000010;B=8'b00000011; S = 4'b1001; //XOR
#2
check(8'b00000001);
A = 8'b00000010;B=8'b00000011; S = 4'b1010; //OR
#2
check(8'b00000011);
A = 8'b00000010;B=8'b00000011; S = 4'b1011; //1's complement
#2
check(8'b11111100);
A = 8'b00000010;B=8'b00000011; S = 4'b1100; //right rotate
#2
check(8'b00000001);
A= 8'b00000010;B=8'b00000011; S = 4'b1101; //left rotate
#2
check(8'b00000100);

A = 8'b00000010;B=8'b00000011; S = 4'b1110; //right shift
#2
check(8'b00000001);

A = 8'b00000010;B=8'b00000011; S = 4'b1111; //left shift
#2
check(8'b00000100);
   end

task check (input[7:0] out);
begin
if (out == F)
 $display("Test case is successful for F = %b and S = %b,OVERFLOW = %b , ZERO = %b , CARRY = %b , A_SMALLER_B = %b , A_GREATER_B = %b , A_EQUAL_B = %b"
, F, S,OVERFLOW,ZERO,CARRY,A_SMALLER_B,A_GREATER_B,A_EQUAL_B);
else
$display("Test case is failed for A = %b, B = %b, S = %b, F = %b , OUT = %B", A, B, S, F,out);
end
endtask
endmodule
