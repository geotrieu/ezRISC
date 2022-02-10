// and datapath_tb.v file: <This is the filename> 
`timescale 1ns/10ps
module and_datapath_tb;

reg pc_out, z_low_out, mdr_out, r2_out, r4_out;           // add any other signals to see in your simulation 
reg mar_in, z_in, pc_in, mdr_in, ir_in, y_in;
reg inc_pc, read, r5_in, r2_in, r4_in;
reg clk, reset_n;
reg [31:0] m_data_in;
reg [3:0] alu_op;

parameter And = 4'b0000, Or = 4'b0001, Add = 4'b0010, Sub = 4'b0011, Shr = 4'b0100, Shl = 4'b0101,
	Ror = 4'b0110, Rol = 4'b0111, Mul = 4'b1000, Div = 4'b1001, Neg = 4'b1010, Not = 4'b1011;

parameter Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
	Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
	T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100;
reg [3:0] Present_state = Default;

wire [15:0] gpr_in;
wire [15:0] gpr_out;
assign gpr_in = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0,
	1'b0, 1'b0, r5_in, r4_in, 1'b0, r2_in, 1'b0, 1'b0};
assign gpr_out = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0,
	1'b0, 1'b0, 1'b0, r4_out, 1'b0, r2_out, 1'b0, 1'b0};

wire [31:0] bus_data;

datapath the_datapath(
	.clk(clk),
	.reset_n(reset_n),
	.gpr_in(gpr_in),
	.gpr_out(gpr_out),
	.hi_in(1'b0),
	.hi_out(1'b0),
	.lo_in(1'b0),
	.lo_out(1'b0),
	.pc_in(pc_in),
	.pc_out(pc_out),
	.ir_in(ir_in),
	.z_in(z_in),
	.z_high_out(1'b0),
	.z_low_out(z_low_out),
	.inport_out(1'b0),
	.c_out(1'b0),
	.y_in(y_in),
	.mar_in(mar_in),
	.mdr_in(mdr_in),
	.mdr_out(mdr_out),
	.read(read),
	.m_data_in(m_data_in),
	.alu_op(alu_op),
	.inc_pc(inc_pc),
	.bus_data(bus_data));
 
initial
begin
	clk = 0;
	forever #10 clk = ~clk;
end

always @(posedge clk)  // finite state machine; if clock rising-edge
begin
	case (Present_state)
		Default: 	#40 Present_state = Reg_load1a;
		Reg_load1a: #40 Present_state = Reg_load1b;
		Reg_load1b: #40 Present_state = Reg_load2a;
		Reg_load2a: #40 Present_state = Reg_load2b;
		Reg_load2b: #40 Present_state = Reg_load3a;
		Reg_load3a: #40 Present_state = Reg_load3b;
		Reg_load3b: #40 Present_state = T0;
		T0: 			#40 Present_state = T1;
		T1: 			#40 Present_state = T2;
		T2: 			#40 Present_state = T3;
		T3: 			#40 Present_state = T4;
		T4: 			#40 Present_state = T5;
   endcase
end
                                               
always @(Present_state)  // do the required job in each state
begin
	case (Present_state)               // assert the required signals in each clock cycle
		Default: begin
			pc_out <= 0;
			z_low_out <= 0;
			mdr_out <= 0;
         r2_out <= 0;
			r4_out <= 0;
			mar_in <= 0;
			z_in <= 0;   
         pc_in <=0;
			mdr_in <= 0;
			ir_in  <= 0;
			y_in <= 0;   
         inc_pc <= 0;
			read <= 0;
         r5_in <= 0;
			r2_in <= 0;
			r4_in <= 0;
			m_data_in <= 32'h00000000;
			reset_n <= 0;
			#10 reset_n <= 1;
		end
		Reg_load1a: begin
			m_data_in <= 32'h00000022;
			read = 0;
			mdr_in = 0;                   // the first zero is there for completeness
			#10 read <= 1; mdr_in <= 1;
			#15 read <= 0; mdr_in <= 0;
		end
      Reg_load1b: begin
			#10 mdr_out <= 1; r2_in <= 1;
         #15 mdr_out <= 0; r2_in <= 0;     // initialize R2 with the value $22
		end
		Reg_load2a: begin
			m_data_in <= 32'h00000024;
			#10 read <= 1; mdr_in <= 1;
			#15 read <= 0; mdr_in <= 0;
		end
      Reg_load2b: begin
			#10 mdr_out <= 1; r4_in <= 1;
         #15 mdr_out <= 0; r4_in <= 0;  // initialize R4 with the value $24
		end
		Reg_load3a: begin   
			m_data_in <= 32'h00000026;
			#10 read <= 1; mdr_in <= 1;
			#15 read <= 0; mdr_in <= 0;
		end
      Reg_load3b: begin
			#10 mdr_out <= 1; r5_in <= 1;
         #15 mdr_out <= 0; r5_in <= 0;  // initialize R5 with the value $26
		end
		T0: begin
			#10 pc_out <= 1; mar_in <= 1; inc_pc <= 1; z_in <= 1; alu_op <= Add;
			#15 pc_out <= 0; mar_in <= 0; inc_pc <= 0; z_in <= 0;
		end
		T1: begin 
			#10 z_low_out <= 1; pc_in <= 1; read <= 1; mdr_in <= 1; m_data_in <= 32'h4A920000; // opcode for “and R5, R2, R4”
			#15 z_low_out <= 0; pc_in <= 0; read <= 0; mdr_in <= 0;
		end
		T2: begin
			#10 mdr_out <= 1; ir_in <= 1;
			#15 mdr_out <= 0; ir_in <= 0;
		end
		T3: begin
			#10 r2_out <= 1; y_in <= 1;
			#15 r2_out <= 0; y_in <= 0;
		end
		T4: begin
			#10 r4_out <= 1; alu_op <= And; z_in <= 1;
			#15 r4_out <= 0; z_in <= 0;
		end
		T5: begin
			#10 z_low_out <= 1; r5_in <= 1;
			#15 z_low_out <= 0; r5_in <= 0;
		end
	endcase
end

endmodule
