`timescale 1 ns / 100 ps

`include "execute.v"
`include "memory_op.v"
`include "register_wb.v"
`include "pipeline_interface.v"
`include "insn_decoder.v"
`include "regs.v"

/*module test_pipeline_assembly(e_a, e_b, e_alu_op, e_is_cond, e_cond, e_write_flags, e_swp, m_a1, m_a2, m_r1_op, m_r2_op, r_a1, r_a2, r_op, pass, pcincr, clk, rst);
    input [31:0] e_a, e_b;
    input [4:0] e_ra1, e_ra2;
    input [3:0] e_rop;
    input [7:0] e_alu_op;
    input [3:0] e_cond;
    input [3:0] e_write_flags;
    input e_swp;
    input e_is_cond;
    input [31:0] m_a1, m_a2;
    input [3:0] m_r1_op, m_r2_op;
    input [4:0] r_a1, r_a2;
    input [3:0] r_op;
    input pass;
    input pcincr;*/
module test_pipeline_assembly(ram_w_addr, ram_r_addr, ram_w_line, ram_read, ram_write, sys_w_addr, sys_r_addr, sys_w_line, sys_read, sys_write, lr, sp, pc, st,  word, ram_r_line, sys_r_line, clk, rst);
    input [31:0] word;

    input clk, rst;

    output wire [31:0] ram_w_addr, ram_r_addr;
    output wire [31:0] ram_w_line;
    input  [31:0] ram_r_line;
    output wire ram_read, ram_write;

    output wire [31:0] sys_w_addr, sys_r_addr;
    output wire [31:0] sys_w_line;
    input  [31:0] sys_r_line;
    output wire sys_read, sys_write;

    output wire [31:0] lr, sp, pc, st;

    /*wire [31:0] ram_w_addr, ram_r_addr;
    wire [31:0] ram_w_line, ram_r_line;
    wire ram_read, ram_write, ram_exception;
    emb_ram ram0(.r_addr = ram_r_addr, .w_addr = ram_w_addr, .r_line = ram_r_line, .w_line = ram_w_line, .read = ram_read, .write = ram_write, .exc = ram_exception, .clk = clk);*/

    wire [31:0] reg_a, reg_b, reg_c, reg_d;
    wire [4:0] reg_a_a, reg_a_b, reg_a_c, reg_a_d;
    wire [1:0] reg_read, reg_write;

    wire [31:0] reg_lr, reg_sp, reg_pc;
    wire [31:0] reg_stin, reg_stout;
    wire reg_stwr;
    wire reg_pcincr;
    reg32_2x2_pc rf0(reg_a, reg_b, reg_a_a, reg_a_b, reg_a_c, reg_a_d,  reg_c,  reg_d, reg_read, reg_write, clk, rst,  reg_lr,  reg_sp, reg_stout, reg_pc, reg_stin, reg_stwr, reg_pcincr);


    wire [31:0] e_a, e_b;
    wire [7:0] e_alu_op;
    wire [3:0] e_cond;
    wire [3:0] e_write_flags;
    wire e_swp;
    wire e_is_cond;

    wire [31:0] m_a1, m_a2;
    wire [3:0] m_r1_op, m_r2_op;

    wire [4:0] r_a1, r_a2;
    wire [3:0] r_op;

    wire d_pass;
    wire d_pcincr;

    wire [4:0] r_r1_a = reg_a_a, r_r2_a = reg_a_b;
    wire [1:0] r_read = reg_read;

    wire [31:0] d_word = word;
    wire [31:0] d_r1 = reg_a, d_r2 = reg_b;
    insn_decoder dec0(e_a, e_b, e_alu_op, e_is_cond, e_cond, e_write_flags, e_swp, m_a1, m_a2, m_r1_op, m_r2_op, r_a1, r_a2, r_op, d_pass, d_pcincr, r_r1_a, r_r2_a, r_read, d_word, d_r1, d_r2, rst, clk);


    wire [31:0] pi_e_a, pi_e_b;
    wire [7:0] pi_e_alu_op;
    wire [3:0] pi_e_cond;
    wire [3:0] pi_e_write_flags;
    wire pi_e_swp;
    wire pi_e_is_cond;

    wire [31:0] pi_m_a1, pi_m_a2;
    wire [3:0] pi_m_r1_op, pi_m_r2_op;

    wire [4:0] pi_r_a1, pi_r_a2;
    wire [3:0] pi_r_op;

    wire pi_d_pcincr = reg_pcincr;

    pipeline_interface pi0(
    pi_e_a, pi_e_b, pi_e_alu_op, pi_e_is_cond, pi_e_cond, pi_e_write_flags, pi_e_swp, pi_m_a1, pi_m_a2, pi_m_r1_op, pi_m_r2_op, pi_r_a1, pi_r_a2, pi_r_op, pi_d_pcincr,
    e_a, e_b, e_alu_op, e_is_cond, e_cond, e_write_flags, e_swp, m_a1, m_a2, m_r1_op, m_r2_op, r_a1, r_a2, r_op, d_pass, d_pcincr, clk, rst);


    wire [31:0] ex_a = pi_e_a, ex_b = pi_e_b; //operands
    wire [31:0] ex_st = reg_stout; //status register
    wire [7:0] ex_alu_op = pi_e_alu_op; // alu operation
    wire ex_is_cond = pi_e_is_cond; //is a conditional command signal
    wire [3:0] ex_cond = pi_e_cond; //cc
    wire [3:0] ex_write_flags = pi_e_write_flags; //write n/z/c/v
    wire ex_swp = pi_e_swp; //swap ops?

    wire [31:0] ex_r1, ex_r2; //results, sync
    wire ex_n, ex_z, ex_c, ex_v; //flags, async
    wire ex_cc; //write flags, async
    wire ex_cres; //conditional results, sync
    execute ex0(ex_r1, ex_r2, ex_cres, ex_n, ex_z, ex_c, ex_v, ex_cc, ex_a, ex_b, ex_alu_op, ex_is_cond, ex_cond, ex_write_flags, ex_st, ex_swp, clk, rst);


    wire sr_n = ex_n, sr_z = ex_z, sr_c = ex_c, sr_v = ex_v;
    wire sr_cc = ex_cc;

    wire [31:0] sr_st = reg_stin;
    wire sr_stwr = reg_stwr;
    status_register_adaptor sr0(sr_st, sr_stwr, sr_n, sr_z, sr_c, sr_v, sr_cc);


    wire [31:0] ex_m_a1, ex_m_a2; //(mem_op)
    wire [3:0] ex_m_r1_op, ex_m_r2_op; //(mem_op)

    wire [4:0] ex_r_a1, ex_r_a2; //(reg_wb)
    wire [3:0] ex_r_op; //(reg_wb)
    execute_stage_passthrough exh0(ex_m_a1, ex_m_a2, ex_m_r1_op, ex_m_r2_op, ex_r_a1, ex_r_a2, ex_r_op, pi_m_a1, pi_m_a2, pi_m_r1_op, pi_m_r2_op, pi_r_a1, pi_r_a2, pi_r_op, clk, rst);


    wire [31:0] mop_r1 = ex_r1, mop_r2 = ex_r2; //inputs
    wire [31:0] mop_a1 = ex_m_a1, mop_a2 = ex_m_a2; //memory addresses

    wire [3:0] mop_r1_op = ex_m_r1_op, mop_r2_op = ex_m_r2_op; //operation codes

    wire [31:0] mop_ram_r_line = ram_r_line, mop_sys_r_line = sys_r_line; // read lanes

    wire mop_proceed = ex_cres; //conditional code test result

    wire [31:0] mop_m1, mop_m2; //outputs

    wire [31:0] mop_ram_w_addr = ram_w_addr, mop_sys_w_addr = sys_w_addr; //write addresses
    wire [31:0] mop_ram_r_addr = ram_r_addr, mop_sys_r_addr = sys_r_addr; //read addresses

    wire [31:0] mop_ram_w_line = ram_w_line, mop_sys_w_line = sys_w_line; //write lanes

    wire mop_ram_w = ram_write, mop_sys_w = sys_write, mop_ram_r = ram_read, mop_sys_r = sys_read; //read/write signals
    memory_op mop0( mop_m1, mop_m2, mop_ram_w_addr, mop_ram_r_addr, mop_ram_w, mop_ram_r, mop_ram_w_line, mop_sys_w_addr, mop_sys_w_line, mop_sys_w, mop_sys_r, mop_r1, mop_r2, mop_a1, mop_a2, mop_r1_op, mop_r2_op, mop_ram_r_line, mop_sys_r_line, mop_proceed, clk, rst);

    wire [4:0] mop_r_a1, mop_r_a2; //(reg_wb)
    wire [3:0] mop_r_op; //(reg_wb)
    wire mop_proceed2;
    memory_op_stage_passthrough moph0(mop_r_a1, mop_r_a2, mop_r_op, mop_proceed2, ex_r_a1, ex_r_a2, ex_r_op, ex_cres, clk, rst);


    wire [31:0] rwb_r1 = mop_m1, rwb_r2 = mop_m2;
    wire [4:0] rwb_a1 = mop_r_a1, rwb_a2 = mop_r_a2;

    wire [3:0] rwb_op = mop_r_op;

    wire rwb_proceed = mop_proceed2;

    wire [31:0] rwb_wr1 = reg_c, rwb_wr2 = reg_d;
    wire [4:0] rwb_wa1 = reg_a_c, rwb_wa2 = reg_a_d;
    wire [1:0] rwb_write = reg_write;
    register_wb rwb0( rwb_write, rwb_wr1, rwb_wr2, rwb_wa1, rwb_wa2, rwb_r1, rwb_r2, rwb_a1, rwb_a2, rwb_op, rwb_proceed, clk, rst);

    assign lr = reg_lr;
    assign pc = reg_pc;
    assign st = reg_stout;
    assign sp = reg_sp;

endmodule
