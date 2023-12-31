module SHIFT(
input  en,input [1:0] s,input[7:0]A,
output reg [7:0]F_SH
);

always @(*)
begin
if(en == 1'b1)begin
if(s[1:0] == 2'b00)
	begin
	F_SH <= {A[0],A[7:1]};
	end
	//left rotate
	if(s[1:0] == 2'b01)
	begin
	F_SH <= {A[6:0],A[7]};
	end
	//right shift
	if(s[1:0] == 2'b10)
	begin
	F_SH <=  A>>1;
	end
	//left shift
	if(s[1:0] == 2'b11)
	begin
	F_SH <=  A<<1;
	end

end
end
endmodule