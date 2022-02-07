module divider_non_restoring(Quotient, Dividend, Divisor);
parameter REG_SIZE = 32;

input [REG_SIZE-1:0] Dividend;
input [REG_SIZE-1:0] Divisor;

reg [REG_SIZE + REG_SIZE - 1:0] A;
reg [REG_SIZE + REG_SIZE - 1:0] M;
reg [REG_SIZE + REG_SIZE - 1:0] intermediate;
reg [REG_SIZE-1:0] Q;
output [REG_SIZE-1:0] Quotient;

integer i;
always @(*)
begin
	Q = 0;
	A = {32'b0, Dividend};
	M = {1'b0, Divisor, 31'b0};
	i = 0;
	while (M >= Divisor && M != 0) begin
		i = i + 1;
		intermediate = A - M;
		Q = Q << 1;
		
		if(intermediate[63] != 1) begin
			A = intermediate;
			Q[0] = 1'b1;
		
		end
		M = M >> 1;
		
	end
end
assign Quotient = Q; 
endmodule	
	