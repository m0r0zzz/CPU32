`timescale 1 ns / 100 ps

`include "test_pipeline_assembly.v"
`include "ram.v"

module test_processor_assembly(lr, sp, st, pc, syswl, syswa, sysw,  insn, clk, rst);
    input [31:0] insn;
    input clk, rst;

    output wire [31:0] lr, sp, st, pc; //special registers
    output wire [31:0] syswl, syswa; //sys w line, for raw output
    output wire sysw;

    wire [31:0] ram_w_addr, ram_r_addr;
    wire [31:0] ram_w_line, ram_r_line;
    wire ram_read, ram_write, ram_exception;
    emb_ram ram0(ram_r_addr, ram_w_addr, ram_r_line, ram_w_line, ram_read, ram_write, ram_exception, clk);

    //here comes sys peripherals
    //
    //
    //
    //

    wire [31:0] core_word = insn;
    wire [31:0] core_ram_w_addr = ram_w_addr, core_ram_r_addr = ram_r_addr;
    wire [31:0] core_ram_w_line = ram_w_line;
    wire [31:0] core_ram_r_line = ram_r_line;
    wire core_ram_read = ram_read, core_ram_write = ram_write;

    wire [31:0] core_sys_w_addr = syswa;
    wire [31:0] core_sys_r_addr;
    wire [31:0] core_sys_w_line = syswl;
    wire [31:0] core_sys_r_line;
    wire core_sys_read;
    wire core_sys_write = sysw;

    wire [31:0] core_lr = lr, core_sp = sp, core_pc = pc, core_st = st;
    test_pipeline_assembly core0(core_ram_w_addr, core_ram_r_addr, core_ram_w_line, core_ram_read, core_ram_write, core_sys_w_addr, core_sys_r_addr, core_sys_w_line, core_sys_read, core_sys_write, core_lr, core_sp, core_pc, core_st,  core_word, core_ram_r_line, core_sys_r_line, clk, rst);

endmodule
