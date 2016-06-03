`timescale 1 ns / 100 ps

//fixed version

/*module insn_type_lookup(type, opcode);
    input [6:0] opcode;
    output [2:0] type;

    always @(a or b) begin
        case(opcode) //full_case parallel_case
            0: type <= 0;
            1: type <= 0;
            //...
        endcase
    end
endmodule*/

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

module insn_decoder( e_a, e_b, e_alu_op, e_is_cond, e_cond, e_write_flags, e_swp, m_a1, m_a2, m_r1_op, m_r2_op, r_a1, r_a2, r_op, d_pass, d_pcincr, r_r1_addr, r_r2_addr, r_read, word, r1, r2, hazard, rst, clk);
    output reg [31:0] e_a, e_b;
    output reg [7:0] e_alu_op;
    output reg [3:0] e_cond;
    output reg [3:0] e_write_flags;
    output reg e_swp;
    output reg e_is_cond;

    output reg [31:0] m_a1, m_a2;
    output reg [3:0] m_r1_op, m_r2_op;

    output reg [4:0] r_a1, r_a2;
    output reg [3:0] r_op;

    output reg d_pass;
    output reg d_pcincr;

    output reg [4:0] r_r1_addr, r_r2_addr;
    output reg [1:0] r_read;

    input [31:0] word;
    input [31:0] r1, r2;
    input hazard;
    input rst, clk;

    reg [7:0] state1;
    reg fetch;
    reg reg_fetch;
    reg [3:0] delay_counter;
    reg [2:0] imm_action; // 000 - nop, 001 - imm1 -> b, 010 - imm1 -> a, 011 {imm1, imm2} -> {a,b}, 100 - nop? 101..111 - as 001..011 but a ~ m_a2, b ~ m_a1
    //reg [1:0] imm_counter;
    reg [7:0] old_state1_imm;
    reg old_pass_imm, old_fetch_imm, old_pcincr_imm;
    reg [1:0] r_to_mem; //00 a,b; 01 m1, b; 10 a, m2; 11 m1, m2
    reg [7:0] old_state1_hz;
    reg old_pass_hz, old_fetch_hz, old_pcincr_hz;
    reg set_delay;

    reg [6:0] opcode;
    reg [3:0] cond;
//    reg [1:0] imm;
    reg [4:0] reg_a_addr, reg_b_addr;
    reg [4:0] reg_c_addr, reg_d_addr;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            e_a <= 31'b0; e_b <= 31'b0;
            e_alu_op <= 8'b0; //NOP
            e_cond <= 4'b0;
            e_write_flags = 4'b0;
            e_swp <= 1'b0; e_is_cond <= 1'b0;

            m_a1 <= 31'b0; m_a2 <= 31'b0;
            m_r1_op <= 4'b0; m_r2_op <= 4'b0; //clean NOP

            r_a1 <= 5'b0; r_a2 <= 5'b0;
            r_op <= 4'b0; //NOP;
            d_pass <= 1'b0; d_pcincr <= 1'b1;
            r_r1_addr <= 5'b0; r_r2_addr <= 5'b0;
            r_read <= 2'b0;
            state1 <= 0; fetch <= 1; reg_fetch <= 0;
            old_pass_imm <= 0; old_fetch_imm <= 0; old_pcincr_imm <= 0; old_state1_imm <= 0;
            old_pass_hz <= 0; old_fetch_hz <= 0; old_pcincr_hz <= 0; old_state1_hz <= 0;
            set_delay <= 0;
            opcode <= 0;
            delay_counter <= 4'b0;
            imm_action <= 3'b0;
            r_to_mem <= 0;
        end
        else begin
            /*case(state1)
                0: begin opcode = word[31:25];
                        cond <= word[24:21];
                        reg_a_addr <= word[20:16]; reg_b_addr <= word[15:11]; reg_c_addr <= word[10:5]; reg_d_addr <= word[4:0];
                        imm <= word[4:3];

                    state1 <= 1;
                    state2 <= opcode;
                end
                1:
            endcase
            //state 1 is for decoding
            //state 2 is for opcode setup
            //state 3 is for additional operations
            case(state2)
                0: begin //nop
                    e_alu_op <= 0; e_cond <= 0; e_write_flags <= 0; e_is_cond <= 0;
                    m_r1_op <= 4'b0; m_r2_op <= 4'b0;
                    r_op <= 0; r_read <= 0; d_pass <= 1 d_pcincr <= 1;
                    state1 <= 0;
                end
                1: begin //or
                    e_alu_op <= 8'h0D; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1;
                    m_r1_op <= 4'b0; m_r2_op <= 4'b0;
                    r_op <= 2; //if respective imm r_read = 0, d_pass = 0, d_pcincr = 1;
            */
            if(fetch) begin
                opcode = word[31:25];
                cond <= word[24:21];
                reg_a_addr <= word[20:16]; reg_b_addr <= word[15:11]; reg_c_addr <= word[10:6]; reg_d_addr <= word[5:1];
                imm_action <= {1'b0, word[5:4]};
                state1 <= opcode;
                #1;
                d_pcincr <= 1;
                d_pass <= 1;
                reg_fetch <= 1;
            end
            //#0;

            case(state1)
                //logic
                0: begin //nop
                    e_alu_op <= 0; e_cond <= 0; e_write_flags <= 0; e_is_cond <= 0; //alu nop, not conditional, no flags
                    m_r1_op <= 4'b0; m_r2_op <= 4'b0; //memory clean nop
                    r_op <= 0; //register write nop
                    r_read <= 0; //register read none
                    r_to_mem <= 0;//register read to a,b
                end
                1: begin //or
                    e_alu_op <= 8'h0D; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu or, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                2: begin //nor
                    e_alu_op <= 8'h10; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu nor, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                3: begin //and
                    e_alu_op <= 8'h0C; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu and, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                4: begin //nand
                    e_alu_op <= 8'h0F; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu nand, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                5: begin //inv
                    e_alu_op <= 8'h0B; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu not, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_read <= 1; //register read first
                    r_to_mem <= 0;//register read to a,b
                    imm_action[0] <= 0; //no imm for b in this insn
                end
                6: begin //xor
                    e_alu_op <= 8'h0E; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu xor, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                6: begin //xnor
                    e_alu_op <= 8'h11; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu xnor, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                //shifts
                7: begin //lsl
                    e_alu_op <= 8'h06; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu shl, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                8: begin //lsr
                    e_alu_op <= 8'h05; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu shr, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                9: begin //asr
                    e_alu_op <= 8'h07; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu sar, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                10: begin //asl
                    e_alu_op <= 8'h08; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu sal, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                11: begin //csr
                    e_alu_op <= 8'h09; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu ror, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                12: begin //csl
                    e_alu_op <= 8'h0A; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu rol, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                //arithmetics
                13: begin //add
                    e_alu_op <= 8'h01; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu add, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                14: begin //sub
                    e_alu_op <= 8'h02; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu sub, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                15: begin //mull
                    e_alu_op <= 8'h04; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu mul, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                16: begin //mulh
                    e_alu_op <= 8'h04; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu mul, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 4; r_a1 <= reg_c_addr; // register write d to a1
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                17: begin //mul
                    e_alu_op <= 8'h04; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu mul, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 7; r_a1 <= reg_c_addr; r_a2 <= reg_d_addr; // register write c,d to a1,a2
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                    imm_action <= 3'b000; //no imm in this insn
                end
                18: begin //csg
                    e_alu_op <= 8'h03; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu cpl, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_read <= 1; //register read first
                    r_to_mem <= 0;//register read to a,b
                    imm_action[0] <= 0; //no imm for b in this insn
                end
                19: begin //inc
                    e_alu_op <= 8'h01; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu add, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_read <= 1; //register read first
                    r_to_mem <= 0;//register read to a,b
                    e_b <= 1; //force b operand to be 1
                    imm_action[0] <= 0; //no imm for b in this insn
                end
                20: begin //dec
                    e_alu_op <= 8'h02; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu sub, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_read <= 1; //register read first
                    r_to_mem <= 0;//register read to a,b
                    e_b <= 1; //force b operand to be 1
                    imm_action[0] <= 0; //no imm for b in this insn
                end
                21: begin //cmp
                    e_alu_op <= 8'h02; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu sub, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 0; // register write nop
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                22: begin //cmn
                    e_alu_op <= 8'h01; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu add, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 0; // register write nop
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                23: begin //tst
                    e_alu_op <= 8'h0C; e_cond <= cond; e_write_flags <= 4'hF; e_is_cond <= 1; //alu and, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 0; // register write nop
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                end
                //branches
                24: begin //br
                    e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, no flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= 31; // register write to pc
                    r_r1_addr <= reg_a_addr; r_read <= 1; //register read first
                    r_to_mem <= 0;//register read to a,b
                    imm_action[0] <= 0; //no imm for b in this insn
                    //delay!
                    //set_delay <= 1;
                    fetch <= 0; d_pcincr <= 0;
                    state1 <= 130;
                    delay_counter <= 3;
                end
                25: begin //rbr
                    e_alu_op <= 8'h01; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu add, conditional, no flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= 31; // register write to pc
                    r_r2_addr <= reg_a_addr; r_r1_addr <= 31; r_read <= 3; //register read both, first - pc
                    r_to_mem <= 0;//register read to a,b
                    imm_action[0] <= 0; //no imm for b in this insn
                    //delay!
                    //set_delay <= 1;
                    fetch <= 0; d_pcincr <= 0;
                    state1 <= 130;
                    delay_counter <= 3;
                end
                26: begin //brl
                    e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, no flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 7; r_a1 <= 31; r_a2 <= 29; // register write a,b to pc,lr
                    r_r1_addr <= reg_a_addr; r_r2_addr <= 31; r_read <= 3; //register read both, second - pc
                    r_to_mem <= 0;//register read to a,b
                    imm_action[0] <= 0; //no imm for b in this insn
                    //delay!
                    //set_delay <= 1;
                    fetch <= 0; d_pcincr <= 0;
                    state1 <= 130;
                    delay_counter <= 3;
                end
                /*27: begin //rbl, can't implement now (need hook in register_wb)
                    e_alu_op <= 8'h01; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu add, conditional, no flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= 31 // register write to pc
                    r_r2_addr <= reg_a_addr; r_r1_addr <= 31; r_read <= 2; //register read both, first - pc
                    imm_action[0] <= 0; //no imm for b in this insn
                    //delay!
                end*/
                27: begin //ret
                    e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, no flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= 31; // register write to pc
                    r_r1_addr <= 29; r_read <= 1; //register read first - lr
                    r_to_mem <= 0;//register read to a,b
                    imm_action <= 3'b000; //no imm in this insn
                    //delay!
                    //set_delay <= 1;
                    fetch <= 0; d_pcincr <= 0;
                    state1 <= 130;
                    delay_counter <= 3;
                end
                28: begin //ldr
                    e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, no flags
                    m_r1_op <= 2; m_r2_op <= 1; //memory read c from a1
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_read <= 1; //register read first
                    r_to_mem <= 2'b01;//register read to m1, b
                    imm_action[0] <= 0; //no imm for b in this insn
                    imm_action[2] <= 1; //imm goes into m
                end
                29: begin //str
                    e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, no flags
                    m_r1_op <= 1; m_r2_op <= 5; //memory write d to a1
                    r_op <= 0; // register write nop
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 2'b01;//register read to m1, b
                    imm_action[0] <= 0; //no imm for b in this insn
                    imm_action[2] <= 1; //imm goes into m
                end
                //ldrc
                //strc
                //needs more elaborate management of operands (3, but have only 2, perhaps use imm ?

                //push
                //pop
                //one of this needs advanced management in memory_op stage
                //or make as in x86 - pop only decrements, not returning result

                30: begin //in
                    e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, no flags
                    m_r1_op <= 4'b1000; m_r2_op <= 4'b1; //sys read c from a1
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_read <= 1; //register read first
                    r_to_mem <= 2'b01;//register read to m1, b
                    imm_action[0] <= 0; //no imm for b in this insn
                    imm_action[2] <= 1; //imm goes into m
                end
                31: begin //out
                    e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, no flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1011; //sys write d to a1
                    r_op <= 0; // register write nop
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 2'b01;//register read to m1, b
                    imm_action[0] <= 0; //no imm for b in this insn
                    imm_action[2] <= 1; //imm goes into m
                end

                //ini
                //outi
                //needs more elaborate management of operands (3, but have only 2, perhaps use imm ?

                32: begin //movs
                    e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, no flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_read <= 1; //register read first
                    r_to_mem <= 0;//register read to a,b
                    imm_action[0] <= 0; //no imm for b in this insn
                end
                33: begin //mov
                    e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, all flags
                    m_r1_op <= 4'b1; m_r2_op <= 4'b1; //memory passthrough nop
                    r_op <= 7; r_a1 <= reg_c_addr; r_a2 <= reg_d_addr; // register write c,d to a1,a2
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 0;//register read to a,b
                    imm_action <= 3'b000; //no imm in this insn
                end
                /*28: begin //ldr
                    e_alu_op <= 8'h00; e_cond <= cond; e_write_flags <= 4'h0; e_is_cond <= 1; //alu nop, conditional, no flags
                    m_r1_op <= 4'b0011; m_r2_op <= 4'b1; //memory read c from a2
                    r_op <= 1; r_a1 <= reg_c_addr; // register write c to a1
                    r_r1_addr <= reg_a_addr; r_r2_addr <= reg_b_addr; r_read <= 3; //register read both
                    r_to_mem <= 2'b10;//register read to a,m2
                end*/

                128: begin //get first imm
                    if(imm_action == 3'b001) e_b <= word;
                    else if(imm_action == 3'b010 || imm_action == 3'b011) e_a <= word;
                    else if(imm_action == 3'b110 || imm_action == 3'b111) m_a1 <= word;
                    else if(imm_action == 3'b101) m_a2 <= word;
                end
                129: begin //get second imm
                    if(imm_action == 3'b011) e_b <= word;
                    else if(imm_action == 3'b111) m_a2 <= word;
                end
                130: begin //delay
                    fetch <= 0; d_pass <= 0; d_pcincr <= 0;
                    if(delay_counter > 0) delay_counter<=delay_counter-1;
                    #1;
                    if(delay_counter == 0) begin
                        fetch <= 1; /*d_pass <= 1;*/ d_pcincr <= 1;
                        state1 <= 0;
                    end
                end
                131: begin //hazard hold
                    #1;
                    if(!hazard) begin
                       d_pcincr <= old_pcincr_hz;
                       d_pass <= old_pass_hz;
                       reg_fetch <= 1;
                       fetch <= old_fetch_hz;
                       state1 <= old_state1_hz;
                    end
                end
                //132: begin //branch pipeline purge
                default: begin
                    fetch <= 1;
                    state1 <= 0;
                end
            endcase
            #1;
            if(set_delay) begin
                fetch <= 0; d_pcincr <= 0;
                state1 <= 130;
                set_delay <= 0;
            end
            #1;
            if(imm_action != 3'b100 && imm_action != 3'b000) begin //imm fetch procedure
                if(state1 != 128 && state1 != 129) begin //just got insn
                    if(imm_action[1]) begin //imm for r1
                        r_read[0] <= 0; //don't read r1
                    end
                    if(imm_action[0]) begin //imm for r2
                        r_read[1] <= 0;  //don't read r2
                    end
                    old_state1_imm <= state1; //save state
                    old_pass_imm <= d_pass;
                    old_fetch_imm <= fetch;
                    old_pcincr_imm <= d_pcincr;
                    d_pass <= 0; //don't issue insn
                    fetch <= 0; //don't decode insn
                    reg_fetch <= 0; //don't fetch regs
                    d_pcincr <= 1; //increment pc
                    state1 <= 128; //fetch first imm
                end
                else if(state1 == 128) begin //first imm fetched
                    if(imm_action == 3'b011 || imm_action == 3'b111) begin //need to fetch second imm
                        d_pass <= 0; //don't issue insn
                        fetch <= 0; //don't decode insn
                        reg_fetch <= 0; //don't fetch regs
                        d_pcincr <= 1; //increment pc
                        state1 <= 129; //fetch second imm
                    end
                    else begin //don't need to fetch second imm
                        state1 <= old_state1_imm; //restore state
                        d_pass <= old_pass_imm; //restore issue
                        fetch <= old_fetch_imm; //restore fetch
                        d_pcincr <= old_pcincr_imm; //restore incr pc
                        reg_fetch <= 1; //fetch regs
                        imm_action <= 3'b000; //don't fetch imm
                    end
                end
                else if(state1 == 129) begin //second imm fetched
                        state1 <= old_state1_imm; //restore state
                        d_pass <= old_pass_imm; //restore issue
                        fetch <= old_fetch_imm; //restore fetch
                        d_pcincr <= old_pcincr_imm; //restore incr pc
                        reg_fetch <= 1; //fetch regs
                        imm_action <= 3'b000; //don't fetch imm
                end
            end
            #1;
            if(hazard && reg_fetch) begin //hazard op
                old_pcincr_hz <= d_pcincr;
                old_pass_hz <= d_pass;
                old_fetch_hz <= fetch;
                old_state1_hz <= state1;
                d_pcincr <= 0;
                d_pass <= 0;
                fetch <= 0;
                reg_fetch <= 0;
                state1 <= 131;
            end
            #1;
            if(reg_fetch) begin //reg fetch procedure
               if(r_read[0]) begin
                   if(r_to_mem[0]) m_a1 <= r1;
                   else e_a <= r1;
               end
               if(r_read[1]) begin
                   if(r_to_mem[1]) m_a2 <= r2;
                   else e_b <= r2;
               end
               reg_fetch <= 0;
            end
        end
    end
endmodule
