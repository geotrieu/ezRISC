module ezRISC(clk, reset_n);

parameter REG_SIZE = 32;

input clk;
input	reset_n;

wire [15:0] gp_le;
wire pc_le;
wire ir_le;
wire y_le;
wire z_le;
wire mar_le;
wire hi_le;
wire lo_le;
wire mdr_in;

wire md_mux_select;

wire [REG_SIZE-1:0] bus_data;
wire [REG_SIZE-1:0] m_data_in;
wire [REG_SIZE-1:0] mdr_output;

wire [REG_SIZE-1:0] r0_data_out;
wire [REG_SIZE-1:0] r1_data_out;
wire [REG_SIZE-1:0] r2_data_out;
wire [REG_SIZE-1:0] r3_data_out;
wire [REG_SIZE-1:0] r4_data_out;
wire [REG_SIZE-1:0] r5_data_out;
wire [REG_SIZE-1:0] r6_data_out;
wire [REG_SIZE-1:0] r7_data_out;
wire [REG_SIZE-1:0] r8_data_out;
wire [REG_SIZE-1:0] r9_data_out;
wire [REG_SIZE-1:0] r10_data_out;
wire [REG_SIZE-1:0] r11_data_out;
wire [REG_SIZE-1:0] r12_data_out;
wire [REG_SIZE-1:0] r13_data_out;
wire [REG_SIZE-1:0] r14_data_out;
wire [REG_SIZE-1:0] r15_data_out;
wire [REG_SIZE-1:0] pc_data_out;
wire [REG_SIZE-1:0] ir_data_out;
wire [REG_SIZE-1:0] y_data_out;
wire [REG_SIZE-1:0] z_data_out;
wire [REG_SIZE-1:0] mar_data_out;
wire [REG_SIZE-1:0] hi_data_out;
wire [REG_SIZE-1:0] lo_data_out;

// temporary assignment statements
genvar i;
generate
	for (i = 15; i >= 0; i = i - 1)
	begin: gp_le_init_loop
		assign gp_le[i] = 0;
	end
endgenerate
assign pc_le = 0;
assign ir_le = 0;
assign y_le = 0;
assign z_le = 0;
assign mar_le = 0;
assign hi_le = 0;
assign lo_le = 0;
assign mdr_in = 0;
assign md_mux_select = 0;
generate
	for (i = REG_SIZE - 1; i >= 0; i = i - 1)
	begin: m_data_in_init_loop
		assign m_data_in[i] = 0;
	end
endgenerate

gp_register r0[REG_SIZE-1:0](clk, reset_n, gp_le[0], bus_data, r0_data_out);
gp_register r1[REG_SIZE-1:0](clk, reset_n, gp_le[1], bus_data, r1_data_out);
gp_register r2[REG_SIZE-1:0](clk, reset_n, gp_le[2], bus_data, r2_data_out);
gp_register r3[REG_SIZE-1:0](clk, reset_n, gp_le[3], bus_data, r3_data_out);
gp_register r4[REG_SIZE-1:0](clk, reset_n, gp_le[4], bus_data, r4_data_out);
gp_register r5[REG_SIZE-1:0](clk, reset_n, gp_le[5], bus_data, r5_data_out);
gp_register r6[REG_SIZE-1:0](clk, reset_n, gp_le[6], bus_data, r6_data_out);
gp_register r7[REG_SIZE-1:0](clk, reset_n, gp_le[7], bus_data, r7_data_out);
gp_register r8[REG_SIZE-1:0](clk, reset_n, gp_le[8], bus_data, r8_data_out);
gp_register r9[REG_SIZE-1:0](clk, reset_n, gp_le[9], bus_data, r9_data_out);
gp_register r10[REG_SIZE-1:0](clk, reset_n, gp_le[10], bus_data, r10_data_out);
gp_register r11[REG_SIZE-1:0](clk, reset_n, gp_le[11], bus_data, r11_data_out);
gp_register r12[REG_SIZE-1:0](clk, reset_n, gp_le[12], bus_data, r12_data_out);
gp_register r13[REG_SIZE-1:0](clk, reset_n, gp_le[13], bus_data, r13_data_out);
gp_register r14[REG_SIZE-1:0](clk, reset_n, gp_le[14], bus_data, r14_data_out);
gp_register r15[REG_SIZE-1:0](clk, reset_n, gp_le[15], bus_data, r15_data_out);

gp_register pc[REG_SIZE-1:0](clk, reset_n, pc_le, bus_data, pc_data_out);
gp_register ir[REG_SIZE-1:0](clk, reset_n, ir_le, bus_data, ir_data_out);
gp_register y[REG_SIZE-1:0](clk, reset_n, y_le, bus_data, y_data_out);
gp_register z[REG_SIZE-1:0](clk, reset_n, z_le, bus_data, z_data_out);
gp_register mar[REG_SIZE-1:0](clk, reset_n, mar_le, bus_data, mar_data_out);
gp_register hi[REG_SIZE-1:0](clk, reset_n, hi_le, bus_data, hi_data_out);
gp_register lo[REG_SIZE-1:0](clk, reset_n, lo_le, bus_data, lo_data_out);

mdr mdr_reg[REG_SIZE-1:0](clk, reset_n, mdr_in, md_mux_select, bus_data, m_data_in, mdr_output);

endmodule
