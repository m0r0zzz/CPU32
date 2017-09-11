`timescale 1 ns / 1 ps

`define INTERFACE_STAGE_NO_DELAY
`define RWB_STAGE_HAZARD

`include "test_pipeline_assembly.v"
`include "test_periph_assembly.v"

`ifdef GATE_LEVEL_SIM
	`include "synth/lib/osu025_stdcells.v" //library
	`include "synth/emb_ram.v" //additional
`else
	`include "ram.v"
`endif

// BEWARE:
// general rule for continuous assignment statements
// you can use continuous assignment in instantiation (e.g. wire a = b;) only if a - input and b - output
// if we got reverse situation, we must provide good continuous assignment below ( assign b = a )
// "continuous assignment is not bidirectional; it have dataflow directed from rvalue to lvalue"

module test_processor_assembly(lr, sp, st, pc, pins,  insn, clk, rst);
    input [31:0] insn;
    input clk, rst;

    output wire [31:0] lr, sp, st, pc; //special registers
    inout [127:0] pins; //device pins

    wire [31:0] ram_w_addr, ram_r_addr; //input
    wire [31:0] ram_w_line, ram_r_line; //input, output
    wire ram_read, ram_write, ram_exception; //output
    emb_ram ram0(ram_r_addr, ram_w_addr, ram_r_line, ram_w_line, ram_read, ram_write, ram_exception, clk);

    wire [31:0] core_word = insn; //input
    wire [31:0] core_ram_w_addr, core_ram_r_addr; //output
    assign ram_w_addr = core_ram_w_addr, ram_r_addr = core_ram_r_addr;
    wire [31:0] core_ram_w_line; //output
    assign ram_w_line = core_ram_w_line;
    wire [31:0] core_ram_r_line = ram_r_line; //input
    wire core_ram_read, core_ram_write; //output
    assign ram_read = core_ram_read, ram_write = core_ram_write;

    wire [31:0] core_sys_w_addr, core_sys_r_addr; //output
    wire [31:0] core_sys_w_line; //output
    wire [31:0] core_sys_r_line; //input
    wire core_sys_read, core_sys_write; //output

    wire [31:0] core_lr, core_sp, core_pc, core_st; //output
    assign lr = core_lr, sp = core_sp, pc = core_pc, st = core_st;
    test_pipeline_assembly core0(core_ram_w_addr, core_ram_r_addr, core_ram_w_line, core_ram_read, core_ram_write, core_sys_w_addr, core_sys_r_addr, core_sys_w_line, core_sys_read, core_sys_write, core_lr, core_sp, core_pc, core_st,  core_word, core_ram_r_line, core_sys_r_line, clk, rst);

    test_periph_assembly periph0(pins, core_sys_w_addr, core_sys_r_addr, core_sys_w_line, core_sys_r_line, core_sys_write, core_sys_read, rst, clk);

endmodule
