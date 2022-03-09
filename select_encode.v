module select_encode(ir, gra, grb, grc, r_in, r_out, ba_out, gpr_in, gpr_out, c_se);

parameter REG_SIZE = 32;

input [REG_SIZE - 1:0] ir;
input gra;
input grb;
input grc;
input r_in;
input r_out;
input ba_out;

output [15:0] gpr_in;
output [15:0] gpr_out;
output [REG_SIZE - 1:0] c_se;

wire [4:0] ir_opcode;
wire [3:0] ir_ra;
wire [3:0] ir_rb;
wire [3:0] ir_rc;
wire [18:0] ir_const;

assign ir_opcode = ir[31:27];
assign ir_ra = ir[26:23];
assign ir_rb = ir[22:19];
assign ir_rc = ir[18:15];
assign ir_const = ir[18:0];

wire [3:0] decoder_code;
wire [15:0] decoder_out;
assign decoder_code = (ir_ra & {4{gra}}) | (ir_rb & {4{grb}}) | (ir_rc & {4{grc}});

wire [3:0] decoder_in;
wire code_mux_sel;
//OP Code for jal. In order for R15 to be triggered, both the jal instr and r_in must be active. 
assign code_mux_sel = ((ir_opcode == 5'b10100) && r_in);
mux_32bit_2to1 #(.REG_SIZE(4)) code_mux(decoder_code, 4'b1111, code_mux_sel, decoder_in);

dec_4to16 decoder(
	.code(decoder_in),
	.out(decoder_out));
	
assign gpr_in = decoder_out & {16{r_in}};
assign gpr_out = decoder_out & {16{r_out | ba_out}};

assign c_se = {{13{ir_const[18]}}, ir_const[18:0]};

endmodule
