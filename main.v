`include "ram.v"
`include "adder.v"
`include "shift.v"

`timescale 1 ns / 1 ns

// memory test
/*module main();

    reg [31:0] w_addr;
    reg [31:0] r_addr;
    reg [31:0] w_line;
    reg clk;
    reg read;
    reg write;

    wire [31:0] r_line1;
    wire [31:0] r_line2;
    wire exc1;
    wire exc2;
    wire wrdy, rrdy;

    ram R1(r_addr, w_addr, r_line1, w_line, read, write, wrdy, rrdy, exc1, clk);
    emb_ram R2(r_addr, w_addr, r_line2, w_line, read, write, exc2, clk);

    integer i;
    time t1, t2;

    initial begin
        w_addr = 32'b0;
        r_addr = 32'b0;
        w_line = 32'b0;
        clk = 1'b1;
        read = 1'b0;
        write = 1'b0;

        $dumpfile("dump.fst");
        $dumpvars(0);
        $dumpon;
    end

    always begin //clock generator
        #1 clk = 0;
        #1 clk = 1;
    end

    always begin //testcase
        for(i = 0; i < 2048; i++) begin
            w_line <= i << 1;
            w_addr <= i + 1;
            write <= 1;
            r_addr <= i;
            read <= 1;
            wait(!wrdy && !rrdy);
            if(!(exc1 || exc2)) wait(wrdy && rrdy);
            write <= 0;
            $display(r_line1);
            $display(r_line2);
            if(exc1 && exc2) $display("Double Exception!");
            else if(exc1) $display("First Exception!");
            else if(exc2) $display("Second Exception!");
            read <= 0;
            #0;
        end
        $dumpflush;
        $finish;
    end

endmodule*/

//adder test
/*module main();
    reg [15:0] a, b;
    reg cin;
    wire [15:0] s;
    wire pg, gg, cout;

    cla_16 cla0(a, b, cin, s, pg, gg);

    initial begin
        integer i, j, k;
        //$dumpfile("dump.fst");
        //$dumpvars(0);
        //$dumpon;
        #3;
        for(k = 0; k < 2; k++) begin
            for(i = 0; i < 65536; i++) begin
                for(j = 0; j < 65536; j++) begin
                   a = i;
                   b = j;
                   cin = k;
                   #3;
                   if({cout, s} != (i+j+k)) $display(" (%h) %h + %h != %h", k, a, b, {cout, s});
                end
                $display(" %h", i);
 //               $dumpflush;
            end
            $display("---half---");
 //           $dumpflush;
        end
        //$dumpflush;
        //$finish;
    end
endmodule*/

//shifter test
function [31:0] rotr;
    input[31:0] a;
    input[4:0] b;
    rotr = ( a >> b) | (a << ((-b) & 31));
endfunction

function [31:0] rotl;
    input[31:0] a;
    input[4:0] b;
    rotl = ( a << b) | (a >> ((-b) & 31));
endfunction

function [31:0] sal;
    input[31:0] a;
    input[4:0] b;
    sal[30:0] = (a[30:0] << b);
    sal[31] = a[31];
endfunction

function [31:0] sar;
    input[31:0] a;
    input[4:0] b;

    integer x;
    x = a;
    //if(a[31]) x = -x;
    sar = x >>> b;
endfunction

module main();
    reg[31:0] a;
    reg[4:0] b;
    wire[31:0] y;

    reg left, rot, arith;
    wire z, ov;

    bshift_32 bs0(y, ov, z, a, b, rot, left, arith);

    integer i, j;
    reg [31:0] x;

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0);
        $dumpon;
        a = 32'b0;
        b = 5'b0;
        left = 1; rot = 1; arith = 0;
        #1;
        for(i = 0; i < 65536; i++) begin
            x = $mti_random;
            for(j = 0; j < 32; j++) begin
                a = x;
                b = j;
                #1;
                if(y != rotl(x, j)) $display(" %h rotl %h != %h (%h)", a, b, y, rotl(x, j));
            end
            if( (i&65535) == 0 ) $display("-> %h", (i >> 16));
        end
        $dumpflush;
        $finish;
    end
endmodule
