`timescale 1 ns / 100 ps

`include "alu.v"

module execute(r1, r2, ..., a, b, op, swp)
    input [31:0] a, b;
    input [7:0] op;
    input swp;

    output [31:0] r1, r2;

