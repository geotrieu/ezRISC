module con_ff(clk, reset_n, con_in, ir, bus_data, con_out);

parameter REG_SIZE = 32;

input clk;
input reset_n;
input con_in;
input [REG_SIZE - 1:0] ir;
input [REG_SIZE - 1:0] bus_data;

output con_out;

wire [3:0] ir_c2;
assign ir_c2 = ir[22:19];

wire [3:0] decoder_out;

dec_2to4 decoder(
	.code(ir_c2[1:0]),
	.out(decoder_out));
	
wire equals_zero;
assign equals_zero = decoder_out[0] & ~(|bus_data);
wire not_equals_zero;
assign not_equals_zero = decoder_out[1] & (|bus_data);
wire greater_than_zero;
assign greater_than_zero = decoder_out[2] & ~(bus_data[31]);
wire less_than_zero;
assign less_than_zero = decoder_out[3] & bus_data[31];

wire con_reg_d;
assign con_reg_d = equals_zero | not_equals_zero | greater_than_zero | less_than_zero;

wire con_reg_q;

gp_register #(.GP_REG_SIZE(1)) con(clk, reset_n, con_in, con_reg_d, con_reg_q);

assign con_out = con_reg_q;

endmodule
