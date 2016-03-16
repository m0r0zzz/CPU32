`timescale 1 ns / 10 ps

`include "test.v"

module main();
    parameter s = 8;
    parameter mx = 1 << s;
    parameter dl = 28;
    reg [s-1:0] a;
    reg [s-1:0] b;

    wire [2*s-1:0] m;

    reg [s:0] i;
    reg [s:0] j;

    mult_8 mult(a, b, m);

    initial begin
        a = 0;
        b = 0;
        $dumpfile("dump.fst");
        $dumpvars(0);
        $dumpon;
    end

    always begin
        for(i = 0; i < mx; i++ ) begin
            for(j = 0; j < mx; j++) begin
                a = i[s-1:0];
                b = j[s-1:0];
                #dl;
                if(m != a*b) $display("Multiply error: %x*%x =? %x", a, b, m);
            end
        end
        a = 0;
        b = 0;
        #dl;
        if(m != 0) $display("Multiply error*: 0*0 =? 0");
        $dumpflush;
        $finish;
    end
endmodule

