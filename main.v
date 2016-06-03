`timescale 1 ns / 100 ps

`include "test_processor_assembly.v"

module test_rom(word, addr);
        input [31:0] addr;

        output wire [31:0] word;

        reg [31:0] insn;
        assign word = insn;

        always @(addr) begin
                #1;
                case(addr)
                        /*32'h0: begin //(mov)nop reg 29 to reg 30
                            insn[31:25] <= 00; insn[24:21] <= 4'b1110; insn[20:16] <= 29; insn[15:11] <= 0; insn[10:6] <= 30; insn[5:1] <= 0; insn[0] <= 0;
                        end*/
                        32'h0: begin //movs imm to reg 30 (sp)
                            insn[31:25] <= 32; insn[24:21] <= 4'b1110; insn[20:11] <= 0; insn[10:6] <= 30; insn[5:1] <= 5'b10000; insn[0] <= 0;
                        end
                        32'h1: begin
                            insn <= 32'h14888;
                        end
                        32'h3: begin //movs imm to reg 29 (lr)
                            insn[31:25] <= 32; insn[24:21] <= 4'b1110; insn[20:11] <= 0; insn[10:6] <= 29; insn[5:1] <= 5'b10000; insn[0] <= 0;
                        end
                        32'h4: begin
                            insn <= 32'h22888;
                        end
                        32'h5: begin //add 29 and 30 to 30
                            insn[31:25] <= 13; insn[24:21] <= 4'b1110; insn[20:16] <= 29; insn[15:11] <= 30; insn[10:6] <= 30; insn[5:1] <= 5'b00000; insn[0] <= 0;
                        end
                        32'h6: begin //add imm1 and imm2 to 29
                            insn[31:25] <= 13; insn[24:21] <= 4'b1110; insn[20:16] <= 0; insn[15:11] <= 0; insn[10:6] <= 29; insn[5:1] <= 5'b11000; insn[0] <= 0;
                        end
                        32'h7: begin
                            insn <= 32'h35942;
                        end
                        32'h8: begin
                            insn <= 32'hDEADBEAF;
                        end
                        32'h9: begin //mul 29 and 30 to 29 and 30
                            insn[31:25] <= 17; insn[24:21] <= 4'b1110; insn[20:16] <= 29; insn[15:11] <= 30; insn[10:6] <= 29; insn[5:1] <= 30; insn[0] <= 0;
                        end
                        32'hA: begin //xor 29 and 30 to 30
                            insn[31:25] <= 6; insn[24:21] <= 4'b1110; insn[20:16] <= 29; insn[15:11] <= 30; insn[10:6] <= 30; insn[5:1] <= 00; insn[0] <= 0;
                        end
                        32'hB: begin //csr 30 by imm to 29
                            insn[31:25] <= 11; insn[24:21] <= 4'b1110; insn[20:16] <= 30; insn[15:11] <= 0; insn[10:6] <= 29; insn[5:1] <= 5'b01000; insn[0] <= 0;
                        end
                        32'hC: begin
                            insn <= 11;
                        end
                        32'hD: begin //branch to imm
                            insn[31:25] <= 24; insn[24:21] <= 4'b1110; insn[20:16] <= 0; insn[15:11] <= 0; insn[10:6] <= 0; insn[5:1] <= 5'b10000; insn[0] <= 0;
                        end
                        32'hE: begin
                            insn <= 32'h132;
                        end
                        32'h132: begin //out 29 to 30
                            insn[31:25] <= 31; insn[24:21] <= 4'b1110; insn[20:16] <= 30; insn[15:11] <= 29; insn[10:6] <= 0; insn[5:1] <= 0; insn[0] <= 0;
                        end
                        32'h133: begin //out 30 to 29
                            insn[31:25] <= 31; insn[24:21] <= 4'b1110; insn[20:16] <= 29; insn[15:11] <= 30; insn[10:6] <= 0; insn[5:1] <= 0; insn[0] <= 0;
                        end
                        32'h134: begin //brl to 30
                            insn[31:25] <= 26; insn[24:21] <= 4'b1110; insn[20:16] <= 30; insn[15:11] <= 0; insn[10:6] <= 0; insn[5:1] <= 5'b00000; insn[0] <= 0;
                        end
                        32'h135: begin //str to imm from 30
                            insn[31:25] <= 29; insn[24:21] <= 4'b1110; insn[20:16] <= 0; insn[15:11] <= 30; insn[10:6] <= 0; insn[5:1] <= 5'b10000; insn[0] <= 0;
                        end
                        32'h136: begin
                            insn <= 16;
                        end
                        32'h137: begin //mov 29, 30 to 30, 29
                            insn[31:25] <= 33; insn[24:21] <= 4'b1110; insn[20:16] <= 29; insn[15:11] <= 30; insn[10:6] <= 30; insn[5:1] <= 29; insn[0] <= 0;
                        end
                        32'h138: begin //out 30 to 29
                            insn[31:25] <= 31; insn[24:21] <= 4'b1110; insn[20:16] <= 29; insn[15:11] <= 30; insn[10:6] <= 0; insn[5:1] <= 0; insn[0] <= 0;
                        end
                        32'h139: begin //ldr from imm to 30
                            insn[31:25] <= 28; insn[24:21] <= 4'b1110; insn[20:16] <= 0; insn[15:11] <= 0; insn[10:6] <= 30; insn[5:1] <= 5'b10000; insn[0] <= 0;
                        end
                        32'h13A: begin
                            insn <= 16;
                        end
                        32'h13B:  begin //movs imm to r1
                            insn[31:25] <= 32; insn[24:21] <= 4'b1110; insn[20:16] <= 0; insn[15:11] <= 0; insn[10:6] <= 1; insn[5:1] <= 5'b10000; insn[0] <= 0;
                        end
                        32'h13C: begin
                            insn <= 32'hFFFFFFFF;
                        end
                        32'h13D: begin //out to imm from r1
                            insn[31:25] <= 31; insn[24:21] <= 4'b1110; insn[20:16] <= 0; insn[15:11] <= 1; insn[10:6] <= 0; insn[5:1] <= 5'b10000; insn[0] <= 0;
                        end
                        32'h13E: begin
                            insn <= 32'hD;
                        end
                        32'h13F: begin //out to imm from r1
                            insn[31:25] <= 31; insn[24:21] <= 4'b1110; insn[20:16] <= 0; insn[15:11] <= 1; insn[10:6] <= 0; insn[5:1] <= 5'b10000; insn[0] <= 0;
                        end
                        32'h140: begin
                            insn <= 32'hF;
                        end
                        32'h141: begin //out to imm from r1
                            insn[31:25] <= 31; insn[24:21] <= 4'b1110; insn[20:16] <= 0; insn[15:11] <= 1; insn[10:6] <= 0; insn[5:1] <= 5'b10000; insn[0] <= 0;
                        end
                        32'h142: begin
                            insn <= 32'h11;
                        end
                        32'h143: begin //out to imm from r1
                            insn[31:25] <= 31; insn[24:21] <= 4'b1110; insn[20:16] <= 0; insn[15:11] <= 1; insn[10:6] <= 0; insn[5:1] <= 5'b10000; insn[0] <= 0;
                        end
                        32'h144: begin
                            insn <= 32'hE;
                        end
                        32'h145: begin //in from imm to 30
                            insn[31:25] <= 30; insn[24:21] <= 4'b1110; insn[20:16] <= 0; insn[15:11] <= 0; insn[10:6] <= 30; insn[5:1] <= 5'b10000; insn[0] <= 0;
                        end
                        32'h146: begin
                            insn <= 32'hA;
                        end
                        32'h5E771E7D: begin //br_pos to 0
                            insn[31:25] <= 24; insn[24:21] <= 4'b0101; insn[20:16] <= 0; insn[15:11] <= 0; insn[10:6] <= 0; insn[5:1] <= 5'b00000; insn[0] <= 0;
                        end
                        32'h5E771E7E: begin //ret_neg
                            insn[31:25] <= 27; insn[24:21] <= 4'b0100; insn[20:16] <= 0; insn[15:11] <= 0; insn[10:6] <= 0; insn[5:1] <= 5'b00000; insn[0] <= 0;
                        end
                        default: begin
                            insn <= 32'b0;
                        end
                endcase
        end
