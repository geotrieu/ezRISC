// mflo datapath_tb.v file:
`timescale 1ns/10ps
module mflo_datapath_tb;

reg pc_out, z_low_out, mdr_out; 
reg mar_in, z_in, pc_in, mdr_in, ir_in, y_in, c_out, hi_out, lo_out;
reg inc_pc, read, write;
reg gra, grb, grc, r_in, r_out, ba_out, outport_in;
reg clk, reset_n;
reg [3:0] alu_op;

parameter And = 4'b0000, Or = 4'b0001, Add = 4'b0010, Sub = 4'b0011, Shr = 4'b0100, Shl = 4'b0101,
	Ror = 4'b0110, Rol = 4'b0111, Mul = 4'b1000, Div = 4'b1001, Neg = 4'b1010, Not = 4'b1011;

parameter 	Default = 4'b0000, T0 = 4'b0001, T1 = 4'b0010, T2 = 4'b0011, T3 = 4'b0100, T4 = 4'b0101, T5 = 4'b0110, 
				T6 = 4'b0111, T7 = 4'b1000;
reg [3:0] Present_state = Default;

wire [31:0] bus_data;
wire [31:0] outport_ext_output;

datapath the_datapath(
	.clk(clk),
	.reset_n(reset_n),
	.gra(gra),
	.grb(grb),
	.grc(grc),
	.r_in(r_in),
	.r_out(r_out),
	.ba_out(ba_out),
	.hi_in(1'b0),
	.hi_out(hi_out),
	.lo_in(1'b0),
	.lo_out(lo_out),
	.pc_in(pc_in),
	.pc_out(pc_out),
	.ir_in(ir_in),
	.z_in(z_in),
	.z_high_out(1'b0),
	.z_low_out(z_low_out),
	.inport_out(1'b0),
	.inport_ext_input(32'b0),
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
	.bus_data(bus_data),
	.outport_ext_output(outport_ext_output));
 
initial
begin
	clk = 0;
	forever #5 clk = ~clk;
end
initial
begin
	#11 the_datapath.lo.q = 32'h1F; // initialize register hi
end
always @(posedge clk)  // finite state machine; if clock rising-edge
begin
	case (Present_state)
		Default: 	#40 Present_state = T0;
		T0: 			#40 Present_state = T1;
		T1: 			#40 Present_state = T2;
		T2: 			#40 Present_state = T3;
		T3: 			#40 Present_state = T0;

   endcase
end
// PC OP Code mfhi R2 (C1xxxxxx)                                           
always @(Present_state)  // do the required job in each state
begin
	case (Present_state)               // assert the required signals in each clock cycle
		Default: begin
			pc_out 		<= 	0;
			z_low_out 	<= 	0;
			mdr_out 		<= 	0;
			hi_out		<=		0;
			lo_out		<=		0;
			mar_in 		<= 	0;
			z_in 			<= 	0;   
			pc_in 		<=		0;
			mdr_in 		<=		0;
			ir_in  		<= 	0;
			y_in 			<= 	0;   
			inc_pc 		<=		0;
			read 			<= 	0;
			alu_op 		<= 	4'b0000;
			gra 			<= 	0;
			grb 			<= 	0;
			grc 			<= 	0;
			r_in 			<= 	0;
			r_out 		<= 	0;
			ba_out 		<= 	0;
			outport_in	<= 	0;
			write			<= 	0;
			c_out			<= 	0;
			reset_n <= 0;
			#10 reset_n <= 1;
		end
		T0: begin
			#10 pc_out <= 1; mar_in <= 1; inc_pc <= 1; z_in <= 1; alu_op <= Add;
			#15 pc_out <= 0; mar_in <= 0; inc_pc <= 0; z_in <= 0;
		end
		T1: begin 
			#10 z_low_out <= 1; pc_in <= 1; read <= 1; mdr_in <= 1;
			#15 z_low_out <= 0; pc_in <= 0; read <= 0; mdr_in <= 0;
		end
		T2: begin
			#10 mdr_out <= 1; ir_in <= 1;
			#15 mdr_out <= 0; ir_in <= 0;
		end
		T3: begin
			#10 lo_out <= 1; gra <= 1; r_in <= 1;
			#15 lo_out <= 0; gra <= 0; r_in <= 0;
		end
	endcase
end

endmodule
