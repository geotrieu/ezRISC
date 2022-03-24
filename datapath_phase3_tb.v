// datapath_phase3_tb.v file:
`timescale 1ns/10ps
module datapath_phase3_tb;

reg fast_clk, reset_n;
wire [31:0] bus_data;
datapath_phase3 the_datapath(
	.fast_clk(fast_clk),
	.reset_n(reset_n),
	.bus_data(bus_data));
 
initial
begin
	fast_clk = 0;
	forever #5 fast_clk = ~fast_clk;
end
initial
begin
	reset_n <= 0;
	#10 reset_n <= 1;
end
endmodule
