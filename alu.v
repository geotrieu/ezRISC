module alu(ctrl_sig, a_data_in, b_data_in, c_data_out);

parameter REG_SIZE = 32;

input [3:0] ctrl_sig;
input [REG_SIZE-1:0] a_data_in;
input [REG_SIZE-1:0] b_data_in;
output reg [REG_SIZE + REG_SIZE -1:0] c_data_out;
wire [REG_SIZE + REG_SIZE - 1:0] booth_data_out;
wire [REG_SIZE + REG_SIZE - 1:0] div_data_out;
booth_32x32_mult b_mult(booth_data_out, a_data_in, b_data_in);
divider_non_restoring divider(div_data_out, a_data_in, b_data_in);
// and 0000
// or  0001
// add 0010
// sub 0011
// shr 0100
// shl 0101
// ror 0110
// rol 0111
// mul 1000
// div 1001
// neg 1010
// not 1011
always @(*)
begin
	if (ctrl_sig == 4'b0000) // and
		c_data_out <= {32'b0, (a_data_in & b_data_in)};
	
	else if (ctrl_sig == 4'b0001) // or
		c_data_out <= {32'b0, (a_data_in | b_data_in)};	
	
	else if (ctrl_sig == 4'b0010) // add
		c_data_out <= $signed(a_data_in + b_data_in);
	
	else if (ctrl_sig == 4'b0011) // sub
		c_data_out <= $signed(a_data_in - b_data_in);
	
	else if (ctrl_sig == 4'b0100) // shr
		c_data_out <= (a_data_in >> b_data_in);
	
	else if (ctrl_sig == 4'b0101) // shl
		c_data_out <= (a_data_in << b_data_in);
	
	else if (ctrl_sig == 4'b0110) // ror
		c_data_out [31:0] <= (a_data_in >> b_data_in[4:0] | a_data_in << (32 - b_data_in[4:0]));
	
	else if (ctrl_sig == 4'b0111) // rol
		c_data_out [31:0] <= (a_data_in << b_data_in[4:0] | a_data_in >> (32 - b_data_in[4:0]));
		
	else if (ctrl_sig == 4'b1000) // mul
		c_data_out <= booth_data_out;
	
	else if (ctrl_sig == 4'b1001) // div
		c_data_out <= div_data_out;
		
	else if (ctrl_sig == 4'b1010)	// neg
		c_data_out <= (~b_data_in) + 1'b1;	
	
	else if (ctrl_sig == 4'b1011) // not
		c_data_out <= (~b_data_in);	
	end
endmodule
