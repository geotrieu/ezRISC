`timescale 1ns / 1ps

module alu_tb;

reg[31:0] A,B;
reg[3:0] ALU_ctrl;

wire[31:0] result;

alu test_unit(ALU_ctrl, A, B, result);

initial begin
A = 8'h0A;
B = 4'h02;
ALU_ctrl = 4'h0;

#10;

ALU_ctrl = 4'h1;

#10;

ALU_ctrl = 4'h2;

#10;

ALU_ctrl = 4'h3;

#10;

ALU_ctrl = 4'h4;

#10;

ALU_ctrl = 4'h5;

#10;

ALU_ctrl = 4'h6;

#10;

ALU_ctrl = 4'h7;

#10;

ALU_ctrl = 4'h8;

#10;

ALU_ctrl = 4'h9;

#10;

ALU_ctrl = 4'hA;

#10;

ALU_ctrl = 4'hB;

#10;

A = 8'hFFFFFFFF;
B = 8'hFFFFFFFF;

end

endmodule
