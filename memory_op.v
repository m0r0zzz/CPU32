`timescale 1 ns / 100 ps

module memory_op_stage_passthrough(q_a1, q_a2, q_op, q_proceed, a1, a2, op, proceed, clk, rst);
    input [4:0] a1, a2; //(reg_wb)
    input [3:0] op; //(reg_wb)
    input proceed;

    input clk, rst;

    output reg [4:0] q_a1, q_a2; //(reg_wb)
    output reg [3:0] q_op; //(reg_wb)
    output reg q_proceed;

    always @(posedge clk or rst) begin
        if(rst) begin
            q_a1 <= 5'b0; q_a2 <= 5'b0;
            q_op <= 4'b0;
            q_proceed <= 1'b0;
        end
        else begin
            q_a1 <= a1; q_a2 <= a2;
            q_op <= op;
            q_proceed <= proceed;
        end
    end
endmodule

module memory_op( m1, m2, ram_w_addr, ram_r_addr, ram_w, ram_r, ram_w_line, sys_w_addr, sys_w_line, sys_w, sys_r, r1, r2, a1, a2, r1_op, r2_op, ram_r_line, sys_r_line, proceed, clk, rst);
    input [31:0] r1, r2; //inputs
    input [31:0] a1, a2; //memory addresses

    input [3:0] r1_op, r2_op; //operation codes

    input [31:0] ram_r_line, sys_r_line; // read lanes

    input proceed; //conditional code test result

    input clk, rst;

    output wire [31:0] m1, m2; //outputs

    output reg [31:0] ram_w_addr, sys_w_addr; //write addresses
    output reg [31:0] ram_r_addr, sys_r_addr; //read addresses

    output reg [31:0] ram_w_line, sys_w_line; //write lanes

    output reg ram_w, sys_w, ram_r, sys_r; //read/write signals

    wire [3:0] r1_op_inner, r2_op_inner;

    assign r1_op_inner = proceed ? r1_op : 4'b0;
    assign r2_op_inner = proceed ? r2_op : 4'b0;

    always @(posedge clk or rst) begin
        if(rst) begin
            ram_w_addr <= 32'b0; ram_r_addr <= 32'b0;
            sys_w_addr <= 32'b0; sys_r_addr <= 32'b0;
            ram_w_line <= 32'b0; sys_w_line <= 32'b0;
            ram_w <= 1'b0; ram_r <= 1'b0; sys_r <= 1'b0; sys_w <= 1'b0;
        end

        ram_w <= 1'b0; ram_r <= 1'b0; sys_r <= 1'b0; sys_w <= 1'b0;

        case(r1_op_inner)
            0: begin //clean NOP
                force m1 = 32'b0;
                end
            1: begin //passthrough NOP
                force m1 = r1;
                end
            2: begin //load from memory address a1
                force m1 = ram_r_line;
                ram_r_addr <= a1;
                ram_r <= 1'b1;
                end
            3: begin //load from memory address a2
                force m1 = ram_r_line;
                ram_r_addr <= a2;
                ram_r <= 1'b1;
                end
            4: begin //load from memory address r2
                force m1 = ram_r_line;
                ram_r_addr <= r2;
                ram_r <= 1'b1;
                end
            5: begin //write to memory address a1
                force m1 = r1;
                ram_w_line <= r1;
                ram_w_addr <= a1;
                ram_w <= 1'b1;
                end
            6: begin //write to memory address a2
                force m1 = r1;
                ram_w_line <= r1;
                ram_w_addr <= a2;
                ram_w <= 1'b1;
                end
            7: begin //write to memory address r2
                force m1 = r1;
                ram_w_line <= r1;
                ram_w_addr <= r2;
                ram_w <= 1'b1;
                end
            8: begin //load from sys address a1
                force m1 = sys_r_line;
                sys_r_addr <= a1;
                sys_r <= 1'b1;
                end
            9: begin //load from sys address a2
                force m1 = sys_r_line;
                sys_r_addr <= a2;
                sys_r <= 1'b1;
                end
            10: begin //load from sys address r2
                force m1 = sys_r_line;
                sys_r_addr <= r2;
                sys_r <= 1'b1;
                end
            11: begin //write to sys address a1
                force m1 = r1;
                sys_w_line <= r1;
                sys_w_addr <= a1;
                sys_w <= 1'b1;
                end
            12: begin //write to sys address a2
                force m1 = r1;
                sys_w_line <= r1;
                sys_w_addr <= a2;
                sys_w <= 1'b1;
                end
            13: begin //write to sys address r2
                force m1 = r1;
                sys_w_line <= r1;
                sys_w_addr <= r2;
                sys_w <= 1'b1;
                end
            14: begin //swap regs
                force m1 = r2;
                end
        endcase

        case(r2_op_inner)
            0: begin //clean NOP
                force m2 = 32'b0;
                end
            1: begin //passthrough NOP
                force m2 = r2;
                end
            2: begin //load from memory address a1
                force m2 = ram_r_line;
                ram_r_addr <= a1;
                ram_r <= 1'b1;
                end
            3: begin //load from memory address a2
                force m2 = ram_r_line;
                ram_r_addr <= a2;
                ram_r <= 1'b1;
                end
            4: begin //load from memory address r1
                force m2 = ram_r_line;
                ram_r_addr <= r1;
                ram_r <= 1'b1;
                end
            5: begin //write to memory address a1
                force m2 = r2;
                ram_w_line <= r2;
                ram_w_addr <= a1;
                ram_w <= 1'b1;
                end
            6: begin //write to memory address a2
                force m2 = r2;
                ram_w_line <= r2;
                ram_w_addr <= a2;
                ram_w <= 1'b1;
                end
            7: begin //write to memory address r1
                force m2 = r2;
                ram_w_line <= r2;
                ram_w_addr <= r1;
                ram_w <= 1'b1;
                end
            8: begin //load from sys address a1
                force m2 = sys_r_line;
                sys_r_addr <= a1;
                sys_r <= 1'b1;
                end
            9: begin //load from sys address a2
                force m2 = sys_r_line;
                sys_r_addr <= a2;
                sys_r <= 1'b1;
                end
            10: begin //load from sys address r1
                force m2 = sys_r_line;
                sys_r_addr <= r1;
                sys_r <= 1'b1;
                end
            11: begin //write to sys address a1
                force m2 = r2;
                sys_w_line <= r2;
                sys_w_addr <= a1;
                sys_w <= 1'b1;
                end
            12: begin //write to sys address a2
                force m2 = r2;
                sys_w_line <= r2;
                sys_w_addr <= a2;
                sys_w <= 1'b1;
                end
            13: begin //write to sys address r1
                force m2 = r2;
                sys_w_line <= r2;
                sys_w_addr <= r1;
                sys_w <= 1'b1;
                end
            14: begin //swap regs
                force m2 = r1;
                end
        endcase
    end
endmodule
