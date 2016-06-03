
`timescale 1 ns / 100 ps

module fa_pg(a, b, cin, s, p, g);
    input a, b, cin;

    output wire s, p, g;

    wire w1;

	xor x1(p, a, b);
	xor x2(s, p, cin);

    and a1(g, a, b);
//    or #1 o1(p, a, b);
endmodule

module cla_4(a, b, cin, s, pg, gg);
    input [3:0] a;
    input [3:0] b;
    output wire [3:0] s;

    input cin;
    output wire pg, gg;

    wire [3:0] p;
    wire [3:0] g;
    wire [2:0] c;

    fa_pg fa0(a[0], b[0],  cin, s[0], p[0], g[0]);
    fa_pg fa1(a[1], b[1], c[0], s[1], p[1], g[1]);
    fa_pg fa2(a[2], b[2], c[1], s[2], p[2], g[2]);
    fa_pg fa3(a[3], b[3], c[2], s[3], p[3], g[3]);

    assign c[0] = g[0] | p[0]&cin;
    assign c[1] = g[1] | g[0]&p[1] | cin&p[0]&p[1];
    assign c[2] = g[2] | g[1]&p[2] | g[0]&p[1]&p[2] | cin&p[0]&p[1]&p[2];

    assign pg = p[0]&p[1]&p[2]&p[3];
    assign gg = g[3] | g[2]&p[3] | g[1]&p[3]&p[2] | g[0]&p[3]&p[2]&p[1];
    //assign cout = gg | cin&pg;
endmodule

module cla_16(a, b, cin, s, pg, gg);
    input [15:0] a;
    input [15:0] b;
    output wire [15:0] s;

    input cin;
    output wire pg, gg;

    wire [3:0] p;
    wire [3:0] g;
    wire [2:0] c;

    cla_4 cla0(a[3:0],     b[3:0],  cin,   s[3:0], p[0], g[0]);
    cla_4 cla1(a[7:4],     b[7:4], c[0],   s[7:4], p[1], g[1]);
    cla_4 cla2(a[11:8],   b[11:8], c[1],  s[11:8], p[2], g[2]);
    cla_4 cla3(a[15:12], b[15:12], c[2], s[15:12], p[3], g[3]);

    assign c[0] = g[0] | p[0]&cin;
    assign c[1] = g[1] | g[0]&p[1] | cin&p[0]&p[1];
    assign c[2] = g[2] | g[1]&p[2] | g[0]&p[1]&p[2] | cin&p[0]&p[1]&p[2];

    assign pg = p[0]&p[1]&p[2]&p[3];
    assign gg = g[3] | g[2]&p[3] | g[1]&p[3]&p[2] | g[0]&p[3]&p[2]&p[1];
    //assign cout = gg | cin&pg;
endmodule

module cla_32(a, b, cin, s, cout);
    input [31:0] a;
    input [31:0] b;
    output wire [31:0] s;

    input cin;
    output wire cout;

    wire [3:0] p;
    wire [3:0] g;
    wire [2:0] c;

    cla_16 cla0(a[15:0],   b[15:0],  cin,   s[15:0], p[0], g[0]);
    cla_16 cla1(a[31:16], b[31:16], c[0],  s[31:16], p[1], g[1]);

    assign c[0] = g[0] | p[0]&cin;
    assign cout = g[1] | g[0]&p[1] | cin&p[0]&p[1];
endmodule

module cla_64(a, b, cin, s, cout);
    input [63:0] a;
    input [63:0] b;
    output wire [63:0] s;

    input cin;
    wire pg, gg;
    output wire cout;

    wire [3:0] p;
    wire [3:0] g;
    wire [2:0] c;

    cla_16 cla0(a[15:0],   b[15:0],  cin,  s[15:0], p[0], g[0]);
    cla_16 cla1(a[31:16], b[31:16], c[0], s[31:16], p[1], g[1]);
    cla_16 cla2(a[47:32], b[47:32], c[1], s[47:32], p[2], g[2]);
    cla_16 cla3(a[63:48], b[63:48], c[2], s[63:48], p[3], g[3]);

    assign c[0] = g[0] | p[0]&cin;
    assign c[1] = g[1] | g[0]&p[1] | cin&p[0]&p[1];
    assign c[2] = g[2] | g[1]&p[2] | g[0]&p[1]&p[2] | cin&p[0]&p[1]&p[2];

    assign pg = p[0]&p[1]&p[2]&p[3];
    assign gg = g[3] | g[2]&p[3] | g[1]&p[3]&p[2] | g[0]&p[3]&p[2]&p[1];
    assign cout = gg | cin&pg;
endmodule
