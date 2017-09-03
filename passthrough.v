`timescale 1 ns / 1 ps

module combined_ex_mem_passthrough(qm_a1, qm_a2, qm_r1_op, qm_r2_op, qr_a1, qr_a2, qr_op, qr_proceed, d1_r_a1, d1_r_a2, d1_r_op, m_a1, m_a2, m_r1_op, m_r2_op, r_a1, r_a2, r_op, r_proceed, clk, rst);
	input [31:0] m_a1, m_a2; //(mem_op)
	input [3:0] m_r1_op, m_r2_op; //(mem_op)

	input [4:0] r_a1, r_a2; //(reg_wb)
	input [3:0] r_op; //(reg_wb)
	input r_proceed; //(reg_wb) from mem
	
	input clk, rst;

	output reg [31:0] qm_a1, qm_a2; //(mem_op) d1
	output reg [3:0] qm_r1_op, qm_r2_op; //(mem_op) d1 

	output reg [4:0] qr_a1, qr_a2; //(reg_wb) d2
	output reg [3:0] qr_op; //(reg_wb) d2
	output reg qr_proceed; //(reg_wb) d1
	
	output reg [4:0] d1_r_a1, d1_r_a2; //(reg_wb), delayed
	output reg [3:0] d1_r_op; //(reg_wb), delayed
	
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			qm_a1 = 32'b0; qm_a2 = 32'b0;
			qm_r1_op = 4'b0; qm_r2_op = 4'b0;
			qr_a1 = 5'b0; qr_a2 = 5'b0;
			qr_op = 4'b0;
			d1_r_a1 = 4'b0; d1_r_a2 = 4'b0;
			d1_r_op = 3'b0;
			qr_proceed = 1'b0;
		end	
		else begin
			//propagate mem ops
			qm_a1 <= m_a1; qm_a2 <= m_a2;
			qm_r1_op <= m_r1_op; qm_r2_op <= m_r2_op;
			//propagate delayed reg ops
			qr_a1 <= d1_r_a1; qr_a2 <= d1_r_a2;
			qr_op <= d1_r_op;
			//propagate original reg ops - create delayed versions
			d1_r_a1 <= r_a1; d1_r_a2 <= r_a2;
			d1_r_op <= r_op;
			//propagate proceed flag
			qr_proceed <= r_proceed;
		end
	end
endmodule


