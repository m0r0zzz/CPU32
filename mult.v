module mult (a, b, q);
    input [31:0] a;
    input [31:0] b;
    input clk;

    output [63:0] q;
    wire [63:0] q;

    assign q = a*b;
endmodule
