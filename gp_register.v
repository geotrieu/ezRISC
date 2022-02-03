module gp_register(clk, reset_n, le, d, q);

parameter REG_SIZE = 32;

input clk;
input	reset_n;
input le;
input	[REG_SIZE-1:0] d;
output reg [REG_SIZE-1:0] q;

always @(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		q <= {REG_SIZE{1'b0}}; //q <= (OTHERS => '0') in VHDL
	else if(clk)	begin
		if(le)
			q <= d;
	end
end

endmodule
		