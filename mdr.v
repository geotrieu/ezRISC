module mdr(clk, reset_n, mdr_in, md_mux_select, bus_mux_out, m_data_in, mdr_output);

parameter REG_SIZE = 32;

input clk;
input reset_n;
input mdr_in;
input md_mux_select;
input [REG_SIZE-1:0] bus_mux_out;
input [REG_SIZE-1:0] m_data_in;
output reg [REG_SIZE-1:0] mdr_output;

reg [REG_SIZE-1:0] mdr_input;

mux_32bit_2to1 md_mux[REG_SIZE-1:0](bus_mux_out, m_data_in, md_mux_select, mdr_input);
gp_register mdr_reg[REG_SIZE-1:0](clk, reset_n, mdr_in, mdr_input, mdr_output);

endmodule