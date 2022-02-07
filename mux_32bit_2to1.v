module mux_32bit_2to1 #(parameter REG_SIZE=32)(
	input [REG_SIZE-1:0] a,
	input [REG_SIZE-1:0] b,
	input sel,
	output [REG_SIZE-1:0] out
);

assign out = sel ? b : a;

endmodule
