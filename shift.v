
/*module fr(a, q);
    input  [2:0] a;
    output [2:0] q;

    assign q[0] = a[0];
    assign q[2] = ((~a[0])&a[2])^(a[0]&a[1]);
    assign q[1] = ((~a[0])&a[1])^(a[0]&a[2]);
endmodule

module fe(a, q);
    input  [1:0] a;
    output [1:0] q;

    assign q[0] = a[0];
    assign q[1] = a[0]^a[1];
endmodule

module rev_shift_4(I, O, S);
    input  [3:0] I;
    input  [1:0] S;
    output [3:0] O;

    wire wfe[7:0];

    fe fe0({I[0], 1'b0}, wfe[1:0]);
    fe fe1({I[1], 1'b0}, wfe[3:2]);
    fe fe2({I[2], 1'b0}, wfe[5:4]);
    fe fe1({I[3], 1'b0}, wfe[7:6]);

    wire grb0[3:0];
    wire sgrb[3:0];
    wire wfr[3:0];

    fr fr0({S[0],wfe[1:0]}, {sgrb[0], grb0[0], wfr[0]});
    fr fr1({S[0],wfe[2:3]}, {sgrb[1], grb0[1], wfr[1]});
    fr fr2({S[0],wfe[5:4]}, {sgrb[2], grb0[2], wfr[2]});
    fr fr3({S[0],wfe[7:6]}, {sgrb[3], grb0[3], wfr[3]});

    wire ssgrb[1:0];

    fr fr4({S[1],wfr[1:0]},{ssgrb[0], O[1:0]});
    fr fr5({S[1],wfr[3:2]},{ssgrb[1], O[3:2]});
endmodule*/

module right_shift_rot_32(y, a, b, rotate, sra, sla);
    input [31:0] a;
    input [4:0] b;

    output[31:0] y;

    input rotate, sra, sla;

    wire sgnr = sra ? a[31] : 1'b0;

//stage 1, b[4] - 16-bit shift/rot
    wire [31:0] st1;
    wire [15:0] r1;
    //rot section
    assign r1 = rotate ? a[15:0] : (sgnr ? 16'hffff : 16'h0);
    //shift section
    assign st1[31:16] = b[4] ? r1 : a[31:16];
    assign st1[15:0] = b[4] ? a[31:16] : a[15:0];

//stage 2, b[3] - 8-bit shift/rot
    wire [31:0] st2;
    wire [7:0] r2;
    //rot section
    assign r2 = rotate ? st1[7:0] : (sgnr ? 8'hff : 8'h0);
    //shift section
    assign st2[31:24] = b[3] ? r2 : st1[31:24];
    assign st2[23:0] = b[3] ? st1[31:8] : st1[23:0];
//stage 3, b[2] - 4-bit shift/rot
    wire [31:0] st3;
    wire [3:0] r3;
    //rot section
    assign r3 = rotate ? st2[3:0] : (sgnr ? 4'hf : 4'h0);
    //shift section
    assign st3[31:28] = b[2] ? r3 : st2[31:28];
    assign st3[27:0] = b[2] ? st2[31:4] : st2[27:0];
//stage 4, b[1] - 2-bit shift/rot
    wire [31:0] st4;
    wire [1:0] r4;
    //rot section
    assign r4 = rotate ? st3[1:0] : (sgnr ? 2'b11 : 2'b00);
    //shift section
    assign st4[31:30] = b[1] ? r4 : st3[31:30];
    assign st4[29:0] = b[1] ? st3[31:2] : st3[29:0];
//stage 5, b[0] - 1-bit shift/rot
    wire r5;
    wire sgnl;
    //rot section
    assign r5 = rotate ? st4[0] : sgnr;
    //shift section
    assign y[31] = b[0] ? r5 : st4[31];
    assign {y[30:1], sgnl} = b[0] ? st4[31:1] : st4[30:0];
    assign y[0] = sla ? a[0] : sgnl;

endmodule

module right_rot_32(y, a, b);
    input [31:0] a;
    input [4:0] b;

    output [31:0] y;

//stage 1, b[4] - 16-bit rot
    wire [31:0] st1;

    assign st1[31:16] = b[4] ? a[15:0] : a[31:16];
    assign st1[15:0] = b[4] ? a[31:16] : a[15:0];
//stage 2, b[3] - 8-bit rot
    wire [31:0] st2;

    assign st2[31:24] = b[3] ? st1[7:0] : st1[31:24];
    assign st2[23:0] = b[3] ? st1[31:8] : st1[23:0];
//stage 3, b[2] - 4-bit rot
    wire [31:0] st3;

    assign st3[31:28] = b[2] ? st2[3:0] : st2[31:28];
    assign st3[27:0] = b[2] ? st2[31:4] : st2[27:0];
//stage 4, b[1] - 2-bit rot
    wire [31:0] st4;

    assign st4[31:30] = b[1] ? st3[1:0] : st3[31:30];
    assign st4[29:0] = b[1] ? st3[31:2] : st3[29:0];
