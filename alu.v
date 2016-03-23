
`include "mult.v"
`include "adder.v"
`include "shift.v"

module addsub_32(q, a, b, sub, ov, z);
    input [31:0] a, b;
    input sub;

    output wire [31:0] q;
    output ov, z;

    wire [31:0] bm = sub ? ~a : a;

    cla_32 cla0(a, bm, sub, q, ov);

    assign z = ~|q;
endmodule

module alu32_2x2(q0, q1, fout, a, b, op);
    input [31:0] a, b;
    output [31:0] q0, q1;

    input [7:0] op;
    output [?:0] fout;

    wire [31:0] addsub;
    wire addsub_z, addsub_ov;
    reg subtract;
    addsub_32 as0(addsub, a, b, subtract, addsub_ov, addsub_z);



    //TODO
endmodule
