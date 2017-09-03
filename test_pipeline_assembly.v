`timescale 1 ns / 1 ps

`include "execute.v"
`include "memory_op.v"
`include "register_wb.v"
`include "pipeline_interface.v"
`include "insn_decoder_new.v"
`include "regs.v"
`include "passthrough.v"

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

// BEWARE:
// general rule for continuous assignment statements
// you can use continuous assignment in instantiation (e.g. wire a = b;) only if a - input and b - output
// if we got reverse situation, we must provide good continuous assignment below ( assign b = a )
// "continuous assignment is not bidirectional; it have dataflow directed from rvalue to lvalue"

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

    wire [31:0] reg_a, reg_b, reg_c, reg_d; //input
    wire [4:0] reg_a_a, reg_a_b, reg_a_c, reg_a_d; //input
    wire [1:0] reg_read, reg_write; //input

    wire [31:0] reg_lr, reg_sp, reg_pc; //output
    wire [31:0] reg_stin, reg_stout; //input, output
    wire reg_stwr; //input
    wire reg_pcincr; //input
    reg32_2x2_pc rf0(reg_a, reg_b, reg_a_a, reg_a_b, reg_a_c, reg_a_d,  reg_c,  reg_d, reg_read, reg_write, clk, rst,  reg_lr,  reg_sp, reg_stout, reg_pc, reg_stin, reg_stwr, reg_pcincr);


    wire [31:0] e_a, e_b; //output
    wire [7:0] e_alu_op; //output
    wire [3:0] e_cond; //output
    wire [3:0] e_write_flags; //output
    wire e_swp; //output
    wire e_is_cond; //output

    wire [31:0] m_a1, m_a2; //output
    wire [3:0] m_r1_op, m_r2_op; //output

    wire [4:0] r_a1, r_a2; //output
    wire [3:0] r_op; //output

    //wire d_pass; //output
    wire d_pcincr; //output
    assign reg_pcincr = d_pcincr;

    wire [4:0] r_r1_a, r_r2_a; //output
    assign reg_a_a = r_r1_a, reg_a_b = r_r2_a;
    wire [1:0] r_read; //output
    assign reg_read = r_read;

    wire [31:0] d_word = word; //input
    wire [31:0] d_r1 = reg_a, d_r2 = reg_b; //input
    wire d_hazard_ex, d_hazard_mem, d_hazard_reg; //input
    insn_decoder dec0(e_a, e_b, e_alu_op, e_is_cond, e_cond, e_write_flags, e_swp, m_a1, m_a2, m_r1_op, m_r2_op, r_a1, r_a2, r_op, d_pcincr, r_r1_a, r_r2_a, r_read, d_word, d_r1, d_r2, d_hazard_ex, d_hazard_mem, d_hazard_reg, rst, clk);


    /*wire [31:0] pi_e_a, pi_e_b; //output
    wire [7:0] pi_e_alu_op; //output
    wire [3:0] pi_e_cond; //output
    wire [3:0] pi_e_write_flags; //output
    wire pi_e_swp; //output
    wire pi_e_is_cond; //output

    wire [31:0] pi_m_a1, pi_m_a2; //output
    wire [3:0] pi_m_r1_op, pi_m_r2_op; //output

    wire [4:0] pi_r_a1, pi_r_a2; //output
    wire [3:0] pi_r_op; //output

    wire pi_d_pcincr; //output
    assign reg_pcincr = pi_d_pcincr;

    pipeline_interface pi0(
    pi_e_a, pi_e_b, pi_e_alu_op, pi_e_is_cond, pi_e_cond, pi_e_write_flags, pi_e_swp, pi_m_a1, pi_m_a2, pi_m_r1_op, pi_m_r2_op, pi_r_a1, pi_r_a2, pi_r_op, pi_d_pcincr,
    e_a, e_b, e_alu_op, e_is_cond, e_cond, e_write_flags, e_swp, m_a1, m_a2, m_r1_op, m_r2_op, r_a1, r_a2, r_op, d_pass, d_pcincr, clk, rst);*/


    wire [31:0] ex_a = e_a, ex_b = e_b; //operands  //input
    wire [31:0] ex_st = reg_stout; //status register  //input
    wire [7:0] ex_alu_op = e_alu_op; // alu operation  //input
    wire ex_is_cond = e_is_cond; //is a conditional command signal  //input
    wire [3:0] ex_cond = e_cond; //cc  //input
    wire [3:0] ex_write_flags = e_write_flags; //write n/z/c/v  //input
    wire ex_swp = e_swp; //swap ops?  //input

    wire [31:0] ex_r1, ex_r2; //results, sync  //output
    wire ex_n, ex_z, ex_c, ex_v; //flags, async  //output
    wire ex_cc; //write flags, async  //output
    wire ex_cres; //conditional results, sync  //output
    execute ex0(ex_r1, ex_r2, ex_cres, ex_n, ex_z, ex_c, ex_v, ex_cc, ex_a, ex_b, ex_alu_op, ex_is_cond, ex_cond, ex_write_flags, ex_st, ex_swp, clk, rst);


    wire sr_n = ex_n, sr_z = ex_z, sr_c = ex_c, sr_v = ex_v; //input
    wire sr_cc = ex_cc; //input

    wire [31:0] sr_st;  //output
    assign reg_stin = sr_st;
    wire sr_stwr; //output
    assign reg_stwr = sr_stwr;
    status_register_adaptor sr0(sr_st, sr_stwr, sr_n, sr_z, sr_c, sr_v, sr_cc);


    /*wire [31:0] ex_m_a1, ex_m_a2; //(mem_op) //output
    wire [3:0] ex_m_r1_op, ex_m_r2_op; //(mem_op) //output

    wire [4:0] ex_r_a1, ex_r_a2; //(reg_wb) //output
    wire [3:0] ex_r_op; //(reg_wb) //output
    execute_stage_passthrough exh0(ex_m_a1, ex_m_a2, ex_m_r1_op, ex_m_r2_op, ex_r_a1, ex_r_a2, ex_r_op, m_a1, m_a2, m_r1_op, m_r2_op, r_a1, r_a2, r_op, clk, rst);
	*/
    
    wire [31:0] pass_m_a1, pass_m_a2; //(mem_op) //output
    wire [3:0] pass_m_r1_op, pass_m_r2_op; //(mem_op) //output
    
    wire [4:0] pass_d1_r_a1, pass_d1_r_a2;
    wire [3:0] pass_d1_r_op;
    
    wire [4:0] pass_r_a1, pass_r_a2; //(reg_wb) //output
    wire [3:0] pass_r_op; //(reg_wb) //output
    wire pass_r_proceed; //(reg_wb) //output
    
    combined_ex_mem_passthrough pass0(pass_m_a1, pass_m_a2, pass_m_r1_op, pass_m_r2_op, pass_r_a1, pass_r_a2, pass_r_op, pass_r_proceed, pass_d1_r_a1, pass_d1_r_a2, pass_d1_r_op, m_a1, m_a2, m_r1_op, m_r2_op, r_a1, r_a2, r_op, ex_cres, clk, rst);
    

    wire [31:0] mop_r1 = ex_r1, mop_r2 = ex_r2; //inputs  //input
    wire [31:0] mop_a1 = pass_m_a1, mop_a2 = pass_m_a2; //memory addresses  //input

    wire [3:0] mop_r1_op = pass_m_r1_op, mop_r2_op = pass_m_r2_op; //operation codes  //input

    wire [31:0] mop_ram_r_line = ram_r_line, mop_sys_r_line = sys_r_line; // read lanes  //input

    wire mop_proceed = ex_cres; //conditional code test result  //input

    wire [31:0] mop_m1, mop_m2; //outputs  //output

    wire [31:0] mop_ram_w_addr, mop_sys_w_addr; //write addresses  //output
    assign ram_w_addr = mop_ram_w_addr, sys_w_addr = mop_sys_w_addr;
    wire [31:0] mop_ram_r_addr, mop_sys_r_addr; //read addresses  //output
    assign ram_r_addr = mop_ram_r_addr, sys_r_addr = mop_sys_r_addr;

    wire [31:0] mop_ram_w_line, mop_sys_w_line; //write lanes  //output
    assign ram_w_line = mop_ram_w_line, sys_w_line = mop_sys_w_line;

    wire mop_ram_w, mop_sys_w, mop_ram_r, mop_sys_r; //read/write signals  //output
    assign ram_write = mop_ram_w, sys_write = mop_sys_w, ram_read = mop_ram_r, sys_read = mop_sys_r;
    memory_op mop0( mop_m1, mop_m2, mop_ram_w_addr, mop_ram_r_addr, mop_ram_w, mop_ram_r, mop_ram_w_line, mop_sys_w_addr, mop_sys_r_addr, mop_sys_w, mop_sys_r, mop_sys_w_line, mop_r1, mop_r2, mop_a1, mop_a2, mop_r1_op, mop_r2_op, mop_ram_r_line, mop_sys_r_line, mop_proceed, clk, rst);

    /*wire [4:0] mop_r_a1, mop_r_a2; //(reg_wb)  //output
    wire [3:0] mop_r_op; //(reg_wb)  //output
    wire mop_proceed2;  //output
    memory_op_stage_passthrough moph0(mop_r_a1, mop_r_a2, mop_r_op, mop_proceed2, ex_r_a1, ex_r_a2, ex_r_op, ex_cres, clk, rst);
	*/

    wire [31:0] rwb_r1 = mop_m1, rwb_r2 = mop_m2;  //input
    wire [4:0] rwb_a1 = pass_r_a1, rwb_a2 = pass_r_a2;  //input

    wire [3:0] rwb_op = pass_r_op;  //input

    wire rwb_proceed = pass_r_proceed;  //input

    wire [31:0] rwb_wr1, rwb_wr2;  //output
    assign reg_c = rwb_wr1, reg_d = rwb_wr2;
    wire [4:0] rwb_wa1, rwb_wa2;  //output
    assign reg_a_c = rwb_wa1, reg_a_d = rwb_wa2;
    wire [1:0] rwb_write;  //output
    assign reg_write = rwb_write;
    register_wb rwb0( rwb_write, rwb_wr1, rwb_wr2, rwb_wa1, rwb_wa2, rwb_r1, rwb_r2, rwb_a1, rwb_a2, rwb_op, rwb_proceed, clk, rst);

    wire ex_hazard;
    wire reg_hazard;
    wire mem_hazard;
    reg_hazard_checker hz0(ex_hazard, mem_hazard, reg_hazard, pass_d1_r_a1, pass_d1_r_a2, pass_d1_r_op, ex_cres, pass_r_a1, pass_r_a2, pass_r_op, pass_r_proceed, rwb_wa1, rwb_wa2, rwb_write, r_r1_a, r_r2_a, r_read);
/*`ifdef RWB_STAGE_HAZARD
    assign d_hazard = ex_hazard || reg_hazard || mem_hazard;
`else
    assign d_hazard = ex_hazard || mem_hazard;
`endif*/
    assign d_hazard_ex = ex_hazard;
    assign d_hazard_mem = mem_hazard;
    assign d_hazard_reg = reg_hazard;

    assign lr = reg_lr;
    assign pc = reg_pc;
    assign st = reg_stout;
    assign sp = reg_sp;

endmodule
