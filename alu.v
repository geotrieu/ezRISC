module alu(ctrl_sig, y_data_in, bus_data_in, z_data_out);

parameter REG_SIZE = 32;

input [3:0] ctrl_sig;
input [REG_SIZE-1:0] y_data_in;
input [REG_SIZE-1:0] bus_data_in;
output reg [REG_SIZE + REG_SIZE -1:0] z_data_out;
wire [REG_SIZE + REG_SIZE - 1:0] booth_data_out;

booth_32x32_mult b_mult(booth_data_out, y_data_in, bus_data_in);
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
		z_data_out <= (y_data_in & bus_data_in);
	
	else if (ctrl_sig == 4'b0001) // or
		z_data_out <= (y_data_in | bus_data_in);	
	
	else if (ctrl_sig == 4'b0010) // add
		z_data_out <= (y_data_in + bus_data_in);
	
	else if (ctrl_sig == 4'b0011) // sub
		z_data_out <= (y_data_in - bus_data_in);
	
	else if (ctrl_sig == 4'b0100) // shr
		z_data_out <= (y_data_in >> bus_data_in);
	
	else if (ctrl_sig == 4'b0101) // shl
		z_data_out <= (y_data_in << bus_data_in);
	
	else if (ctrl_sig == 4'b0110) // ror
		z_data_out <= (y_data_in >> bus_data_in | y_data_in << (32 - bus_data_in));
	
	else if (ctrl_sig == 4'b0111) // rol
		z_data_out <= (y_data_in << bus_data_in | y_data_in >> (32 - bus_data_in));
		
	else if (ctrl_sig == 4'b1000) // mul
		z_data_out <= booth_data_out;
	
	else if (ctrl_sig == 4'b1001) // div
		z_data_out <= (y_data_in / bus_data_in);	
		
	else if (ctrl_sig == 4'b1010)	// neg
		z_data_out <= (~y_data_in) + 1'b1;	
	
	else if (ctrl_sig == 4'b1011) // not
		z_data_out <= (~y_data_in);	
	end
endmodule
