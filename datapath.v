module datapath(gpr_in, gpr_out, hi_in, hi_out, lo_in, lo_out, pc_in, pc_out, ir_in, z_in,
	z_high_out, z_low_out, y_in, mar_in, mdr_in, mdr_out, read, m_data_in,
	bus_data);

parameter REG_SIZE = 32;

wire clk;
wire reset_n;

input [15:0] gpr_in; // the load enable for the gen. purpose registers
input [15:0] gpr_out; // control signals to the output multiplexer to select data out

input hi_in;
input hi_out;
input lo_in;
input lo_out;
input pc_in;
input pc_out;
input ir_in;
input z_in;
wire z_high_in;
wire z_low_in;
input z_high_out;
input z_low_out;
input y_in;
input mar_in;
input mdr_in;
input mdr_out;
input read;
input [REG_SIZE-1:0] m_data_in;

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
wire [REG_SIZE-1:0] z_low_data_out;
wire [REG_SIZE-1:0] z_high_data_out;
wire [REG_SIZE-1:0] mar_data_out;
wire [REG_SIZE-1:0] hi_data_out;
wire [REG_SIZE-1:0] lo_data_out;

output [REG_SIZE-1:0] bus_data;

wire md_mux_select;

wire [REG_SIZE-1:0] mdr_output;

// temporary assignment statements
/*genvar i;
generate
	for (i = 15; i >= 0; i = i - 1)
	begin: gpr_in_init_loop
		assign gpr_in[i] = 0;
	end
endgenerate
assign pc_le = 0;
assign ir_le = 0;
assign y_le = 0;
assign z_le = 0;
assign mar_le = 0;
assign hi_le = 0;
assign lo_le = 0;
assign mdr_in = 0;*/
assign z_high_in = 0;
assign z_low_in = 0;
assign md_mux_select = 0;
assign clk = 0;
assign reset_n = 1;
/*generate
	for (i = REG_SIZE - 1; i >= 0; i = i - 1)
	begin: m_data_in_init_loop
		assign m_data_in[i] = 0;
	end
endgenerate*/

gp_register r0(clk, reset_n, gpr_in[0], bus_data, r0_data_out);
gp_register r1(clk, reset_n, gpr_in[1], bus_data, r1_data_out);
gp_register r2(clk, reset_n, gpr_in[2], bus_data, r2_data_out);
gp_register r3(clk, reset_n, gpr_in[3], bus_data, r3_data_out);
gp_register r4(clk, reset_n, gpr_in[4], bus_data, r4_data_out);
gp_register r5(clk, reset_n, gpr_in[5], bus_data, r5_data_out);
gp_register r6(clk, reset_n, gpr_in[6], bus_data, r6_data_out);
gp_register r7(clk, reset_n, gpr_in[7], bus_data, r7_data_out);
gp_register r8(clk, reset_n, gpr_in[8], bus_data, r8_data_out);
gp_register r9(clk, reset_n, gpr_in[9], bus_data, r9_data_out);
gp_register r10(clk, reset_n, gpr_in[10], bus_data, r10_data_out);
gp_register r11(clk, reset_n, gpr_in[11], bus_data, r11_data_out);
gp_register r12(clk, reset_n, gpr_in[12], bus_data, r12_data_out);
gp_register r13(clk, reset_n, gpr_in[13], bus_data, r13_data_out);
gp_register r14(clk, reset_n, gpr_in[14], bus_data, r14_data_out);
gp_register r15(clk, reset_n, gpr_in[15], bus_data, r15_data_out);

gp_register pc(clk, reset_n, pc_in, bus_data, pc_data_out);
gp_register ir(clk, reset_n, ir_in, bus_data, ir_data_out);
gp_register y(clk, reset_n, y_in, bus_data, y_data_out);
gp_register z(clk, reset_n, z_in, bus_data, z_data_out);
gp_register z_high(clk, reset_n, z_high_in, bus_data, z_high_data_out);
gp_register z_low(clk, reset_n, z_low_in, bus_data, z_low_data_out);
gp_register mar(clk, reset_n, mar_in, bus_data, mar_data_out);
gp_register hi(clk, reset_n, hi_in, bus_data, hi_data_out);
gp_register lo(clk, reset_n, lo_in, bus_data, lo_data_out);

mdr mdr_reg(clk, reset_n, mdr_in, md_mux_select, bus_data, m_data_in, mdr_output);

/* bus_data multiplexer and control */
wire [4:0] bus_mux_ctrl;
enc_32to5 bus_out_enc(gpr_out[0], gpr_out[1], gpr_out[2], gpr_out[3], gpr_out[4], gpr_out[5], gpr_out[6], gpr_out[7],
	gpr_out[8], gpr_out[9], gpr_out[10], gpr_out[11], gpr_out[12], gpr_out[13], gpr_out[14], gpr_out[15],
	hi_out, lo_out, z_high_out, z_low_out, pc_out, mdr_out,
	1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx,
	bus_mux_ctrl);
mux_32bit_32to1 bus_mux(
	.r0(r0_data_out),
	.r1(r1_data_out),
	.r2(r2_data_out),
	.r3(r3_data_out),
	.r4(r4_data_out),
	.r5(r5_data_out),
	.r6(r6_data_out),
	.r7(r7_data_out),
	.r8(r8_data_out),
	.r9(r9_data_out),
	.r10(r10_data_out),
	.r11(r11_data_out),
	.r12(r12_data_out),
	.r13(r13_data_out),
	.r14(r14_data_out),
	.r15(r15_data_out),
	.r16(hi_data_out),
	.r17(lo_data_out),
	.r18(z_high_data_out),
	.r19(z_low_data_out),
	.r20(pc_data_out),
	.r21(mdr_output),
	.sel(bus_mux_ctrl),
	.out(bus_data));
	
/* ALU Logic */
alu the_alu(4'b0000, y_data_out, bus_data, z_data_out);

endmodule
