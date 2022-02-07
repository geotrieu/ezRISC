module datapath(clk, reset_n, gpr_in, gpr_out, hi_in, hi_out, lo_in, lo_out, pc_in, pc_out, ir_in, z_in,
	z_high_out, z_low_out, y_in, mar_in, mdr_in, mdr_out, read, m_data_in, alu_op,
	bus_data);

parameter REG_SIZE = 32;

/* INPUTS */
// Synchronization Inputs
input clk;
input reset_n;
// Load Enable Inputs
input [15:0] gpr_in; // the load enable for the gen. purpose registers
input hi_in;
input lo_in;
input pc_in;
input ir_in;
input z_in;
input y_in;
input mar_in;
// MUX Control Signal Inputs
input [15:0] gpr_out; // control signals to the output multiplexer to select data out
input hi_out;
input lo_out;
input pc_out;
input z_high_out;
input z_low_out;
// MDR Inputs
input mdr_in; // Load Enable for special MDR register
input mdr_out; // Control Signal for BUS MUX to allow MDR --> bus_data
input read; // Control Signal to choose between bus_data (0) and m_data_in (1) to be inputted into the MDR
input [REG_SIZE-1:0] m_data_in; // Memory from RAM
// ALU Inputs
input [3:0] alu_op; // Refer to alu.v for operation codes

/* OUTPUTS */
output [REG_SIZE-1:0] bus_data;

/* SPECIAL Z REGISTER (64-bit) */
wire [REG_SIZE + REG_SIZE - 1:0] z_data_in; // D input for Z Register
wire [REG_SIZE + REG_SIZE - 1:0] z_data; // Q output for Z Register
wire [REG_SIZE-1:0] z_low_data; // Lower 32 bits of Z Register
assign z_low_data = z_data[REG_SIZE - 1:0];
wire [REG_SIZE-1:0] z_hi_data; // Higher 32 bits of Z Register
assign z_hi_data = z_data[REG_SIZE + REG_SIZE - 1:REG_SIZE];
gp_register #(.GP_REG_SIZE(REG_SIZE + REG_SIZE)) z(clk, reset_n, z_in, z_data_in, z_data); // Instantiation with 64-bit

/* MDR REGISTER */
wire [REG_SIZE-1:0] mdr_data; // Q output of MDR register
mdr mdr_reg(
	.clk(clk),
	.reset_n(reset_n),
	.mdr_in(mdr_in),
	.md_mux_select(read),
	.bus_mux_out(bus_data),
	.m_data_in(m_data_in),
	.mdr_output(mdr_data));

/* GP REGISTERS */
// Q outputs of GP Registers
wire [REG_SIZE-1:0] r0_data;
wire [REG_SIZE-1:0] r1_data;
wire [REG_SIZE-1:0] r2_data;
wire [REG_SIZE-1:0] r3_data;
wire [REG_SIZE-1:0] r4_data;
wire [REG_SIZE-1:0] r5_data;
wire [REG_SIZE-1:0] r6_data;
wire [REG_SIZE-1:0] r7_data;
wire [REG_SIZE-1:0] r8_data;
wire [REG_SIZE-1:0] r9_data;
wire [REG_SIZE-1:0] r10_data;
wire [REG_SIZE-1:0] r11_data;
wire [REG_SIZE-1:0] r12_data;
wire [REG_SIZE-1:0] r13_data;
wire [REG_SIZE-1:0] r14_data;
wire [REG_SIZE-1:0] r15_data;
wire [REG_SIZE-1:0] pc_data;
wire [REG_SIZE-1:0] ir_data;
wire [REG_SIZE-1:0] y_data;
wire [REG_SIZE-1:0] mar_data;
wire [REG_SIZE-1:0] hi_data;
wire [REG_SIZE-1:0] lo_data;
// Register Logic Instantiation
gp_register r0(clk, reset_n, gpr_in[0], bus_data, r0_data);
gp_register r1(clk, reset_n, gpr_in[1], bus_data, r1_data);
gp_register r2(clk, reset_n, gpr_in[2], bus_data, r2_data);
gp_register r3(clk, reset_n, gpr_in[3], bus_data, r3_data);
gp_register r4(clk, reset_n, gpr_in[4], bus_data, r4_data);
gp_register r5(clk, reset_n, gpr_in[5], bus_data, r5_data);
gp_register r6(clk, reset_n, gpr_in[6], bus_data, r6_data);
gp_register r7(clk, reset_n, gpr_in[7], bus_data, r7_data);
gp_register r8(clk, reset_n, gpr_in[8], bus_data, r8_data);
gp_register r9(clk, reset_n, gpr_in[9], bus_data, r9_data);
gp_register r10(clk, reset_n, gpr_in[10], bus_data, r10_data);
gp_register r11(clk, reset_n, gpr_in[11], bus_data, r11_data);
gp_register r12(clk, reset_n, gpr_in[12], bus_data, r12_data);
gp_register r13(clk, reset_n, gpr_in[13], bus_data, r13_data);
gp_register r14(clk, reset_n, gpr_in[14], bus_data, r14_data);
gp_register r15(clk, reset_n, gpr_in[15], bus_data, r15_data);
gp_register pc(clk, reset_n, pc_in, bus_data, pc_data);
gp_register ir(clk, reset_n, ir_in, bus_data, ir_data);
gp_register y(clk, reset_n, y_in, bus_data, y_data);
gp_register mar(clk, reset_n, mar_in, bus_data, mar_data);
gp_register hi(clk, reset_n, hi_in, bus_data, hi_data);
gp_register lo(clk, reset_n, lo_in, bus_data, lo_data);

/* bus_data MUX & CTRL */
wire [4:0] bus_mux_ctrl;
enc_32to5 bus_out_enc(
	.r0(gpr_out[0]),
	.r1(gpr_out[1]),
	.r2(gpr_out[2]),
	.r3(gpr_out[3]),
	.r4(gpr_out[4]),
	.r5(gpr_out[5]),
	.r6(gpr_out[6]),
	.r7(gpr_out[7]),
	.r8(gpr_out[8]),
	.r9(gpr_out[9]),
	.r10(gpr_out[10]),
	.r11(gpr_out[11]),
	.r12(gpr_out[12]),
	.r13(gpr_out[13]),
	.r14(gpr_out[14]),
	.r15(gpr_out[15]),
	.r16(hi_out),
	.r17(lo_out),
	.r18(z_high_out),
	.r19(z_low_out),
	.r20(pc_out),
	.r21(mdr_out),
	.out(bus_mux_ctrl));
mux_32bit_32to1 bus_mux(
	.r0(r0_data),
	.r1(r1_data),
	.r2(r2_data),
	.r3(r3_data),
	.r4(r4_data),
	.r5(r5_data),
	.r6(r6_data),
	.r7(r7_data),
	.r8(r8_data),
	.r9(r9_data),
	.r10(r10_data),
	.r11(r11_data),
	.r12(r12_data),
	.r13(r13_data),
	.r14(r14_data),
	.r15(r15_data),
	.r16(hi_data),
	.r17(lo_data),
	.r18(z_hi_data),
	.r19(z_low_data),
	.r20(pc_data),
	.r21(mdr_data),
	.sel(bus_mux_ctrl),
	.out(bus_data));
	
/* ALU LOGIC */
alu the_alu(
	.ctrl_sig(alu_op),
	.y_data_in(y_data),
	.bus_data_in(bus_data),
	.z_data_out(z_data_in));

endmodule
