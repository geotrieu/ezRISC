// datapath_phase3_tb.v file:
`timescale 1ns/10ps
module datapath_phase3_tb;

reg fast_clk, reset_n;
wire [7:0] seven_seg_out_1;
wire [7:0] seven_seg_out_2;
wire stop;
assign stop = 0;
wire run;
datapath_phase3 the_datapath(
	.fast_clk(fast_clk),
	.reset_n(reset_n),
	.stop(stop),
	.run(run),
	.inport_ext_input(32'h88),
	.seven_seg_out_1(seven_seg_out_1),
	.seven_seg_out_2(seven_seg_out_2));
 
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
