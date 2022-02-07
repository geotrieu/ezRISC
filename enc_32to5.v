module enc_32to5(
	input r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15,
	input r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31,
	output reg [4:0] out
);

always @(*)
begin
	if (r0)
		out <= 5'b00000;
	else if (r1)
		out <= 5'b00001;
	else if (r2)
		out <= 5'b00010;
	else if (r3)
		out <= 5'b00011;
	else if (r4)
		out <= 5'b00100;
	else if (r5)
		out <= 5'b00101;
	else if (r6)
		out <= 5'b00110;
	else if (r7)
		out <= 5'b00111;
	else if (r8)
		out <= 5'b01000;
	else if (r9)
		out <= 5'b01001;
	else if (r10)
		out <= 5'b01010;
	else if (r11)
		out <= 5'b01011;
	else if (r12)
		out <= 5'b01100;
	else if (r13)
		out <= 5'b01101;
	else if (r14)
		out <= 5'b01110;
	else if (r15)
		out <= 5'b01111;
	else if (r16)
		out <= 5'b10000;
	else if (r17)
		out <= 5'b10001;
	else if (r18)
		out <= 5'b10010;
	else if (r19)
		out <= 5'b10011;
	else if (r20)
		out <= 5'b10100;
	else if (r21)
		out <= 5'b10101;
	else if (r22)
		out <= 5'b10110;
	else if (r23)
		out <= 5'b10111;
	else if (r24)
		out <= 5'b11000;
	else if (r25)
		out <= 5'b11001;
	else if (r26)
		out <= 5'b11010;
	else if (r27)
		out <= 5'b11011;
	else if (r28)
		out <= 5'b11100;
	else if (r29)
		out <= 5'b11101;
	else if (r30)
		out <= 5'b11110;
	else if (r31)
		out <= 5'b11111;
	else
		out <= 5'bxxxxx;
end

endmodule
