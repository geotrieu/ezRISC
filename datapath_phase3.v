module datapath_phase3(fast_clk, reset_n, bus_data);

parameter REG_SIZE = 32;

/* INPUTS */
// Synchronization Inputs
input fast_clk;
input reset_n;

reg clk2 = 0;
reg clk = 0;
always @(posedge fast_clk)
begin
clk2 <= ~clk2;
end

always @(posedge clk2)
begin
clk <= ~clk;
end
/* wires */
// Load Enable wires
wire hi_in;
wire lo_in;
wire pc_in;
wire ir_in;
wire z_in;
wire y_in;
wire mar_in;
wire outport_in;
// MUX Control Signal wires
wire hi_out;
wire lo_out;
wire pc_out;
wire z_high_out;
wire z_low_out;
// GPR Control Signal wires
wire gra;
wire grb;
wire grc;
wire r_in;
wire r_out;
wire ba_out;
// I/O wires
wire inport_out;
wire [REG_SIZE - 1:0] inport_ext_input;
// Constant wires
wire c_out;
// MDR wires
wire mdr_in; // Load Enable for special MDR register
wire mdr_out; // Control Signal for BUS MUX to allow MDR --> bus_data
wire read; // Control Signal to choose between bus_data (0) and m_data_in (1) to be inputted into the MDR
wire write; // Control Signal to instruct RAM to write data to address in MAR HIenable
// ALU wires
wire [3:0] alu_op; // Refer to alu.v for operation codes
wire inc_pc;
// CON FF wires
wire con_in;

// more wires
wire clear;
reg stop = 0;
wire run;

// bus data wires
output [REG_SIZE-1:0] bus_data;
wire [REG_SIZE-1:0] outport_ext_output;
wire con_out;

/* I/O Devices */
wire [REG_SIZE-1:0] inport_data;
gp_register inport(clk, reset_n, 1'b1, inport_ext_input, inport_data);
gp_register outport(clk, reset_n, outport_in, bus_data, outport_ext_output);

/* CONSTANTS */
wire [REG_SIZE-1:0] c_sign_extended;

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
wire [REG_SIZE-1:0] m_data_in; // Memory from RAM
mdr mdr_reg(
	.clk(clk),
	.reset_n(reset_n),
	.mdr_in(mdr_in),
	.md_mux_select(read),
	.bus_mux_out(bus_data),
	.m_data_in(m_data_in),
	.mdr_output(mdr_data));

/* GP REGISTERS */
// Control Signals
wire [15:0] gpr_in;
wire [15:0] gpr_out;
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
// SPECIAL R0 Register Logic
wire [REG_SIZE-1:0] r0_bus_data; // the actual data going into the BUS MUX for R0
assign r0_bus_data = r0_data & {REG_SIZE{~ba_out}};
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

/* Control Unit */
control_unit the_control_unit(
	.gra(gra),
	.grb(grb),
	.grc(grc),
	.r_in(r_in),
	.r_out(r_out),
	.ba_out(ba_out),
	.hi_in(hi_in),
	.hi_out(hi_out),
	.lo_in(lo_in),
	.lo_out(lo_out),
	.pc_in(pc_in),
	.pc_out(pc_out),
	.ir_in(ir_in),
	.z_in(z_in),
	.z_high_out(z_high_out),
	.z_low_out(z_low_out),
	.inport_out(inport_out),
	.c_out(c_out),
	.y_in(y_in),
	.mar_in(mar_in),
	.outport_in(outport_in),
	.mdr_in(mdr_in),
	.mdr_out(mdr_out),
	.read(read),
	.write(write),
	.alu_op(alu_op),
	.inc_pc(inc_pc),
	.outport_ext_output(outport_ext_output),
	.ir_data(ir_data),
	.clk(clk),
	.reset_n(reset_n),
	.con_ff(con_ff),
	.con_in(con_in),
	.con_out(con_out),
	.clear(clear),
	.run(run),
	.stop(stop));


/* CON FF */
con_ff the_con_ff(
	.clk(clk),
	.reset_n(reset_n),
	.con_in(con_in),
	.ir(ir_data),
	.bus_data(bus_data),
	.con_out(con_out));

/* Select and Encode Logic */
select_encode gpr_select_encode(
	.ir(ir_data),
	.gra(gra),
	.grb(grb),
	.grc(grc),
	.r_in(r_in),
	.r_out(r_out),
	.ba_out(ba_out),
	.gpr_in(gpr_in),
	.gpr_out(gpr_out),
	.c_se(c_sign_extended));

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
	.r22(inport_out),
	.r23(c_out),
	.out(bus_mux_ctrl));
mux_32bit_32to1 bus_mux(
	.r0(r0_bus_data),
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
	.r22(inport_data),
	.r23(c_sign_extended),
	.sel(bus_mux_ctrl),
	.out(bus_data));
	
/* ALU LOGIC */
wire [REG_SIZE - 1:0] alu_a_in_data;
// This MUX is used to select between the Y data, and the constant 1.
// This is used for incrementing the PC by 1 word.
mux_32bit_2to1 alu_a_mux(
	.a(y_data),
	.b(32'h00000001),
	.sel(inc_pc),
	.out(alu_a_in_data));
alu the_alu(
	.ctrl_sig(alu_op),
	.a_data_in(alu_a_in_data),
	.b_data_in(bus_data),
	.c_data_out(z_data_in));

/* Memory Logic */

RAM the_ram(
	.address(mar_data),
	.clock(fast_clk),
	.data(mdr_data),
	.wren(write),
	.q(m_data_in));

endmodule
