module alu(ctrl_sig, y_data_in, bus_data_in, z_data_out);

parameter REG_SIZE = 32;

input [3:0] ctrl_sig;
input [REG_SIZE-1:0] y_data_in;
input [REG_SIZE-1:0] bus_data_in;
output reg [REG_SIZE + REG_SIZE -1:0] z_data_out;
wire [REG_SIZE + REG_SIZE - 1:0] booth_data_out;

booth_32x32_mult b_mult[REG_SIZE+REG_SIZE-1:0](booth_data_out, y_data_in, bus_data_in);
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
	if (ctrl_sig == 4'b0000)
		z_data_out <= (y_data_in & bus_data_in);
	else if (ctrl_sig == 4'b0001)
		z_data_out <= (y_data_in | bus_data_in);	
	else if (ctrl_sig == 4'b0010)
		z_data_out <= (y_data_in + bus_data_in);
	else if (ctrl_sig == 4'b0011)
		z_data_out <= (y_data_in - bus_data_in);
	else if (ctrl_sig == 4'b0100)
		z_data_out <= (y_data_in >> bus_data_in);
	else if (ctrl_sig == 4'b0101)
		z_data_out <= (y_data_in << bus_data_in);
	else if (ctrl_sig == 4'b0110)
		z_data_out <= (y_Data_in << bus_data_in | y_data_in >> $bits(y_Data_in) - bus_data_in);
	else if (ctrl_sig == 4'b0111)
		z_data_out <= (y_Data_in >> bus_data_in | y_data_in << $bits(y_data_in) - bus_data_in);
		
	else if (ctrl_sig == 4'b1000) begin
		
		z_data_out <= booth_data_out;
		
	end else if (ctrl_sig == 4'b1001)
		z_data_out <= (y_data_in / bus_data_in);	
		
	else if (ctrl_sig == 4'b1010)
		z_data_out <= (~y_data_in);	
	else if (ctrl_sig == 4'b1011)
		z_data_out <= (!y_data_in);	
	end
endmodule
