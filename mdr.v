module mdr(clk, reset_n, mdr_in, md_mux_select, bus_mux_out, m_data_in, mdr_output);

parameter REG_SIZE = 32;

input clk;
input reset_n;
input mdr_in;
input md_mux_select;
input [REG_SIZE-1:0] bus_mux_out;
input [REG_SIZE-1:0] m_data_in;
output [REG_SIZE-1:0] mdr_output;

wire [REG_SIZE-1:0] mdr_input; // intermediate signal to connect md_mux with mdr_reg's d input

// Choose between bus_mux_out (0) and m_data_in (1) to be D input to MDR
mux_32bit_2to1 md_mux(
	.a(bus_mux_out),
	.b(m_data_in),
	.sel(md_mux_select),
	.out(mdr_input));
// MDR Register
gp_register mdr_reg(clk, reset_n, mdr_in, mdr_input, mdr_output);

endmodule
