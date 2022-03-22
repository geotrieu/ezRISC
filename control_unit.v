`timescale 1ns/10ps
module control_unit (

output reg gra, grb, grc, r_in, r_out, ba_out, hi_in, 
hi_out, lo_in, lo_out, pc_in, pc_out, ir_in, z_in, 
z_high_out, z_low_out, inport_out, inport_ext_input,
c_out, y_in, mar_in, outport_in, mdr_in, mdr_out, read,
write, alu_op, inc_pc, bus_data, outport_ext_output, 
Clear,
input [31:0] ir_data,
input clk, reset_n, ..., con_ff);

parameter And = 4'b0000, Or = 4'b0001, Add = 4'b0010, Sub = 4'b0011, Shr = 4'b0100, Shl = 4'b0101,
	Ror = 4'b0110, Rol = 4'b0111, Mul = 4'b1000, Div = 4'b1001, Neg = 4'b1010, Not = 4'b1011;
	
parameter reset_n_state = 7’b0000000, fetch0 = 7’b0000001, fetch1 = 7’b0000010, fetch2 = 7’b0000011,
ld3  = 7’b0000100, ld4  = 7’b0000101, ld5  = 7’b0000110, ld6  = 7’b0000111, ld7  = 7’b0001000, 
ld8  = 7’b0001001,
ldi3 = 7’b0001010, ldi4 = 7’b0001011, ldi5 = 7’b0001100, ldi6 = 7’b0001101,
st3  = 7’b0001110, st4  = 7’b0001111, st5  = 7’b0010000, st6  = 7’b0010001, st7  = 7’b0010010, 
st8  = 7’b0010011,
add3 = 7’b0010100, add4 = 7’b0010101, add5 = 7’b0010110, add6 = 7’b0010111,
sub3 = 7’b0011000, sub4 = 7’b0011001, sub5 = 7’b0011010, sub6 = 7’b0011011,
shr3 = 7’b0011100, shr4 = 7’b0011101, shr5 = 7’b0011110, shr6 = 7’b0011111,
shl3 = 7’b0100000, shl4 = 7’b0100001, shl5 = 7’b0100010, shl6 = 7’b0100011,
ror3 = 7’b0100100, ror4 = 7’b0100101, ror5 = 7’b0100110, ror6 = 7’b0100111,
rol3 = 7’b0101000, rol4 = 7’b0101001, rol5 = 7’b0101010, rol6 = 7’b0101011,
and3 = 7’b0101100, and4 = 7’b0101101, and5 = 7’b0101110, and6 = 7’b0101111,
or3  = 7’b0110000, or4  = 7’b0110001, or5  = 7’b0110010, or6  = 7’b0110011,
andi3 = 7’b0110100, andi4 = 7’b0110101, andi5 = 7’b0110110, andi6 = 7’b0110111,
ori3 = 7’b0111000, ori4 = 7’b0111001, ori5 = 7’b0111010, ori6 = 7’b0111011,
mul3 = 7’b0111100, mul4 = 7’b0111101, mul5 = 7’b0111110, mul6 = 7’b0111111, mul7 = 7’b1000000,
div3 = 7’b1000001, div4 = 7’b1000010, div5 = 7’b1000011, div6 = 7’b1000100, div7 = 7’b1000101,
neg3 = 7’b1000110, neg4 = 7’b1000111, neg5 = 7’b1001000,
not3 = 7’b1001001, not4 = 7’b1001010, not5 = 7’b1001011,
br3  = 7’b1001100, br4  = 7’b1001101, br5  = 7’b1001110, br6  = 7’b1001111, br7  = 7’b1010000,
jr3  = 7’b1010001, jr4  = 7’b1010010,
jal3 = 7’b1010011, jal4 = 7’b1010100, jal5 = 7’b1010101,
in3  = 7’b1010110, in4  = 7’b1010111,
out3 = 7’b1011000, out4 = 7’b1011001,
mfhi3 = 7’b1011010, mfhi4 = 7’b1011011,
mflo3 = 7’b1011100, mflo4 = 7’b1011101,
////////////////////////////////////////////
////////////////////////////////////////////
////////////////////////////////////////////
// add nop and halt
////////////////////////////////////////////
////////////////////////////////////////////
////////////////////////////////////////////
;
reg [6:0] Present_state = reset_n_state; 

always @(posedge clk, posedge reset_n) // finite state machine; if clk or reset_n rising-edge
begin
	if (reset_n == 1’b1) Present_state = reset_n_state;
	else 
	begin
		case (Present_state)
			reset_n_state : Present_state = fetch0;
			fetch0 : Present_state = fetch1;
			fetch1 : Present_state = fetch2;
			fetch2 : begin
				case (ir_data[31:27]) // inst. decoding based on the opcode to set the next state
					5’b00000 : Present_state = ld3;
					5’b00001 : Present_state = ldi3;
					5’b00010 : Present_state = st3;
					5’b00011 : Present_state = add3;
					5’b00100 : Present_state = sub3;
					5’b00101 : Present_state = shr3;
					5’b00110 : Present_state = shl3;
					5’b00111 : Present_state = ror3;
					5’b01000 : Present_state = rol3;
					5’b01001 : Present_state = and3;
					5’b01010 : Present_state = or3;
					5’b01100 : Present_state = andi3;
					5’b01101 : Present_state = ori3;
					5’b01110 : Present_state = mul3;
					5’b01111 : Present_state = div3;
					5’b10000 : Present_state = neg3;
					5’b10001 : Present_state = not3;
					5’b10010 : Present_state = br3;
					5’b10011 : Present_state = jr3;
					5’b10100 : Present_state = jal3;
					5’b10101 : Present_state = in3;
					5’b10110 : Present_state = out3;
					5’b10111 : Present_state = mfhi3;
					5’b11000 : Present_state = mflo3;
					5’b11001 : Present_state = nop3;
					5’b11010 : Present_state = halt3;
				endcase
			end
			ld3 : Present_state = ld4;
			ld4 : Present_state = ld5;
			ld5 : Present_state = ld6;
			ld6 : Present_state = ld7;
			ld7 : Present_state = ld8;
			ld8 : Present_state = reset_n_state;

			ldi3 : Present_state = ldi4;
			ldi4 : Present_state = ldi5;
			ldi5 : Present_state = ldi6;
			ldi6 : Present_state = reset_n_state;
			
			st3 : Present_state = st4;
			st4 : Present_state = st5;
			st5 : Present_state = st6;
			st6 : Present_state = st7;
			st7 : Present_state = st8;
			st8 : Present_state = reset_n_state;
			
			add3 : Present_state = add4;
			add4 : Present_state = add5;
			add5 : Present_state = add6;
			add6 : Present_state = reset_n_state;
			
			sub3 : Present_state = sub4;
			sub4 : Present_state = sub5;
			sub5 : Present_state = sub6;
			sub6 : Present_state = reset_n_state;
			
			shr3 : Present_state = shr4;
			shr4 : Present_state = shr5;
			shr5 : Present_state = shr6;
			shr6 : Present_state = reset_n_state;
			
			shl3 : Present_state = shl4;
			shl4 : Present_state = shl5;
			shl5 : Present_state = shl6;
			shl6 : Present_state = reset_n_state;
			
			ror3 : Present_state = ror4;
			ror4 : Present_state = ror5;
			ror5 : Present_state = ror6;
			ror6 : Present_state = reset_n_state;
			
			rol3 : Present_state = rol4;
			rol4 : Present_state = rol5;
			rol5 : Present_state = rol6;
			rol6 : Present_state = reset_n_state;
			
			and3 : Present_state = and4;
			and4 : Present_state = and5;
			and5 : Present_state = and6;
			and6 : Present_state = reset_n_state;
			
			or3 : Present_state = or4;
			or4 : Present_state = or5;
			or5 : Present_state = or6;
			or6 : Present_state = reset_n_state;
			
			andi3 : Present_state = andi4;
			andi4 : Present_state = andi5;
			andi5 : Present_state = andi6;
			andi6 : Present_state = reset_n_state;
			
			ori3 : Present_state = ori4;
			ori4 : Present_state = ori5;
			ori5 : Present_state = ori6;
			ori6 : Present_state = reset_n_state;
			
			mul3 : Present_state = mul4;
			mul4 : Present_state = mul5;
			mul5 : Present_state = mul6;
			mul6 : Present_state = mul7;
			mul7 : Present_state = reset_n_state;
			
			div3 : Present_state = div4;
			div4 : Present_state = div5;
			div5 : Present_state = div6;
			div6 : Present_state = div7;
			div7 : Present_state = reset_n_state;
			
			neg3 : Present_state = neg4;
			neg4 : Present_state = neg5;
			neg5 : Present_state = reset_n_state;
			
			not3 : Present_state = not4;
			not4 : Present_state = not5;
			not5 : Present_state = reset_n_state;
			
			br3 : Present_state = br4;
			br4 : Present_state = br5;
			br5 : Present_state = br6;
			br6 : Present_state = br7;
			br7 : Present_state = reset_n_state;
			
			jr3 : Present_state = jr4;
			jr4 : Present_state = reset_n_state;
			
			jal3 : Present_state = jal4;
			jal4 : Present_state = jal5
			jal5 : Present_state = reset_n_state;
			
			in3 : Present_state = in4;
			in4 : Present_state = reset_n_state;
			
			out3 : Present_state = out4;
			out4 : Present_state = reset_n_state;
			
			mfhi3 : Present_state = mfhi4;
			mfhi4 : Present_state = reset_n_state;
			
			mflo3 : Present_state = mflo4;
			mflo4 : Present_state = reset_n_state;
			
			////////////////////////////////////////////
			////////////////////////////////////////////
			////////////////////////////////////////////
			// ADD NOP AND HALT
			////////////////////////////////////////////
			////////////////////////////////////////////
			////////////////////////////////////////////
		endcase
	end
end
always @(Present_state) // do the job for each state
begin
	case (Present_state) // assert the required_data signals in each state
		reset_n_state: begin
			pc_out 		<= 	0;
			z_low_out 	<= 	0;
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
			reset_n <= 0;
			#10 reset_n <= 1;
		end
		fetch0: begin
			#10 pc_out <= 1; mar_in <= 1; inc_pc <= 1; z_in <= 1; alu_op <= Add;
			#15 pc_out <= 0; mar_in <= 0; inc_pc <= 0; z_in <= 0;
		end
		fetch1: begin
			#10 z_low_out <= 1; pc_in <= 1; read <= 1; mdr_in <= 1;
			#15 z_low_out <= 0; pc_in <= 0; read <= 0; mdr_in <= 0;
		end
		ld3: begin
			// whatever goes here. Thinking un assert signals from previous state on each state and assert new signals?
		end
		⁞
	endcase
end
endmodule
