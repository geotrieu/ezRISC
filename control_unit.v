`timescale 1ns/10ps
module control_unit (

output reg gra, grb, grc, r_in, r_out, ba_out, hi_in, 
hi_out, lo_in, lo_out, pc_in, pc_out, ir_in, z_in, 
z_high_out, z_low_out, inport_out, c_out, y_in,
mar_in, outport_in, mdr_in, mdr_out, read, write,
inc_pc, con_in, clear, run,
output reg [3:0] alu_op,
input [31:0] ir_data,
input stop,
input clk, reset_n, con_ff, con_out);

parameter And = 4'b0000, Or = 4'b0001, Add = 4'b0010, Sub = 4'b0011, Shr = 4'b0100, Shl = 4'b0101,
	Ror = 4'b0110, Rol = 4'b0111, Mul = 4'b1000, Div = 4'b1001, Neg = 4'b1010, Not = 4'b1011;
	
parameter reset_n_state = 7'b0000000, fetch0 = 7'b0000001, fetch1 = 7'b0000010, fetch2 = 7'b0000011,
ld3  = 7'b0000100, ld4  = 7'b0000101, ld5  = 7'b0000110, ld6  = 7'b0000111, 
ld7  = 7'b0001000, ldi3 = 7'b0001001, ldi4 = 7'b0001010, ldi5 = 7'b0001011,
st3  = 7'b0001100, st4  = 7'b0001101, st5  = 7'b0001110, st6  = 7'b0001111, 
st7  = 7'b0010000, add3 = 7'b0010001, add4 = 7'b0010010, add5 = 7'b0010011,
sub3 = 7'b0010100, sub4 = 7'b0010101, sub5 = 7'b0010110, shr3 = 7'b0010111,
shr4 = 7'b0011000, shr5 = 7'b0011001, shl3 = 7'b0011010, shl4 = 7'b0011011,
shl5 = 7'b0011100, ror3 = 7'b0011101, ror4 = 7'b0011110, ror5 = 7'b0011111,
rol3 = 7'b0100000, rol4 = 7'b0100001, rol5 = 7'b0100010, and3  = 7'b0100011,
and4  = 7'b0100100, and5  = 7'b0100101, or3 = 7'b0100110, or4 = 7'b0100111,
or5 = 7'b0101000, andi3 = 7'b0101001, andi4 = 7'b0101010, andi5 = 7'b0101011,
addi3 = 7'b0101100, addi4 = 7'b0101101, addi5 = 7'b0101110, ori3 = 7'b0101111,
ori4 = 7'b0110000, ori5 = 7'b0110001, mul3 = 7'b0110010, mul4 = 7'b0110011,
mul5 = 7'b0110100, mul6 = 7'b0110101, div3 = 7'b0110110, div4 = 7'b0110111,
div5 = 7'b0111000, div6 = 7'b0111001, neg3 = 7'b0111010, neg4  = 7'b0111011,
not3  = 7'b0111100, not4  = 7'b0111101, br3  = 7'b0111110, br4  = 7'b0111111,
br5 = 7'b1000000, br6 = 7'b1000001, jr3  = 7'b1000010, jal3 = 7'b1000011,
jal4 = 7'b1000100, in3 = 7'b1000101, out3 = 7'b1000110, mfhi3 = 7'b1000111,
mflo3 = 7'b1001000, halt3 = 7'b1001001;

reg [6:0] Present_state = reset_n_state;

wire [4:0] op_code;
assign op_code = ir_data[31:27];

reg [31:0] num_instructions = 32'd0;

always @(negedge clk, negedge reset_n, posedge stop) // finite state machine; if clk falling-edge or reset_n fall-edge
begin
	if (reset_n == 1'b0) Present_state = reset_n_state;
	else if (stop) Present_state = halt3;
	else
	begin
		case (Present_state)
			reset_n_state : Present_state = fetch0;
			fetch0 : Present_state = fetch1;
			fetch1 : Present_state = fetch2;
			fetch2 : begin
				case (op_code) // inst. decoding based on the opcode to set the next state
					5'b00000 : Present_state <= ld3;
					5'b00001 : Present_state <= ldi3;
					5'b00010 : Present_state <= st3;
					5'b00011 : Present_state <= add3;
					5'b00100 : Present_state <= sub3;
					5'b00101 : Present_state <= shr3;
					5'b00110 : Present_state <= shl3;
					5'b00111 : Present_state <= ror3;
					5'b01000 : Present_state <= rol3;
					5'b01001 : Present_state <= and3;
					5'b01010 : Present_state <= or3;
					5'b01011 : Present_state <= addi3;
					5'b01100 : Present_state <= andi3;
					5'b01101 : Present_state <= ori3;
					5'b01110 : Present_state <= mul3;
					5'b01111 : Present_state <= div3;
					5'b10000 : Present_state <= neg3;
					5'b10001 : Present_state <= not3;
					5'b10010 : Present_state <= br3;
					5'b10011 : Present_state <= jr3;
					5'b10100 : Present_state <= jal3;
					5'b10101 : Present_state <= in3;
					5'b10110 : Present_state <= out3;
					5'b10111 : Present_state <= mfhi3;
					5'b11000 : Present_state <= mflo3;
					5'b11001 : Present_state <= reset_n_state; // nop doesnt do anything
					5'b11010 : Present_state <= halt3;
					default: Present_state <= reset_n_state;
				endcase
			end
			ld3 : Present_state <= ld4;
			ld4 : Present_state <= ld5;
			ld5 : Present_state <= ld6;
			ld6 : Present_state <= ld7;
			ld7 : Present_state <= reset_n_state;

			ldi3 : Present_state <= ldi4;
			ldi4 : Present_state <= ldi5;
			ldi5 : Present_state <= reset_n_state;
			
			st3 : Present_state <= st4;
			st4 : Present_state <= st5;
			st5 : Present_state <= st6;
			st6 : Present_state <= st7;
			st7 : Present_state <= reset_n_state;
			
			add3 : Present_state <= add4;
			add4 : Present_state <= add5;
			add5 : Present_state <= reset_n_state;
			
			sub3 : Present_state <= sub4;
			sub4 : Present_state <= sub5;
			sub5 : Present_state <= reset_n_state;
			
			shr3 : Present_state <= shr4;
			shr4 : Present_state <= shr5;
			shr5 : Present_state <= reset_n_state;
			
			shl3 : Present_state <= shl4;
			shl4 : Present_state <= shl5;
			shl5 : Present_state <= reset_n_state;
			
			ror3 : Present_state <= ror4;
			ror4 : Present_state <= ror5;
			ror5 : Present_state <= reset_n_state;
			
			rol3 : Present_state <= rol4;
			rol4 : Present_state <= rol5;
			rol5 : Present_state <= reset_n_state;
			
			and3 : Present_state <= and4;
			and4 : Present_state <= and5;
			and5 : Present_state <= reset_n_state;
			
			or3 : Present_state <= or4;
			or4 : Present_state <= or5;
			or5 : Present_state <= reset_n_state;
			
			addi3 : Present_state <= addi4;
			addi4 : Present_state <= addi5;
			addi5 : Present_state <= reset_n_state;
			
			andi3 : Present_state <= andi4;
			andi4 : Present_state <= andi5;
			andi5 : Present_state <= reset_n_state;
			
			ori3 : Present_state <= ori4;
			ori4 : Present_state <= ori5;
			ori5 : Present_state <= reset_n_state;
			
			mul3 : Present_state <= mul4;
			mul4 : Present_state <= mul5;
			mul5 : Present_state <= mul6;
			mul6 : Present_state <= reset_n_state;
			
			div3 : Present_state <= div4;
			div4 : Present_state <= div5;
			div5 : Present_state <= div6;
			div6 : Present_state <= reset_n_state;
			
			neg3 : Present_state <= neg4;
			neg4 : Present_state <= reset_n_state;
			
			not3 : Present_state <= not4;
			not4 : Present_state <= reset_n_state;
			
			br3 : Present_state <= br4;
			br4 : Present_state <= br5;
			br5 : Present_state <= br6;
			br6 : Present_state <= reset_n_state;
			
			jr3 : Present_state <= reset_n_state;
			
			jal3 : Present_state <= jal4;
			jal4 : Present_state <= reset_n_state;
			
			in3 : Present_state <= reset_n_state;
			
			out3 : Present_state <= reset_n_state;
			
			mfhi3 : Present_state <= reset_n_state;
			
			mflo3 : Present_state <= reset_n_state;
			
			halt3 : Present_state <= halt3;
		endcase
	end
end
always @(Present_state) // do the job for each state
begin
	case (Present_state) // assert the required_data signals in each state
		reset_n_state: begin
			pc_out 		<= 	0;
			z_low_out 	<= 	0;
			z_high_out  <=		0;
			lo_in 		<=		0;
			lo_out		<= 	0;
			hi_in			<=		0;
			hi_out		<=		0;
			mdr_out 		<= 	0;
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
			run			<=		1;
			inport_out	<= 	0;
			inc_pc 		<= 	0;
			con_in		<=		0;
			
		end
		fetch0: begin
			num_instructions <= num_instructions + 1;
			pc_out <= 1; mar_in <= 1; inc_pc <= 1; z_in <= 1; alu_op <= Add;
			// pc_out <= 0; mar_in <= 0; inc_pc <= 0; z_in <= 0;
		end
		fetch1: begin
			pc_out <= 0; mar_in <= 0; inc_pc <= 0; z_in <= 0;
			z_low_out <= 1; pc_in <= 1; read <= 1; mdr_in <= 1;
			//z_low_out <= 0; pc_in <= 0; read <= 0; mdr_in <= 0;
		end
		fetch2: begin
			z_low_out <= 0; pc_in <= 0; read <= 0; mdr_in <= 0;
			mdr_out <= 1; ir_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		ld3: begin
			mdr_out <= 0; ir_in <= 0;
			grb <= 1; ba_out <= 1; y_in <= 1;
		end
		ld4: begin
			grb <= 0; ba_out <= 0; y_in <= 0;
			c_out <= 1; alu_op <= Add; z_in <= 1;
		end
		ld5: begin
			c_out <= 0; z_in <= 0;
			z_low_out <= 1; mar_in <= 1;
		end
		ld6: begin
			z_low_out <= 0; mar_in <= 0;
			read <= 1; mdr_in <= 1;
		end
		ld7: begin
			read <= 0; mdr_in <= 0;
			mdr_out <= 1; gra <= 1; r_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		ldi3: begin
			mdr_out <= 0; ir_in <= 0;
			grb <= 1; ba_out <= 1; y_in <= 1;
			
		end
		ldi4: begin
			grb <= 0; ba_out <= 0; y_in <= 0;
			c_out <= 1; alu_op <= Add; z_in <= 1;
		end
		ldi5: begin
			c_out <= 0; z_in <= 0;
			z_low_out <= 1; gra <= 1; r_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		st3: begin
			mdr_out <= 0; ir_in <= 0;
			grb <= 1; ba_out <= 1; y_in <= 1;
		end
		st4: begin
			grb <= 0; ba_out <= 0; y_in <= 0;
			c_out <= 1; alu_op <= Add; z_in <= 1;
		end
		st5: begin
			c_out <= 0; z_in <= 0;
			z_low_out <= 1; mar_in <= 1;
		end
		st6: begin
			z_low_out <= 0; mar_in <= 0;
			gra <= 1; r_out <= 1; mdr_in <= 1;
		end
		st7: begin
			gra <= 0; r_out <= 0; mdr_in <= 0;
			write <= 1;
		end
		///////////////////////////////////////////////////////////////////
		add3: begin
			mdr_out <= 0; ir_in <= 0;
			grb <= 1; r_out <= 1; y_in <= 1;
		end
		add4: begin
			grb <= 0; r_out <= 0; y_in <= 0;
			grc <= 1; r_out <= 1; alu_op <= Add; z_in <= 1;
		end
		add5: begin
			grc <= 0; r_out <= 0; z_in <= 0;
			z_low_out <= 1; gra <= 1; r_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		sub3: begin
			mdr_out <= 0; ir_in <= 0;
			grb <= 1; r_out <= 1; y_in <= 1;
		end
		sub4: begin
			grb <= 0; r_out <= 0; y_in <= 0;
			grc <= 1; r_out <= 1; alu_op <= Sub; z_in <= 1;
		end
		sub5: begin
			grc <= 0; r_out <= 0; z_in <= 0;
			z_low_out <= 1; gra <= 1; r_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		shr3: begin
			mdr_out <= 0; ir_in <= 0;
			grb <= 1; r_out <= 1; y_in <= 1;
		end
		shr4: begin
			grb <= 0; r_out <= 0; y_in <= 0;
			grc <= 1; r_out <= 1; alu_op <= Shr; z_in <= 1;
		end
		shr5: begin
			grc <= 0; r_out <= 0; z_in <= 0;
			z_low_out <= 1; gra <= 1; r_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		shl3: begin
			mdr_out <= 0; ir_in <= 0;
			grb <= 1; r_out <= 1; y_in <= 1;
		end
		shl4: begin
			grb <= 0; r_out <= 0; y_in <= 0;
			grc <= 1; r_out <= 1; alu_op <= Shl; z_in <= 1;
		end
		shl5: begin
			grc <= 0; r_out <= 0; z_in <= 0;
			z_low_out <= 1; gra <= 1; r_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		ror3: begin
			mdr_out <= 0; ir_in <= 0;
			grb <= 1; r_out <= 1; y_in <= 1;
		end
		ror4: begin
			grb <= 0; r_out <= 0; y_in <= 0;
			grc <= 1; r_out <= 1; alu_op <= Ror; z_in <= 1;
		end
		ror5: begin
			grc <= 0; r_out <= 0; z_in <= 0;
			z_low_out <= 1; gra <= 1; r_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		rol3: begin
			mdr_out <= 0; ir_in <= 0;
			grb <= 1; r_out <= 1; y_in <= 1;
		end
		rol4: begin
			grb <= 0; r_out <= 0; y_in <= 0;
			grc <= 1; r_out <= 1; alu_op <= Rol; z_in <= 1;
		end
		rol5: begin
			grc <= 0; r_out <= 0; z_in <= 0;
			z_low_out <= 1; gra <= 1; r_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		and3: begin
			mdr_out <= 0; ir_in <= 0;
			grb <= 1; r_out <= 1; y_in <= 1;
		end
		and4: begin
			grb <= 0; r_out <= 0; y_in <= 0;
			grc <= 1; r_out <= 1; alu_op <= And; z_in <= 1;
		end
		and5: begin
			grc <= 0; r_out <= 0; z_in <= 0;
			z_low_out <= 1; gra <= 1; r_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		or3: begin
			mdr_out <= 0; ir_in <= 0;
			grb <= 1; r_out <= 1; y_in <= 1;
		end
		or4: begin
			grb <= 0; r_out <= 0; y_in <= 0;
			grc <= 1; r_out <= 1; alu_op <= Or; z_in <= 1;
		end
		or5: begin
			grc <= 0; r_out <= 0; z_in <= 0;
			z_low_out <= 1; gra <= 1; r_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		addi3: begin
			mdr_out <= 0; ir_in <= 0;
			grb <= 1; r_out <= 1; y_in <= 1;
		end
		addi4: begin
			grb <= 0; r_out <= 0; y_in <= 0;
			c_out <= 1; alu_op <= Add; z_in <= 1;
		end
		addi5: begin
			c_out <= 0; z_in <= 0;
			z_low_out <= 1; gra <= 1; r_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		andi3: begin
			mdr_out <= 0; ir_in <= 0;
			grb <= 1; r_out <= 1; y_in <= 1;
		end
		andi4: begin
			grb <= 0; r_out <= 0; y_in <= 0;
			c_out <= 1; alu_op <= And; z_in <= 1;
		end
		andi5: begin
			c_out <= 0; z_in <= 0;
			z_low_out <= 1; gra <= 1; r_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		ori3: begin
			mdr_out <= 0; ir_in <= 0;
			grb <= 1; r_out <= 1; y_in <= 1;
		end
		ori4: begin
			grb <= 0; r_out <= 0; y_in <= 0;
			c_out <= 1; alu_op <= Or; z_in <= 1;
		end
		ori5: begin
			c_out <= 0; z_in <= 0;
			z_low_out <= 1; gra <= 1; r_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		mul3: begin
			mdr_out <= 0; ir_in <= 0;
			gra <= 1; r_out <= 1; y_in <= 1;
		end
		mul4: begin
			gra <= 0; r_out <= 0; y_in <= 0;
			grb <= 1; r_out <= 1; alu_op <= Mul; z_in <= 1;
		end
		mul5: begin
			grb <= 0; r_out <= 0; z_in <= 0;
			z_low_out <= 1; lo_in <= 1;
		end
		mul6: begin
			z_low_out <= 0; lo_in <= 0;
			z_high_out <= 1; hi_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		div3: begin
			mdr_out <= 0; ir_in <= 0;
			gra <= 1; r_out <= 1; y_in <= 1;
		end
		div4: begin
			gra <= 0; r_out <= 0; y_in <= 0;
			grb <= 1; r_out <= 1; alu_op <= Div; z_in <= 1;
		end
		div5: begin
		grb <= 0; r_out <= 0; z_in <= 0;
			z_low_out <= 1; lo_in <= 1;
		end
		div6: begin
			z_low_out <= 0; lo_in <= 0;
			z_high_out <= 1; hi_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		neg3: begin
			mdr_out <= 0; ir_in <= 0;
			grb <= 1; r_out <= 1; alu_op <= Neg; z_in <= 1;
		end
		neg4: begin
			grb <= 0; r_out <= 0; z_in <= 0;
			z_low_out <= 1; gra <= 1; r_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		not3: begin
			mdr_out <= 0; ir_in <= 0;
			grb <= 1; r_out <= 1; alu_op <= Not; z_in <= 1;
		end
		not4: begin
			grb <= 0; r_out <= 0; z_in <= 0;
			z_low_out <= 1; gra <= 1; r_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		br3: begin
			mdr_out <= 0; ir_in <= 0;
			gra <= 1; r_out <= 1; con_in <= 1;
		end
		br4: begin
			gra <= 0; r_out <= 0; con_in <= 0;
			pc_out <= 1; y_in <= 1;
		end
		br5: begin
			pc_out <= 0; y_in <= 0;
			c_out <= 1; alu_op <= Add; z_in <= 1;
		end
		br6: begin
			c_out <= 0; z_in <= 0;
			z_low_out <= 1;
			if (con_out == 1'b1)
				pc_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		jr3: begin
			mdr_out <= 0; ir_in <= 0;
			gra <= 1; r_out <= 1; pc_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		jal3: begin
			mdr_out <= 0; ir_in <= 0;
			r_in <= 1; pc_out <= 1;
		end
		jal4: begin
			r_in <= 0; pc_out <= 0;
			gra <= 1; r_out <= 1; pc_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		in3: begin
			mdr_out <= 0; ir_in <= 0;
			gra <= 1; r_in <= 1; inport_out <= 1;
		end
		///////////////////////////////////////////////////////////////////
		out3: begin
			mdr_out <= 0; ir_in <= 0;
			gra <= 1; r_out <= 1; outport_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		mfhi3: begin
			mdr_out <= 0; ir_in <= 0;
			hi_out <= 1; gra <= 1; r_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		mflo3: begin
			mdr_out <= 0; ir_in <= 0;
			lo_out <= 1; gra <= 1; r_in <= 1;
		end
		///////////////////////////////////////////////////////////////////
		halt3: begin
			run <= 0;
		end
	endcase
end
endmodule
