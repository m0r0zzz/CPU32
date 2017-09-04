`timescale 1 ns / 1 ps

`include "alu.v"

module cond_calc(cr, cc, n, z, c, v);
    input [3:0] cc;
    input n, z, c, v;

    output reg cr;

    always @* begin
       case(cc)
            4'b0000: cr = z == 1'b1; //EQ - equal
            4'b0001: cr = z == 1'b0; //NEQ - not equal
            4'b0010: cr = c == 1'b1; //HS - higher or same (unsigned)
            4'b0011: cr = c == 1'b0; //LO - strictly lower (unsigned)
            4'b0100: cr = n == 1'b1; //NEG - negative
            4'b0101: cr = n == 1'b0; //POS - positive
            4'b0110: cr = v == 1'b1; //SOV - signed overflow
            4'b0111: cr = v == 1'b0; //NSOV - no signed overflow
            4'b1000: cr = (c == 1'b1) && (z == 1'b0); //HI - strictly higher (unsigned)
            4'b1001: cr = (c == 1'b0) || (z == 1'b1); //LS - lower or same (unsigned)
            4'b1010: cr = n == v; //GE - greater or equal (signed)
            4'b1011: cr = n != v; //LT - strictly less (signed)
            4'b1100: cr = (z == 1'b0) && (n == v); //GT - strictly greater (signed)
            4'b1101: cr = (z == 1'b1) || (n != v); //LE - lower or equal (signed)
            4'b1110: cr = 1'b1; //AL - always
            4'b1111: cr = 1'b0; //NV - never
        endcase
    end
endmodule

module status_register_adaptor(st, stwr, n, z, c, v, cc);
    input n, z, c, v;
    input cc;

    output [31:0] st;
    output stwr;

    assign stwr = cc;
    assign st[3:0] = {n, z, c, v};
    assign st[31:4] = 28'b0;
endmodule

module execute_stage_passthrough(qm_a1, qm_a2, qm_r1_op, qm_r2_op, qr_a1, qr_a2, qr_op, m_a1, m_a2, m_r1_op, m_r2_op, r_a1, r_a2, r_op, clk, rst);
    input [31:0] m_a1, m_a2; //(mem_op)
    input [3:0] m_r1_op, m_r2_op; //(mem_op)

    input [4:0] r_a1, r_a2; //(reg_wb)
    input [3:0] r_op; //(reg_wb)

    input clk, rst;

    output reg [31:0] qm_a1, qm_a2; //(mem_op)
    output reg [3:0] qm_r1_op, qm_r2_op; //(mem_op)

    output reg [4:0] qr_a1, qr_a2; //(reg_wb)
    output reg [3:0] qr_op; //(reg_wb)

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            qm_a1 = 32'b0; qm_a2 = 32'b0;
            qm_r1_op = 4'b0; qm_r2_op = 4'b0;
            qr_a1 = 5'b0; qr_a2 = 5'b0;
            qr_op = 4'b0;
        end
        else begin
            qm_a1 <= m_a1; qm_a2 <= m_a2;
            qm_r1_op <= m_r1_op; qm_r2_op <= m_r2_op;
            qr_a1 <= r_a1; qr_a2 <= r_a2;
            qr_op <= r_op;
        end
    end
endmodule



module execute(r1, r2, cres, n, z, c, v, cc, a, b, op, is_cond, cond, write_flags, st, swp, clk, rst);
    input [31:0] a, b; //operands
    input [31:0] st; //status register
    input [7:0] op; // alu operation
    input is_cond; //is a conditional command signal
    input [3:0] cond; //cc
    input [3:0] write_flags; //write n/z/c/v
    input swp; //swap ops?
    input clk, rst;
    
    reg [7:0] in_op;
    reg in_is_cond;
    reg [3:0] in_cond;
    reg [3:0] in_wr_flags;
//    reg [31:0] in_st;
    
    
    output wire [31:0] r1, r2; 
    output wire n, z, c, v; 
    output wire cc; 
    output wire cres; 

    reg [31:0] ra, rb;

    wire [31:0] alu_q1, alu_q2;
    wire alu_n, alu_z, alu_c, alu_v;
    wire [7:0] alu_op;
    alu32_2x2 alu0(alu_q1, alu_q2, {alu_n, alu_z, alu_c, alu_v}, ra, rb, in_op);

    wire cond_n = st[3], cond_z = st[2], cond_c = st[1], cond_v = st[0];
    wire cond_res;
    cond_calc cond0(cond_res, in_cond, cond_n, cond_z, cond_c, cond_v);

    assign cc = (write_flags != 4'b0) && (is_cond && cond_res);
    assign n = in_wr_flags[3] ? alu_n : cond_n;
    assign z = in_wr_flags[2] ? alu_z : cond_z;
    assign c = in_wr_flags[1] ? alu_c : cond_c;
    assign v = in_wr_flags[0] ? alu_v : cond_v;
    assign cres = in_is_cond ? cond_res : 1'b1;
    
    assign r1 = alu_q1;
    assign r2 = alu_q2;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            ra <= 0; rb <= 0;
           	in_op <= 0;
           	in_is_cond = 0;
           	in_cond <= 0;
           	in_wr_flags <= 0;
        end
        else begin
        	if(swp) begin
        		ra <= b;
        		rb <= a;
        	end else begin
        		ra <= a;
        		rb <= b;
        	end
        	in_op <= op;
        	in_is_cond <= is_cond;
        	in_cond <= cond;
        	in_wr_flags <= write_flags;
//        	in_st <= st;
        end
    end
endmodule



