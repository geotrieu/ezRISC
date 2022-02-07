module mux_32bit_32to1 #(parameter REG_SIZE=32)(
	input [REG_SIZE-1:0] r0,
	input [REG_SIZE-1:0] r1,
	input [REG_SIZE-1:0] r2,
	input [REG_SIZE-1:0] r3,
	input [REG_SIZE-1:0] r4,
	input [REG_SIZE-1:0] r5,
	input [REG_SIZE-1:0] r6,
	input [REG_SIZE-1:0] r7,
	input [REG_SIZE-1:0] r8,
	input [REG_SIZE-1:0] r9,
	input [REG_SIZE-1:0] r10,
	input [REG_SIZE-1:0] r11,
	input [REG_SIZE-1:0] r12,
	input [REG_SIZE-1:0] r13,
	input [REG_SIZE-1:0] r14,
	input [REG_SIZE-1:0] r15,
	input [REG_SIZE-1:0] r16,
	input [REG_SIZE-1:0] r17,
	input [REG_SIZE-1:0] r18,
	input [REG_SIZE-1:0] r19,
	input [REG_SIZE-1:0] r20,
	input [REG_SIZE-1:0] r21,
	input [REG_SIZE-1:0] r22,
	input [REG_SIZE-1:0] r23,
	input [REG_SIZE-1:0] r24,
	input [REG_SIZE-1:0] r25,
	input [REG_SIZE-1:0] r26,
	input [REG_SIZE-1:0] r27,
	input [REG_SIZE-1:0] r28,
	input [REG_SIZE-1:0] r29,
	input [REG_SIZE-1:0] r30,
	input [REG_SIZE-1:0] r31,
	input [4:0] sel,
	output reg [REG_SIZE-1:0] out
);

always @(*)
begin
	case (sel)
		5'b00000: out <= r0[REG_SIZE-1:0];
		5'b00001: out <= r1[REG_SIZE-1:0];
		5'b00010: out <= r2[REG_SIZE-1:0];
		5'b00011: out <= r3[REG_SIZE-1:0];
		5'b00100: out <= r4[REG_SIZE-1:0];
		5'b00101: out <= r5[REG_SIZE-1:0];
		5'b00110: out <= r6[REG_SIZE-1:0];
		5'b00111: out <= r7[REG_SIZE-1:0];
		5'b01000: out <= r8[REG_SIZE-1:0];
		5'b01001: out <= r9[REG_SIZE-1:0];
		5'b01010: out <= r10[REG_SIZE-1:0];
		5'b01011: out <= r11[REG_SIZE-1:0];
		5'b01100: out <= r12[REG_SIZE-1:0];
		5'b01101: out <= r13[REG_SIZE-1:0];
		5'b01110: out <= r14[REG_SIZE-1:0];
		5'b01111: out <= r15[REG_SIZE-1:0];
		5'b10000: out <= r16[REG_SIZE-1:0];
		5'b10001: out <= r17[REG_SIZE-1:0];
		5'b10010: out <= r18[REG_SIZE-1:0];
		5'b10011: out <= r19[REG_SIZE-1:0];
		5'b10100: out <= r20[REG_SIZE-1:0];
		5'b10101: out <= r21[REG_SIZE-1:0];
		5'b10110: out <= r22[REG_SIZE-1:0];
		5'b10111: out <= r23[REG_SIZE-1:0];
		5'b11000: out <= r24[REG_SIZE-1:0];
		5'b11001: out <= r25[REG_SIZE-1:0];
		5'b11010: out <= r26[REG_SIZE-1:0];
		5'b11011: out <= r27[REG_SIZE-1:0];
		5'b11100: out <= r28[REG_SIZE-1:0];
		5'b11101: out <= r29[REG_SIZE-1:0];
		5'b11110: out <= r30[REG_SIZE-1:0];
		5'b11111: out <= r31[REG_SIZE-1:0];
		default: begin end
	endcase
end

endmodule
