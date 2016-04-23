`timescale 1 ns / 100 ps

`include "execute.v"
`include "memory_op.v"
`include "register_wb.v"

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

/*module main();
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
endmodule*/


/*module main();
    reg [31:0] a, b;
    reg [7:0] op;

    wire [31:0] ql, qh;
    wire [3:0] fout;

    alu32_2x2 alu0(ql, qh, fout, a, b, op);

    initial begin
        integer i, j, o;
        reg [31:0] x1, x2;
        reg [31:0] tl, th;
        $dumpfile("dump.fst");
        $dumpvars(0);
        $dumpon;
        a = 32'b0;
        b = 32'b0;
        op = 8'b0;
        #1
        for(i = 0; i < 256; i++) begin
            x1 = $mti_random;
            for(j = 0; j < 256; j++) begin
                x2 = $mti_random;
                for(o = 0; o < 19; o++) begin
                    a = x1;
                    b = x2;
                    op = o;
                    th = 0;
                    case(o)
                        0: begin tl = x1; th = x2; end
                        1: tl = x1 + x2;
                        2: tl = x1 - x2;
                        3: tl = -x1;
                        4: {th, tl} = x1*x2;
                        5: tl = x1 >> (x2&5'h1F);
                        6: tl = x1 << (x2&5'h1F);
                        7: tl = sar(x1, (x2&5'h1F));
                        8: tl = sal(x1, (x2&5'h1F));
                        9: tl = rotr(x1, (x2&5'h1F));
                        10: tl = rotl(x1, (x2&5'h1F));
                        11: tl = ~x1;
                        12: tl = x1 & x2;
                        13: tl = x1 | x2;
                        14: tl = x1 ^ x2;
                        15: tl = x1 ~& x2;
                        16: tl = x1 ~| x2;
                        17: tl = x1 ~^ x2;
                        18: begin tl = 32'bx; th = 32'bx; end
                    endcase
                    #16;
                    if(ql != tl || qh != th) $display("error in op %h for a = %h, b = %h (test: l = %h, h = %h; got l = %h, h = %h)", o, x1, x2, tl, th, ql, qh);
                end
            end
            $display("-> %h",i);
        end
        $dumpflush;
        $finish;
    end
endmodule*/
