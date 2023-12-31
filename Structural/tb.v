//include"H:\AUC_training\projects\model_sim\ALU_16_12\ALU_ST";

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

A = 8'b11111111; B = 8'b11111111; cin = 1'b0; S = 4'b0000; //ADD
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