endmodule


//assembly test
module main();
    wire [31:0] insn;
    wire [31:0] lr, sp, st, pc;
    wire [127:0] pins;

    reg clk;
    reg rst;

    test_processor_assembly proc0(lr, sp, st, pc, pins, insn, clk, rst);

    test_rom rom0(insn, pc);

    assign pins[15:0] = 16'h1488;

    initial begin
        //insn = 32'b0; //nop
        clk = 0;
        rst = 0;
        $dumpfile("dump.fst");
        $dumpvars(0);
        $dumpon;
    end
    always begin
        integer i;
        //reset
        rst = 0;
        #20;
        rst = 1;
        #20;
        rst = 0;
        #20;

        //clock 128 times
        for(i =0; i < 128; i++) begin
            #20;
            clk = 1;
            #20;
            clk = 0;
        end
        //finish
        $dumpflush;
        $finish;
    end
    /*always begin
        integer i, j, k;
        rst = 0;
        #20;
        rst = 1;
        #20;
        rst = 0;
        #20;
        //insert one mov imm to reg 30 (sp)
        insn[31:25] = 32; insn[24:21] = 4'b1110; insn[20:11] = 0; insn[10:6] = 30; insn[5:1] = 5'b10000; insn[0] = 0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        insn = 32'h14888;
        #20;
        clk = 1;
        #20;
        clk = 0;
         //insert one mov imm to reg 29 (lr)
        insn[31:25] = 32; insn[24:21] = 4'b1110; insn[20:11] = 0; insn[10:6] = 29; insn[5:1] = 5'b10000; insn[0] = 0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        insn = 32'h22888;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one nop
        insn = 32'b0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one nop
        insn = 32'b0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one add 29 and 30 to 30
        insn[31:25] = 13; insn[24:21] = 4'b1110; insn[20:16] = 29; insn[15:11] = 30; insn[10:6] = 30; insn[5:1] = 5'b00000; insn[0] = 0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one add imm1 and imm 2 to 29
        insn[31:25] = 13; insn[24:21] = 4'b1110; insn[20:16] = 0; insn[15:11] = 0; insn[10:6] = 29; insn[5:1] = 5'b11000; insn[0] = 0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        insn = 32'h35942;
        #20;
        clk = 1;
        #20;
        clk = 0;
        insn = 32'hDEADBEAF;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one nop
        insn = 32'b0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one nop
        insn = 32'b0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one mul 29 and 30 to 29 and 30
        insn[31:25] = 17; insn[24:21] = 4'b1110; insn[20:16] = 29; insn[15:11] = 30; insn[10:6] = 29; insn[5:1] = 30; insn[0] = 0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one nop
        insn = 32'b0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one nop
        insn = 32'b0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one xor 29 and 30 to 30
        insn[31:25] = 6; insn[24:21] = 4'b1110; insn[20:16] = 29; insn[15:11] = 30; insn[10:6] = 30; insn[5:1] = 00; insn[0] = 0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one nop
        insn = 32'b0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one nop
        insn = 32'b0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one csr 30 by imm to 29
        insn[31:25] = 11; insn[24:21] = 4'b1110; insn[20:16] = 30; insn[15:11] = 0; insn[10:6] = 29; insn[5:1] = 5'b01000; insn[0] = 0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        insn = 11;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one branch to imm
        insn[31:25] = 24; insn[24:21] = 4'b1110; insn[20:16] = 0; insn[15:11] = 0; insn[10:6] = 0; insn[5:1] = 5'b10000; insn[0] = 0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        insn = 32'h134;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one nop
        insn = 32'b0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one nop
        insn = 32'b0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one brl to 30
        insn[31:25] = 26; insn[24:21] = 4'b1110; insn[20:16] = 30; insn[15:11] = 0; insn[10:6] = 0; insn[5:1] = 5'b00000; insn[0] = 0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one nop
        insn = 32'b0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one nop
        insn = 32'b0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one br_pos to 0
        insn[31:25] = 24; insn[24:21] = 4'b0101; insn[20:16] = 0; insn[15:11] = 0; insn[10:6] = 0; insn[5:1] = 5'b00000; insn[0] = 0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one ret_neg
        insn[31:25] = 27; insn[24:21] = 4'b0100; insn[20:16] = 0; insn[15:11] = 0; insn[10:6] = 0; insn[5:1] = 5'b00000; insn[0] = 0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one str to imm from 30
        insn[31:25] = 29; insn[24:21] = 4'b1110; insn[20:16] = 0; insn[15:11] = 30; insn[10:6] = 0; insn[5:1] = 5'b10000; insn[0] = 0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        insn = 16;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one nop
        insn = 32'b0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one nop
        insn = 32'b0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert mov 29, 30 to 30, 29 (reposition)
        insn[31:25] = 33; insn[24:21] = 4'b1110; insn[20:16] = 29; insn[15:11] = 30; insn[10:6] = 30; insn[5:1] = 29; insn[0] = 0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one nop
        insn = 32'b0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one nop
        insn = 32'b0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert out 30 to 29
        insn[31:25] = 31; insn[24:21] = 4'b1110; insn[20:16] = 29; insn[15:11] = 30; insn[10:6] = 0; insn[5:1] = 0; insn[0] = 0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        //insert one ldr from imm to 30
        insn[31:25] = 28; insn[24:21] = 4'b1110; insn[20:16] = 0; insn[15:11] = 0; insn[10:6] = 30; insn[5:1] = 5'b10000; insn[0] = 0;
        #20;
        clk = 1;
        #20;
        clk = 0;
        insn = 16;
        #20;
        clk = 1;
        #20;
        clk = 0;
        for(i = 0; i < 32; i++) begin //insert 32 nops
            insn = 32'b0;
            #20;
            clk = 1;
            #20;
            clk = 0;
        end
        $dumpflush;
        $finish;
    end*/
endmodule

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
                    #20;
                    if(ql != tl || qh != th) $display("error in op %h for a = %h, b = %h (test: l = %h, h = %h; got l = %h, h = %h)", o, x1, x2, tl, th, ql, qh);
                end
            end
            $display("-> %h",i);
        end
        $dumpflush;
        $finish;
    end
endmodule*/