//stage 5, b[0] - 1-bit rot

    assign y[31] = b[0] ? st4[0] : st4[31];
    assign y[30:0] = b[0] ? st4[31:1] : st4[30:0];
endmodule

module drev_32(q, a, e);
    input [31:0] a;

    output [31:0] q;
    input e;

    genvar i;
    generate for(i = 0; i < 32; i = i + 1) begin
        assign q[i] = e ? a[31-i] : a[i];
    end
    endgenerate
endmodule

module fmask_32(q, a);
    input [4:0] a;
    output [31:0] q;
    reg [31:0] q;

    always @(a) begin
        case(a)
            5'h00: q = 32'b11111111111111111111111111111111;
            5'h01: q = 32'b01111111111111111111111111111111;
            5'h02: q = 32'b00111111111111111111111111111111;
            5'h03: q = 32'b00011111111111111111111111111111;
            5'h04: q = 32'b00001111111111111111111111111111;
            5'h05: q = 32'b00000111111111111111111111111111;
            5'h06: q = 32'b00000011111111111111111111111111;
            5'h07: q = 32'b00000001111111111111111111111111;
            5'h08: q = 32'b00000000111111111111111111111111;
            5'h09: q = 32'b00000000011111111111111111111111;
            5'h0A: q = 32'b00000000001111111111111111111111;
            5'h0B: q = 32'b00000000000111111111111111111111;
            5'h0C: q = 32'b00000000000011111111111111111111;
            5'h0D: q = 32'b00000000000001111111111111111111;
            5'h0E: q = 32'b00000000000000111111111111111111;
            5'h0F: q = 32'b00000000000000011111111111111111;
            5'h10: q = 32'b00000000000000001111111111111111;
            5'h11: q = 32'b00000000000000000111111111111111;
            5'h12: q = 32'b00000000000000000011111111111111;
            5'h13: q = 32'b00000000000000000001111111111111;
            5'h14: q = 32'b00000000000000000000111111111111;
            5'h15: q = 32'b00000000000000000000011111111111;
            5'h16: q = 32'b00000000000000000000001111111111;
            5'h17: q = 32'b00000000000000000000000111111111;
            5'h18: q = 32'b00000000000000000000000011111111;
            5'h19: q = 32'b00000000000000000000000001111111;
            5'h1A: q = 32'b00000000000000000000000000111111;
            5'h1B: q = 32'b00000000000000000000000000011111;
            5'h1C: q = 32'b00000000000000000000000000001111;
            5'h1D: q = 32'b00000000000000000000000000000111;
            5'h1E: q = 32'b00000000000000000000000000000011;
            5'h1F: q = 32'b00000000000000000000000000000001;
            default: q = 32'b00000000000000000000000000000000;
        endcase
    end
endmodule

module ovf_32(q, a, f, sla);
    input [31:0] f;
    input [31:0] a;
    input sla;

    output q;

    wire [30:0] aexp = a[31] ? 31'h7FFFFFFF : 31'h00000000;

    wire w1 = |((aexp^a[30:0])&(~(f[31:1])));

    assign q = sla&w1;
endmodule

module zmask_32(q, a, sla);
    input [31:0] a;
    input sla;

    output [31:0] q;

    assign q[0] = sla | a[31];

    genvar i;
    generate for(i = 1; i < 32; i = i + 1) begin
        assign q[i] = sla ? a[32-i] : a[31-i];
    end
    endgenerate
endmodule

module tblock_32(q, a, sgn, p, sla, sra);
    input [31:0] a;
    input [31:0] p;
    input sgn, sla, sra;

    output [31:0] q;

    wire [30:0] s = (sra&sgn) ? 31'h7FFFFFFF : 31'h00000000;

    assign q[0] = a[0]&(~sla) | sla&sgn;
    assign q[31:1] = a[31:1]&p[31:1] | s&(~p[31:1]);
endmodule

module bshift_32(q, ov, z, a, b, rotate, left, arith);
    input [31:0] a;
    input[4:0] b;
    input rotate, left, arith;

    output [31:0] q;
    output ov, z;

    wire [31:0] am;
    drev_32 dr0(am, a, left);

    wire [31:0] ym;
    right_rot_32 rr0(ym, am, b);

    wire sra = (~rotate)&(~left)&arith;
    wire sla = (~rotate)&(left)&arith;

    wire[31:0] f;
    fmask_32 f0(f, b);

    wire [31:0] p;
    assign p = rotate ? 32'hFFFFFFFF : f;

    wire [31:0] t;
    tblock_32 t0(t, ym, a[31], p, sla, sra);

    drev_32 dr1(q, t, left);

    wire [31:0] zm;
    zmask_32 z0(zm, p, sla);

    assign z = ~|(zm&am);

    ovf_32 ov0(ov, a, f, sla);
endmodule
