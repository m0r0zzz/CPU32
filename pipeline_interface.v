`timescale 1 ns / 100 ps

module pipeline_interface(
    qe_a, qe_b, qe_alu_op, qe_is_cond, qe_cond, qe_write_flags, qe_swp, qm_a1, qm_a2, qm_r1_op, qm_r2_op, qr_a1, qr_a2, qr_op, qd_pcincr,
    e_a, e_b, e_alu_op, e_is_cond, e_cond, e_write_flags, e_swp, m_a1, m_a2, m_r1_op, m_r2_op, r_a1, r_a2, r_op, d_pass, d_pcincr, clk, rst);
    input [31:0] e_a, e_b;
    input [7:0] e_alu_op;
    input [3:0] e_cond;
    input [3:0] e_write_flags;
    input e_swp;
    input e_is_cond;

    input [31:0] m_a1, m_a2;
    input [3:0] m_r1_op, m_r2_op;

    input [4:0] r_a1, r_a2;
    input [3:0] r_op;

    input d_pass;
    input d_pcincr;

    input clk, rst;

    output reg [31:0] qe_a, qe_b;
    output reg [7:0] qe_alu_op;
    output reg [3:0] qe_cond;
    output reg [3:0] qe_write_flags;
    output reg qe_swp;
    output reg qe_is_cond;

    output reg [31:0] qm_a1, qm_a2;
    output reg [3:0] qm_r1_op, qm_r2_op;

    output reg [4:0] qr_a1, qr_a2;
    output reg [3:0] qr_op;

    output reg qd_pcincr;

    always @(posedge clk or rst) begin
`ifdef INTERFACE_STAGE_NO_DELAY
        #6;
`endif
        if(rst || !d_pass) begin // insert clean NOP
            qe_a <= 31'b0; qe_b <= 31'b0;
            qe_alu_op <= 8'b0; //NOP
            qe_cond <= 4'b0;
            qe_write_flags = 4'b0;
            qe_swp <= 1'b0; qe_is_cond <= 1'b0;

            qm_a1 <= 31'b0; qm_a2 <= 31'b0;
            qm_r1_op <= 4'b0; qm_r2_op <= 4'b0; //clean NOP

            qr_a1 <= 5'b0; qr_a2 <= 5'b0;
            qr_op <= 4'b0; //NOP;
        end
        else begin //pass args & signals down to the pipeline
            qe_a <= e_a; qe_b <= e_b;
            qe_alu_op <= e_alu_op;
            qe_cond <= e_cond;
            qe_write_flags = e_write_flags;
            qe_swp <= e_swp; qe_is_cond <= e_is_cond;

            qm_a1 <= m_a1; qm_a2 <= m_a2;
            qm_r1_op <= m_r1_op; qm_r2_op <= m_r2_op;

            qr_a1 <= r_a1; qr_a2 <= r_a2;
            qr_op <= r_op;
        end
        //handle pcincr signal
        if(rst) qd_pcincr <= 1'b0;
        else qd_pcincr <= d_pcincr;
    end
endmodule

