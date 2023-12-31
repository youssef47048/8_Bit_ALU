module LOGIC(input  en,input [7:0]A,input [7:0]B,input [1:0]s,
output reg [7:0]F_LO
);
always @(*)
begin
if(en == 1'b1)begin
	if(s[1:0] == 2'b00)
	begin
	F_LO <= A&B;
	end
	if(s[1:0] == 2'b01)
	begin
	F_LO <= A^B;
	end
	if(s[1:0] == 2'b10)
	begin
	F_LO <= A|B;
	end
	if(s[1:0] == 2'b11)
	begin
	F_LO <= ~B;
	end
end
end
endmodule