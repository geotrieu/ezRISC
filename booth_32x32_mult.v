module booth_32x32_mult(product, Q, M);

parameter REG_SIZE = 32;
parameter REG_HALF_SIZE = REG_SIZE/2;
input [REG_SIZE-1:0] Q, M;
output [REG_SIZE + REG_SIZE - 1:0] product;
reg [REG_SIZE + REG_SIZE -1:0] prod;
reg [2:0] two_bit_recoding[REG_SIZE-1:0];
reg [REG_SIZE + REG_SIZE-1:0] partial_products[REG_HALF_SIZE-1:0];
wire [REG_SIZE:0] inverted_M;
integer i, j;

assign inverted_M = {~M[REG_SIZE-1],~M}+1;

always @ (*)
begin

	two_bit_recoding[0] = {Q[1], Q[0], 1'b0}; // set recoding bits for first bit
	j = 1;
	
	for(i = 2; i < REG_SIZE; i = i + 2) 
	begin // set rest of recoding bits
		two_bit_recoding[j] = {Q[i+1], Q[i], Q[i-1]};
		j = j + 1;
	end
	
	for(i = 0; i < REG_HALF_SIZE; i = i + 1) 
	begin
		case(two_bit_recoding[i])
			3'b001, 3'b010 : partial_products[i] = $signed({M[REG_SIZE-1],M});
			3'b011 : partial_products[i] = $signed({M, 1'b0});
			3'b100 : partial_products[i] = $signed({inverted_M[REG_SIZE-1:0], 1'b0});
			3'b101, 3'b110 : partial_products[i] = $signed(inverted_M);
			default : partial_products[i] = 0;
		endcase
		
	end
	
	prod = partial_products[0];
	
	// bit shift all the partial products
	for (i = 1; i < REG_HALF_SIZE; i = i + 1)
		partial_products[i] = partial_products[i] << (i + i);
	// add all partial products
	for (i = 1; i < REG_HALF_SIZE; i = i + 1)
		prod = prod + partial_products[i];
end
assign product = prod;
endmodule
