`timescale 1ns / 1ps

module alu_tb;

reg[31:0] A,B;
reg[3:0] ALU_ctrl;

wire[31:0] result;

alu test_unit(ALU_ctrl, A, B, result);

initial begin
A = 32'h0A;
B = 32'h02;
ALU_ctrl = 4'h0;

#10;

ALU_ctrl = 4'h1;

#10;

ALU_ctrl = 4'h2;

#10;

A = 32'hFFFFFFFF;
B = 32'hFFFFFFFF;

end

endmodule
