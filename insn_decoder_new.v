`timescale 1 ns / 1 ps

//hazard checker
module reg_hazard_checker(ex_hazard, mem_hazard, reg_hazard, ex_r1_a, ex_r2_a, ex_r_op, ex_proceed, mem_r1_a, mem_r2_a, mem_r_op, mem_proceed, reg_r1_a, reg_r2_a, reg_write, dec_r1_addr, dec_r2_addr, dec_r_read);
	output wire ex_hazard;
	output wire mem_hazard;
	output wire reg_hazard;

	input [4:0] ex_r1_a, ex_r2_a;
	input [3:0] ex_r_op;
	input ex_proceed;

	input [4:0] mem_r1_a, mem_r2_a;
	input [3:0] mem_r_op;
	input mem_proceed;

	input [4:0] reg_r1_a, reg_r2_a;
	input [1:0] reg_write;

	input [4:0] dec_r1_addr, dec_r2_addr;
	input [1:0] dec_r_read;

	wire dec_r1_read_comp = dec_r_read[0];
	wire dec_r2_read_comp = dec_r_read[1];

	wire ex_r1_op_comp = (ex_r_op == 1) || (ex_r_op == 2) || (ex_r_op == 3);
	wire ex_r2_op_comp = (ex_r_op == 4) || (ex_r_op == 5) || (ex_r_op == 6);
	wire ex_r1r2_op_comp = (ex_r_op == 7) || (ex_r_op == 8);

	wire ex_r1_comp = (ex_r1_a == dec_r1_addr);
	wire ex_r2_comp = (ex_r2_a == dec_r2_addr);
	wire ex_r1r2_comp = (ex_r1_a == dec_r2_addr);
	wire ex_r2r1_comp = (ex_r2_a == dec_r1_addr);

	wire ex_hazard_r1 = ((ex_r1_op_comp || ex_r1r2_op_comp) && ex_r1_comp && dec_r1_read_comp);
	wire ex_hazard_r2 = ((ex_r2_op_comp || ex_r1r2_op_comp) && ex_r2_comp && dec_r2_read_comp);
	wire ex_hazard_r1r2 = ((ex_r1_op_comp || ex_r1r2_op_comp) && ex_r1r2_comp && dec_r2_read_comp);
	wire ex_hazard_r2r1 = ((ex_r2_op_comp || ex_r1r2_op_comp) && ex_r2r1_comp && dec_r1_read_comp);

	assign ex_hazard =  (ex_hazard_r1 || ex_hazard_r2 || ex_hazard_r1r2 || ex_hazard_r2r1) && ex_proceed;

	wire mem_r1_op_comp = (mem_r_op == 1) || (mem_r_op == 2) || (mem_r_op == 3);
	wire mem_r2_op_comp = (mem_r_op == 4) || (mem_r_op == 5) || (mem_r_op == 6);
	wire mem_r1r2_op_comp = (mem_r_op == 7) || (mem_r_op == 8);

	wire mem_r1_comp = (mem_r1_a == dec_r1_addr);
	wire mem_r2_comp = (mem_r2_a == dec_r2_addr);
	wire mem_r1r2_comp = (mem_r1_a == dec_r2_addr);
	wire mem_r2r1_comp = (mem_r2_a == dec_r1_addr);

	wire mem_hazard_r1 = ((mem_r1_op_comp || mem_r1r2_op_comp) && mem_r1_comp && dec_r1_read_comp);
	wire mem_hazard_r2 = ((mem_r2_op_comp || mem_r1r2_op_comp) && mem_r2_comp && dec_r2_read_comp);
	wire mem_hazard_r1r2 = ((mem_r1_op_comp || mem_r1r2_op_comp) && mem_r1r2_comp && dec_r2_read_comp);
	wire mem_hazard_r2r1 = ((mem_r2_op_comp || mem_r1r2_op_comp) && mem_r2r1_comp && dec_r1_read_comp);

	assign mem_hazard =  (mem_hazard_r1 || mem_hazard_r2 || mem_hazard_r1r2 || mem_hazard_r2r1) && mem_proceed;

	wire reg_r1_write_comp = reg_write[0];
	wire reg_r2_write_comp = reg_write[1];

	wire reg_r1_comp = (reg_r1_a == dec_r1_addr);
	wire reg_r2_comp = (reg_r2_a == dec_r2_addr);
	wire reg_r1r2_comp = (reg_r1_a == dec_r2_addr);
	wire reg_r2r1_comp = (reg_r2_a == dec_r1_addr);

	wire reg_hazard_r1 = (reg_r1_write_comp && reg_r1_comp && dec_r1_read_comp);
	wire reg_hazard_r2 = (reg_r2_write_comp && reg_r2_comp && dec_r2_read_comp);
	wire reg_hazard_r1r2 = (reg_r1_write_comp && reg_r1r2_comp && dec_r2_read_comp);
	wire reg_hazard_r2r1 = (reg_r2_write_comp && reg_r2r1_comp && dec_r1_read_comp);

	assign reg_hazard =  reg_hazard_r1 || reg_hazard_r2 || reg_hazard_r1r2 || reg_hazard_r2r1;

endmodule

//module insn_decoder( e_a, e_b, e_alu_op, e_is_cond, e_cond, e_write_flags, e_swp, m_a1, m_a2, m_r1_op, m_r2_op, r_a1, r_a2, r_op, d_pass, d_pcincr, r_r1_addr, r_r2_addr, r_read, word, r1, r2, hazard, rst, clk);
module insn_decoder( e_a, e_b, e_alu_op, e_is_cond, e_cond, e_write_flags, e_swp, m_a1, m_a2, m_r1_op, m_r2_op, r_a1, r_a2, r_op, d_pcincr, r_r1_addr, r_r2_addr, r_read, word, r1, r2, hazard_ex, hazard_mem, hazard_reg, rst, clk);
	output wire [31:0] e_a, e_b; //arguments
	output wire [7:0] e_alu_op; //ALU operation
	output wire [3:0] e_cond; //Conditional code
	output wire [3:0] e_write_flags; //Flags writeback
	output wire e_swp; //Swap operands
	output wire e_is_cond; //Conditional flag

	output wire [31:0] m_a1, m_a2; //Memory addresses
	output wire [3:0] m_r1_op, m_r2_op; //Memory operations

	output wire [4:0] r_a1, r_a2; //Register file writeback addresses
	output wire [3:0] r_op; //Register file writeback operation

	output reg d_pcincr; //Increment PC flag

	output reg [4:0] r_r1_addr, r_r2_addr; //Register file read (here) addresses
	output reg [1:0] r_read; //Register file read (here) r1/r2

	input [31:0] word; //Input from progmem (insn/imm)
	input [31:0] r1, r2; //Inputs from register file (r1/r2)
	input hazard_ex, hazard_mem, hazard_reg; //hazards
	input rst, clk; //Internal
	
	//insn comprehension
	wire [6:0] in_opcode = word[31:25];
	wire [3:0] in_cond = word[24:21];
	wire [4:0] in_reg_a_addr = word[20:16];
	wire [4:0] in_reg_b_addr = word[15:11];
	wire [4:0] in_reg_c_addr = word[10:6];
	wire [4:0] in_reg_d_addr = word[5:1];
	wire [1:0] in_imm_action = word[5:4];
	
	//pass comprehension
	reg pass; //flag
	wire [31:0] sh_e_a, sh_e_b;
	reg [7:0] reg_e_alu_op;
	reg [3:0] reg_e_cond;
	reg [3:0] reg_e_write_flags;
	reg reg_e_swp;
	reg reg_e_is_cond;

	wire [31:0] sh_m_a1, sh_m_a2;
	reg [3:0] reg_m_r1_op, reg_m_r2_op;

	reg [4:0] reg_r_a1, reg_r_a2;
	reg [3:0] reg_r_op;

	//reg [4:0] reg_r_r1_addr, reg_r_r2_addr;
	//reg [1:0] reg_r_read;
	
	//pass multiplexors - substitute to clear NOP
	assign e_a = pass ? sh_e_a : 32'b0;
	assign e_b = pass ? sh_e_b : 32'b0;
	assign e_alu_op = pass ? reg_e_alu_op : 8'b0;
	assign e_cond = pass ? reg_e_cond : 4'b0;
	assign e_write_flags = pass ? reg_e_write_flags : 4'b0;
	assign e_swp = pass ? reg_e_swp : 1'b0;
	assign e_is_cond = pass ? reg_e_is_cond : 1'b0;
	assign m_a1 = pass ? sh_m_a1 : 32'b0;
	assign m_a2 = pass ? sh_m_a2 : 32'b0;
	assign m_r1_op = pass ? reg_m_r1_op : 4'b0;
	assign m_r2_op = pass ? reg_m_r2_op : 4'b0;
	assign r_a1 = pass ? reg_r_a1 : 5'b0;
	assign r_a2 = pass ? reg_r_a2 : 5'b0;
	assign r_op = pass ? reg_r_op : 4'b0;
	//assign r_read = pass ? reg_r_read : 2'b0;
	
	//register file to arguments
	reg is_a_from_file, is_b_from_file; //flags
	reg [31:0] reg_a, reg_b;
	assign sh_e_a = is_a_from_file ? r1 : reg_a;
	assign sh_e_b = is_b_from_file ? r2: reg_b;
	
	//register file to memory addr
	reg is_m1_from_file, is_m2_from_file; //flags
	reg [31:0] reg_m_a1, reg_m_a2;
	assign sh_m_a1 = is_m1_from_file ? r1 : reg_m_a1;
	assign sh_m_a2 = is_m2_from_file ? r2 : reg_m_a2;
	
	reg imm1_op_action, imm1_op_dest;
	reg imm2_op_action, imm2_op_dest;
	reg imm1_op_mask, imm2_op_mask;
	wire imm1_op_action_masked = imm1_op_action & (~imm1_op_mask);
	wire imm2_op_action_masked = imm2_op_action & (~imm2_op_mask);
	wire is_imm_fetch = imm1_op_action_masked | imm2_op_action_masked;
	
	reg is_delay;
	reg is_delay_in_progress;
	reg [3:0] delay_ctr;
	
	wire is_hazard = hazard_ex | hazard_mem | hazard_reg;
	
	reg is_hazard_delay;
	
	reg reg_d_pcincr;
	//assign d_pcincr = is_imm_fetch ? 1'b1 : reg_d_pcincr;
	always @* begin
		if(is_imm_fetch) begin
			d_pcincr = 1'b1;
		end else if(is_delay_in_progress) begin
			d_pcincr = 1'b0;
		end else if(is_hazard | is_hazard_delay) begin
			d_pcincr = 1'b0;
		end else begin
			d_pcincr = reg_d_pcincr;
		end
	end
	
	reg reg_pass;
	//assign pass = (is_imm_fetch | is_delay | is_hazard | is_hazard_delay) ? 1'b0 : reg_pass;
	always @* begin
		if(is_imm_fetch) begin
			pass = 1'b0;
		end else if(is_delay_in_progress) begin
			pass = 1'b0;
		end else if(is_hazard | is_hazard_delay) begin
			pass = 1'b0;
		end else begin
			pass = reg_pass;
		end
	end
	
	//reg [2:0] cur_imm_op;
	//reg [3:0] cur_imm_state;
	reg [7:0] decode_state;
	
	always @(posedge rst or posedge clk) begin
		if(rst) begin
			r_r1_addr = 5'b0; r_r2_addr = 5'b0;
			r_read = 2'b0;
			
			//pass = 1'b1;
			reg_e_alu_op = 8'b0; reg_e_cond = 4'b0;
			reg_e_write_flags = 4'b0; reg_e_swp = 1'b0; reg_e_is_cond = 1'b0;
			reg_m_r1_op = 4'b0; reg_m_r2_op = 4'b0;
			reg_r_a1 = 5'b0; reg_r_a2 = 5'b0; reg_r_op = 4'b0;
			
			is_a_from_file = 1'b0; is_b_from_file = 1'b0;
			reg_a = 32'b0; reg_b = 32'b0;
			
			is_m1_from_file = 1'b0; is_m2_from_file = 1'b0;
			reg_m_a1 = 32'b0; reg_m_a2 = 32'b0;
			
			//is_imm_fetch = 1'b0;
			reg_d_pcincr = 1'b1; // ???
			
			is_delay = 1'b0;
			is_delay_in_progress = 1'b0;
			delay_ctr = 0;
			
			is_hazard_delay = 1'b0;
			
			reg_pass = 1'b1; // ???
			
			imm1_op_action = 1'b0; imm1_op_dest = 1'b0;
			imm2_op_action = 1'b0; imm2_op_dest = 1'b0;
			imm1_op_mask = 1'b0; imm2_op_mask = 1'b0;
			
			decode_state = 0;
		end
		else begin
			if(is_imm_fetch) begin //immediate value fetch procedure
				//cur_imm_op: 000 - nop, 001 - imm1 -> b, 010 - imm1 -> a, 011 {imm1, imm2} -> {a,b}, 100 - nop? 101..111 - as 001..011 but a ~ m_a2, b ~ m_a1
				/*case(cur_imm_op) // synopsys full_case parallel_case
					3'b000: begin //nop, drop fetch
						is_imm_fetch = 0;
					end
					3'b001: begin //load 1 imm to b
						reg_b = word;
						is_b_from_file = 0;
						is_imm_fetch = 0;
						cur_imm_op = 3'b000;
					end
					3'b010: begin //load 1 imm to a
						reg_a = word;
						is_a_from_file = 0;
						is_imm_fetch = 0;
						cur_imm_op = 3'b000;
					end
					3'b011: begin //load 2 imms to a, b, state -> a
						reg_a = word;
						is_a_from_file = 0;
						cur_imm_op = 3'b001;
					end
					3'b100: begin //nop, drop fetch
						is_imm_fetch = 0;
					end
					3'b101: begin //load 1 imm to m_a1
						reg_m_a1 = word;
						is_a1_from_file = 0;
						is_imm_fetch = 0;
						cur_imm_op = 3'b000;
					end
					3'b110: begin //load 1 imm to m_a2
						reg_m_a2 = word;
						is_a2_from_file = 0;
						is_imm_fetch = 0;
						cur_imm_op = 3'b000;
					end
					3'b111: begin //load two imms to m2, m1, state -> m2
						reg_m_a2 = word;
						is_a2_from_file = 0;
						cur_imm_op = 3'b101;
					end
				endcase*/
				// latches immediate
				if(imm1_op_action_masked) begin // fetch first immediate
					if(imm1_op_dest) begin //fetch to mem a1
						reg_m_a1 = word;
						is_m1_from_file = 1'b0;
					end else begin //fetch to reg a
						reg_a = word;
						is_a_from_file = 1'b0;
					end
					imm1_op_action = 1'b0;
				end else if(imm2_op_action_masked) begin //fetch second immediate
					if(imm2_op_dest) begin //fetch to mem a2
						reg_m_a2 = word;
						is_m2_from_file = 1'b0;
					end else begin //fetch to reg b
						reg_b = word;
						is_b_from_file = 1'b0;
					end
					imm2_op_action = 1'b0;
				end else begin //how does we got into this state ?
					// raise hardware fault
				end	
			end else if(is_delay) begin
				if(delay_ctr == 0) begin
					is_delay = 0;
					is_delay_in_progress = 0;
				end else begin
					is_delay_in_progress = 1;
					delay_ctr = delay_ctr - 1;
				end
			end else if(is_hazard) begin
				is_hazard_delay = 1'b0;
			end else if(is_hazard_delay) begin
				is_hazard_delay = 1'b0;
			end else begin // decode
				//latch opcode and imm_action
				decode_state = {1'b0,  in_opcode};
				imm1_op_action = in_imm_action[1];
				imm2_op_action = in_imm_action[0];
				// imm_op = {1'b0, in_imm_action};
				//Decode insn
				//latches cond, a, b, c, d
				//OLD DECODE CASE GOES HERE
				case(decode_state) // synopsys full_case parallel_case
					//logic
					0: begin //nop
						reg_e_alu_op = 0; reg_e_cond = 0; reg_e_write_flags = 0; reg_e_is_cond = 0; //alu nop, not conditional, no flags
						reg_m_r1_op = 4'b0; reg_m_r2_op = 4'b0; //memory clean nop
						reg_r_op = 0; //register write nop
						r_read = 0; //register read none
						// is_xxx_from_file ?
						is_a_from_file = 0; is_b_from_file = 0; is_m1_from_file = 0; is_m2_from_file = 0; //args from internal
						//imm control
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b1; imm2_op_mask = 1'b1; // no imm in this insn
					end
					1: begin //or
						reg_e_alu_op = 8'h0D; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu or, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //a,b from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					2: begin //nor
						reg_e_alu_op = 8'h10; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu nor, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					3: begin //and
						reg_e_alu_op = 8'h0C; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu and, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					4: begin //nand
						reg_e_alu_op = 8'h0F; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu or, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					5: begin //inv
						reg_e_alu_op = 8'h0B; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu not, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_read = 1; //register read first
						is_a_from_file = 1; is_b_from_file = 0; is_m1_from_file = 0; is_m2_from_file = 0; //arg 1 from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b1; // only first imm in this insn
					end
					6: begin //xor
						reg_e_alu_op = 8'h0E; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu xor, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					7: begin //xnor
						reg_e_alu_op = 8'h11; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu xnor, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					//shifts
					8: begin //lsl
						reg_e_alu_op = 8'h06; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu shl, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					9: begin //lsr
						reg_e_alu_op = 8'h05; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu shr, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					10: begin //asr
						reg_e_alu_op = 8'h07; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu sar, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					11: begin //asl
						reg_e_alu_op = 8'h08; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu sal, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					12: begin //csr
						reg_e_alu_op = 8'h09; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu ror, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					13: begin //csl
						reg_e_alu_op = 8'h0A; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu rol, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					//arithmetics
					14: begin //add
						reg_e_alu_op = 8'h01; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu add, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					15: begin //sub
						reg_e_alu_op = 8'h02; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu sub, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					16: begin //mull
						reg_e_alu_op = 8'h04; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu mul, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					17: begin //mulh
						reg_e_alu_op = 8'h04; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu mul, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 4; reg_r_a1 = in_reg_c_addr; // register write d to a1
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					18: begin //mul
						reg_e_alu_op = 8'h04; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu mul, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 7; reg_r_a1 = in_reg_c_addr; reg_r_a2 = in_reg_d_addr; // register write c,d to a1,a2
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b1; imm2_op_mask = 1'b1; // no imm in this insn
					end
					19: begin //csg
						reg_e_alu_op = 8'h03; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu cpl, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_read = 1; //register read first
						is_a_from_file = 1; is_b_from_file = 0; is_m1_from_file = 0; is_m2_from_file = 0; //arg 1 from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b1; // only first imm in this insn
					end
					20: begin //inc
						reg_e_alu_op = 8'h01; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu add, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_read = 1; //register read first
						is_a_from_file = 1; is_b_from_file = 0; is_m1_from_file = 0; is_m2_from_file = 0; //arg 1 from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b1; // only first imm in this insn
						reg_b = 32'b1; //force b = 1
					end
					21: begin //dec
						reg_e_alu_op = 8'h02; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu sub, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_read = 1; //register read first
						is_a_from_file = 1; is_b_from_file = 0; is_m1_from_file = 0; is_m2_from_file = 0; //arg 1 from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b1; // only first imm in this insn
						reg_b = 32'b1; //force b = 1
					end
					22: begin //cmp
						reg_e_alu_op = 8'h02; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu sub, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 0; // register write nop
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					23: begin //cmn
						reg_e_alu_op = 8'h01; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu add, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 0; // register write nop
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					24: begin //tst
						reg_e_alu_op = 8'h0C; reg_e_cond = in_cond; reg_e_write_flags = 4'hF; reg_e_is_cond = 1; //alu and, conditional, all flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 0; // register write nop
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //args from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					//branches
					25: begin //br
						/*e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, no flags
						m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
						r_op <= 1; r_a1 <= 31; // register write to pc
						r_r1_addr <= reg_a_addr; r_read <= 1; //register read first
						r_to_mem <= 0;//register read to a,b
						imm_action[0] <= 0; //no imm for b in this insn
						//delay!
						//set_delay <= 1;
						fetch <= 0; d_pcincr <= 0;
						state1 <= 130;
						delay_counter <= 3;*/
						reg_e_alu_op = 8'h00; reg_e_cond = in_cond; reg_e_write_flags = 4'h0; reg_e_is_cond = 1; //alu nop, conditional, no flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = 31; // register write c to a(pc)
						r_r1_addr = in_reg_a_addr; r_read = 1; //register read first
						is_a_from_file = 1; is_b_from_file = 0; is_m1_from_file = 0; is_m2_from_file = 0; //a from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b1; // only first imm in this insn
						//arm delay
						is_delay = 1'b1;
						delay_ctr = 3; 
					end
					26: begin //rbr
						/*e_alu_op <= 8'h01; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu add, conditional, no flags
						m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
						r_op <= 1; r_a1 <= 31; // register write to pc
						r_r2_addr <= reg_a_addr; r_r1_addr <= 31; r_read <= 3; //register read both, first - pc
						r_to_mem <= 0;//register read to a,b
						imm_action[0] <= 0; //no imm for b in this insn
						//delay!
						//set_delay <= 1;
						fetch <= 0; d_pcincr <= 0;
						state1 <= 130;
						delay_counter <= 3;*/
						reg_e_alu_op = 8'h01; reg_e_cond = in_cond; reg_e_write_flags = 4'h0; reg_e_is_cond = 1; //alu add, conditional, no flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = 31; // register write c to a(pc)
						r_r1_addr = 31; r_r2_addr = in_reg_a_addr; r_read = 3; //register read both, first - a(pc), second - a
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //both from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b1; imm2_op_mask = 1'b0; // only second imm in this insn
						//arm delay
						is_delay = 1'b1;
						delay_ctr = 3; 
					end
					27: begin //brl
						/*e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, no flags
						m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
						r_op <= 7; r_a1 <= 31; r_a2 <= 29; // register write a,b to pc,lr
						r_r1_addr <= reg_a_addr; r_r2_addr <= 31; r_read <= 3; //register read both, second - pc
						r_to_mem <= 0;//register read to a,b
						imm_action[0] <= 0; //no imm for b in this insn
						//delay!
						//set_delay <= 1;
						fetch <= 0; d_pcincr <= 0;
						state1 <= 130;
						delay_counter <= 3;*/
						reg_e_alu_op = 8'h00; reg_e_cond = in_cond; reg_e_write_flags = 4'h0; reg_e_is_cond = 1; //alu nop, conditional, no flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 7; reg_r_a1 = 31; reg_r_a2 = 29; // register write c, d to a(pc), a(lr)
						r_r1_addr = in_reg_a_addr; r_r2_addr = 31; r_read = 3; //register read both, second - pc
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //both from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b1; // only first imm in this insn
						//arm delay
						is_delay = 1'b1;
						delay_ctr = 3; 
					end
					/*27: begin //rbl, can't implement now (need hook in register_wb)
                    e_alu_op <= 8'h01; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu add, conditional, no flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= 31 // register write to pc
                    r_r2_addr <= reg_a_addr; r_r1_addr <= 31; r_read <= 2; //register read both, first - pc
                    imm_action[0] <= 0; //no imm for b in this insn
                    //delay!
                end*/
					28: begin //ret
						/*e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, no flags
						m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
						r_op <= 1; r_a1 <= 31; // register write to pc
						r_r1_addr <= 29; r_read <= 1; //register read first - lr
						r_to_mem <= 0;//register read to a,b
						imm_action <= 3'b000; //no imm in this insn
						//delay!
						//set_delay <= 1;
						fetch <= 0; d_pcincr <= 0;
						state1 <= 130;
						delay_counter <= 3;*/
						reg_e_alu_op = 8'h00; reg_e_cond = in_cond; reg_e_write_flags = 4'h0; reg_e_is_cond = 1; //alu nop, conditional, no flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = 31; // register write c to a(pc)
						r_r1_addr = 29; r_read = 1; //register read first from a(lr)
						is_a_from_file = 1; is_b_from_file = 0; is_m1_from_file = 0; is_m2_from_file = 0; //a from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b1; imm2_op_mask = 1'b1; // no imm in this insn
						//arm delay
						is_delay = 1'b1;
						delay_ctr = 3; 
					end
					29: begin //ldr
						/*e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, no flags
						m_r1_op <= 2; m_r2_op <= 1; //memory read c from a1
						r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
						r_r1_addr <= reg_a_addr; r_read <= 1; //register read first
						r_to_mem <= 2'b01;//register read to m1, b
						imm_action[0] <= 0; //no imm for b in this insn
						imm_action[2] <= 1; //imm goes into m*/
						reg_e_alu_op = 8'h00; reg_e_cond = in_cond; reg_e_write_flags = 4'h0; reg_e_is_cond = 1; //alu nop, conditional, no flags
						reg_m_r1_op = 4'b10; reg_m_r2_op = 4'b1; //memory read c from a1, d pass
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_read = 1; //register read first
						is_a_from_file = 0; is_b_from_file = 0; is_m1_from_file = 1; is_m2_from_file = 0; //m1 from file
						imm1_op_dest = 1'b1; imm2_op_dest = 1'b0; // imm1 to mem
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b1; // only first imm in this insn
					end
					30: begin //str
						/*e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, no flags
						m_r1_op <= 1; m_r2_op <= 5; //memory write d to a1
						r_op <= 0; // register write nop
						r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
						r_to_mem <= 2'b01;//register read to m1, b
						imm_action[0] <= 0; //no imm for b in this insn
						imm_action[2] <= 1; //imm goes into m*/
						reg_e_alu_op = 8'h00; reg_e_cond = in_cond; reg_e_write_flags = 4'h0; reg_e_is_cond = 1; //alu nop, conditional, no flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b101; //memory write d to a1, c pass
						reg_r_op = 0; // register write nop
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 0; is_b_from_file = 1; is_m1_from_file = 1; is_m2_from_file = 0; //m1 and b from file
						imm1_op_dest = 1'b1; imm2_op_dest = 1'b0; // imm1 to mem, imm2 to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end
					//ldrc
					//strc
					//needs more elaborate management of operands (3, but have only 2, perhaps use imm ?

					//push
					//pop
					//one of this needs advanced management in memory_op stage
					//or make as in x86 - pop only decrements, not returning result

					31: begin //in
						/*e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, no flags
						m_r1_op <= 4'b1000; m_r2_op <= 4'b1; //sys read c from a1
						r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
						r_r1_addr <= reg_a_addr; r_read <= 1; //register read first
						r_to_mem <= 2'b01;//register read to m1, b
						imm_action[0] <= 0; //no imm for b in this insn
						imm_action[2] <= 1; //imm goes into m*/
						reg_e_alu_op = 8'h00; reg_e_cond = in_cond; reg_e_write_flags = 4'h0; reg_e_is_cond = 1; //alu nop, conditional, no flags
						reg_m_r1_op = 4'b1000; reg_m_r2_op = 4'b1; //sys read c from a1, d pass
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_read = 1; //register read first
						is_a_from_file = 0; is_b_from_file = 0; is_m1_from_file = 1; is_m2_from_file = 0; //m1 from file
						imm1_op_dest = 1'b1; imm2_op_dest = 1'b0; // imm1 to mem
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b1; // only first imm in this insn
					end
					32: begin //out
						/*e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, no flags
						m_r1_op <= 4'b1; m_r2_op <= 4'b1011; //sys write d to a1
						r_op <= 0; // register write nop
						r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
						r_to_mem <= 2'b01;//register read to m1, b
						imm_action[0] <= 0; //no imm for b in this insn
						imm_action[2] <= 1; //imm goes into m*/
						reg_e_alu_op = 8'h00; reg_e_cond = in_cond; reg_e_write_flags = 4'h0; reg_e_is_cond = 1; //alu nop, conditional, no flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1011; //sys write d to a1, c pass
						reg_r_op = 0; // register write nop
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 0; is_b_from_file = 1; is_m1_from_file = 1; is_m2_from_file = 0; //m1 and b from file
						imm1_op_dest = 1'b1; imm2_op_dest = 1'b0; // imm1 to mem, imm2 to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b0; // both imm in this insn
					end

					//ini
					//outi
					//needs more elaborate management of operands (3, but have only 2, perhaps use imm ?

					33: begin //movs
						/*e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, no flags
						m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
						r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
						r_r1_addr <= reg_a_addr; r_read <= 1; //register read first
						r_to_mem <= 0;//register read to a,b
						imm_action[0] <= 0; //no imm for b in this insn*/
						reg_e_alu_op = 8'h00; reg_e_cond = in_cond; reg_e_write_flags = 4'h0; reg_e_is_cond = 1; //alu nop, conditional, no flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 1; reg_r_a1 = in_reg_c_addr; // register write c to a1
						r_r1_addr = in_reg_a_addr; r_read = 1; //register read a
						is_a_from_file = 1; is_b_from_file = 0; is_m1_from_file = 0; is_m2_from_file = 0; //a from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b0; imm2_op_mask = 1'b1; // only first in this insn
					end
					34: begin //mov
						/*e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, all flags
						m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
						r_op <= 7; r_a1 <= reg_c_addr; r_a2 <= reg_d_addr; // register write c,d to a1,a2
						r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
						r_to_mem <= 0;//register read to a,b
						imm_action <= 3'b000; //no imm in this insn*/
						reg_e_alu_op = 8'h00; reg_e_cond = in_cond; reg_e_write_flags = 4'h0; reg_e_is_cond = 1; //alu nop, conditional, no flags
						reg_m_r1_op = 4'b1; reg_m_r2_op = 4'b1; //memory passthrough nop
						reg_r_op = 7; reg_r_a1 = in_reg_c_addr; reg_r_a2 = in_reg_d_addr; // register write c, d to a1, a2
						r_r1_addr = in_reg_a_addr; r_r2_addr = in_reg_b_addr; r_read = 3; //register read both
						is_a_from_file = 1; is_b_from_file = 1; is_m1_from_file = 0; is_m2_from_file = 0; //both from file
						imm1_op_dest = 1'b0; imm2_op_dest = 1'b0; // imm to reg
						imm1_op_mask = 1'b1; imm2_op_mask = 1'b1; // no imm in this insn
					end
					/*28: begin //ldr
                    e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, no flags
                    m_r1_op <= 4'b0011; m_r2_op <= 4'b1; //memory read c from a2
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 2'b10;//register read to a,m2
                end*/
					default: begin
						//raise hardware fault
					end
				endcase
				//OLD DECODE CASE ENDS HERE
			end
		end
	end
endmodule