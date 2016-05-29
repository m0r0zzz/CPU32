
`include "mult.v"
`include "adder.v"
`include "shift.v"

module addsub_32(q, a, b, sub, ov, sov, z);
    input [31:0] a, b;
    input sub;

    output wire [31:0] q;
    output ov, sov, z;

    wire [31:0] bm = sub ? ~b : b;

    cla_32 cla0(a, bm, sub, q, ov);

    assign z = ~|q;

    assign sov = (!a[31]) && (!b[31]) ? ov : (a[31] && b[31] ? ~q[31] : 0);

endmodule

module mul_32(q1, q2, ov, z, a, b);
    input [31:0] a, b;

    output wire [31:0] q1, q2;
    output ov, z;

    wire [63:0] q;
    assign q1 = q[31:0];
    assign q2 = q[63:32];

    mult_32 m0( a, b, q);

    assign ov = |(q2);
    assign z = ~|({q2, q1});
endmodule

module bitwise_32(q, z, a, b, op);
    input [31:0] a, b;
    input [2:0] op;

    output reg [31:0] q;
    output wire z;

    assign z = ~|q;

    always @(a or b or op) begin
        case(op)
            3'b000: q <= ~ a; //NOT A
            3'b001: q <= a & b; // A AND B
            3'b010: q <= a | b; // A OR B
            3'b011: q <= a ^ b; // A XOR B
            3'b100: q <= ~(a & b); // A NAND B
            3'b101: q <= ~(a | b); // A NOR B
            3'b110: q <= ~(a ^ b); // A XNOR B
            3'b111: q <= ~ b; // NOT B (placeholder)
        endcase
    end
endmodule

module alu32_2x2(q0, q1, st, a, b, op);
    input [31:0] a, b;
    output [31:0] q0, q1;
    wire [31:0] q0, q1;

    input [7:0] op;
    output [3:0] st; //0 - V, 1 - C, 2 - Z, 3 - N

    wire [31:0] addsub;
    wire [31:0] addsub_a, addsub_b;
    wire addsub_z, addsub_ov, addsub_sov;
    reg subtract;
    addsub_32 as0(addsub, addsub_a, addsub_b, subtract, addsub_ov, addsub_sov, addsub_z);
    wire [3:0] addsub_st = {addsub[31], addsub_z, addsub_ov, addsub_sov};


    wire [31:0] shift;
    wire shift_z, shift_ov;
    reg rotate, left, arithmetic;
    bshift_32 sh0(shift, shift_ov, shift_z, a, b[4:0], rotate, left, arithmetic);
    wire [3:0] shift_st = {shift[31], shift_z, shift_ov, 1'b0};

    wire [31:0] mull, mulh;
    wire mul_z, mul_ov;
    mul_32 mul0(mull, mulh, mul_ov, mul_z, a, b);
    wire [3:0] mul_st = {1'b0, mul_z, mul_ov, 1'b0};

    wire [31:0] bws;
    wire bws_z;
    reg [2:0] b_op;
    bitwise_32 bw0(bws, bws_z, a, b, b_op);
    wire [3:0] bws_st = {1'b0, bws_z, 2'b0};

    always @(a or b or op) begin
        if(op == 8'h00) begin //NOP
            force q0 = a;
            force q1 = b;

            force st = 4'b0;
        end else if (op == 8'h01) begin //ADD
            subtract <= 0;
            force addsub_a = a;
            force addsub_b = b;
            force q0 = addsub;
            force q1 = 32'b0;

            force st = addsub_st;
        end else if (op == 8'h02) begin //SUB
            subtract <= 1;
            force addsub_a = a;
            force addsub_b = b;
            force q0 = addsub;
            force q1 = 32'b0;

            force st = addsub_st;
        end else if (op == 8'h03) begin //CPL
            subtract <= 1;
            force addsub_a = 32'b0;
            force addsub_b = a;
            force q0 = addsub;
            force q1 = 32'b0;

            force st = addsub_st;
        end else if (op == 8'h04) begin //MUL
            force q0 = mull;
            force q1 = mulh;

            force st = mul_st;
        end else if (op == 8'h05) begin //SHR
            rotate <= 0;
            left <= 0;
            arithmetic <= 0;
            force q0 = shift;
            force q1 = 32'b0;

            force st = shift_st;
        end else if (op == 8'h06) begin // SHL
            rotate <= 0;
            left <= 1;
            arithmetic <= 0;
            force q0 = shift;
            force q1 = 32'b0;

            force st = shift_st;
        end else if (op == 8'h07) begin // SAR
            rotate <= 0;
            left <= 0;
            arithmetic <= 1;
            force q0 = shift;
            force q1 = 32'b0;

            force st = shift_st;
        end else if (op == 8'h08) begin // SAL
            rotate <= 0;
            left <= 1;
            arithmetic <= 1;
            force q0 = shift;
            force q1 = 32'b0;

            force st = shift_st;
        end else if (op == 8'h09) begin // ROR
            rotate <= 1;
            left <= 0;
            arithmetic <= 0;
            force q0 = shift;
            force q1 = 32'b0;

            force st = shift_st;
        end else if (op == 8'h0A) begin // ROL
            rotate <= 1;
            left <= 1;
            arithmetic <= 0;
            force q0 = shift;
            force q1 = 32'b0;

            force st = shift_st;
        end else if(op == 8'h0B) begin //NOT
            b_op <= 0;
            force q0 = bws;
            force q1 = 32'b0;

            force st = bws_st;
        end else if(op == 8'h0C) begin //AND
            b_op <= 1;
            force q0 = bws;
            force q1 = 32'b0;

            force st = bws_st;
        end else if(op == 8'h0D) begin //OR
            b_op <= 2;
            force q0 = bws;
            force q1 = 32'b0;

            force st = bws_st;
        end else if(op == 8'h0E) begin //XOR
            b_op <= 3;
            force q0 = bws;
            force q1 = 32'b0;

            force st = bws_st;
        end else if(op == 8'h0F) begin //NAND
            b_op <= 4;
            force q0 = bws;
            force q1 = 32'b0;

            force st = bws_st;
        end else if(op == 8'h10) begin //NOR
            b_op <= 5;
            force q0 = bws;
            force q1 = 32'b0;

            force st = bws_st;
        end else if(op == 8'h11) begin //XNOR
            b_op <= 6;
            force q0 = bws;
            force q1 = 32'b0;

            force st = bws_st;
        end else begin //invalid
            release q0;
            release q1;
            release st;
        end
    end
endmodule
