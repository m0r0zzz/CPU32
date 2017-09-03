`timescale 1 ns / 1 ps

`include "test_processor_assembly.v"

module test_rom(word, addr);
        input [31:0] addr;

        output wire [31:0] word;

        reg [31:0] insn;
        assign word = insn;

        always @(addr) begin
                //#1;
                case(addr)
                        /*32'h0: begin //(mov)nop reg 29 to reg 30
                            insn[31:25] = 00; insn[24:21] = 4'b1110; insn[20:16] = 29; insn[15:11] = 0; insn[10:6] = 30; insn[5:1] = 0; insn[0] = 0;
                        end*/
                        32'h0: begin //movs imm to reg 30 (sp)
                            insn[31:25] = 33; insn[24:21] = 4'b1110; insn[20:11] = 0; insn[10:6] = 30; insn[5:1] = 5'b10000; insn[0] = 0;
                        end
                        32'h1: begin
                            insn = 32'h14888;
                        end
                        32'h3: begin //movs imm to reg 29 (lr)
                            insn[31:25] = 33; insn[24:21] = 4'b1110; insn[20:11] = 0; insn[10:6] = 29; insn[5:1] = 5'b10000; insn[0] = 0;
                        end
                        32'h4: begin
                            insn = 32'h22888;
                        end
                        32'h5: begin //add 29 and 30 to 30
                            insn[31:25] = 14; insn[24:21] = 4'b1110; insn[20:16] = 29; insn[15:11] = 30; insn[10:6] = 30; insn[5:1] = 5'b00000; insn[0] = 0;
                        end
                        32'h6: begin //add imm1 and imm2 to 29
                            insn[31:25] = 14; insn[24:21] = 4'b1110; insn[20:16] = 0; insn[15:11] = 0; insn[10:6] = 29; insn[5:1] = 5'b11000; insn[0] = 0;
                        end
                        32'h7: begin
                            insn = 32'h35942;
                        end
                        32'h8: begin
                            insn = 32'hDEADBEAF;
                        end
                        32'h9: begin //mul 29 and 30 to 29 and 30
                            insn[31:25] = 18; insn[24:21] = 4'b1110; insn[20:16] = 29; insn[15:11] = 30; insn[10:6] = 29; insn[5:1] = 30; insn[0] = 0;
                        end
                        32'hA: begin //xor 29 and 30 to 30
                            insn[31:25] = 6; insn[24:21] = 4'b1110; insn[20:16] = 29; insn[15:11] = 30; insn[10:6] = 30; insn[5:1] = 00; insn[0] = 0;
                        end
                        32'hB: begin //csr 30 by imm to 29
                            insn[31:25] = 12; insn[24:21] = 4'b1110; insn[20:16] = 30; insn[15:11] = 0; insn[10:6] = 29; insn[5:1] = 5'b01000; insn[0] = 0;
                        end
                        32'hC: begin
                            insn = 11;
                        end
                        32'hD: begin //branch to imm
                            insn[31:25] = 25; insn[24:21] = 4'b1110; insn[20:16] = 0; insn[15:11] = 0; insn[10:6] = 0; insn[5:1] = 5'b10000; insn[0] = 0;
                        end
                        32'hE: begin
                            insn = 32'h132;
                        end
                        32'h132: begin //out 29 to 30
                            insn[31:25] = 32; insn[24:21] = 4'b1110; insn[20:16] = 30; insn[15:11] = 29; insn[10:6] = 0; insn[5:1] = 0; insn[0] = 0;
                        end
                        32'h133: begin //out 30 to 29
                            insn[31:25] = 32; insn[24:21] = 4'b1110; insn[20:16] = 29; insn[15:11] = 30; insn[10:6] = 0; insn[5:1] = 0; insn[0] = 0;
                        end
                        32'h134: begin //brl to 30
                            insn[31:25] = 27; insn[24:21] = 4'b1110; insn[20:16] = 30; insn[15:11] = 0; insn[10:6] = 0; insn[5:1] = 5'b00000; insn[0] = 0;
                        end
                        32'h135: begin //str to imm from 30
                            insn[31:25] = 30; insn[24:21] = 4'b1110; insn[20:16] = 0; insn[15:11] = 30; insn[10:6] = 0; insn[5:1] = 5'b10000; insn[0] = 0;
                        end
                        32'h136: begin
                            insn = 16;
                        end
                        32'h137: begin //mov 29, 30 to 30, 29
                            insn[31:25] = 34; insn[24:21] = 4'b1110; insn[20:16] = 29; insn[15:11] = 30; insn[10:6] = 30; insn[5:1] = 29; insn[0] = 0;
                        end
                        32'h138: begin //out 30 to 29
                            insn[31:25] = 32; insn[24:21] = 4'b1110; insn[20:16] = 29; insn[15:11] = 30; insn[10:6] = 0; insn[5:1] = 0; insn[0] = 0;
                        end
                        32'h139: begin //ldr from imm to 30
                            insn[31:25] = 29; insn[24:21] = 4'b1110; insn[20:16] = 0; insn[15:11] = 0; insn[10:6] = 30; insn[5:1] = 5'b10000; insn[0] = 0;
                        end
                        32'h13A: begin
                            insn = 16;
                        end
                        32'h13B:  begin //movs imm to r1
                            insn[31:25] = 33; insn[24:21] = 4'b1110; insn[20:16] = 0; insn[15:11] = 0; insn[10:6] = 1; insn[5:1] = 5'b10000; insn[0] = 0;
                        end
                        32'h13C: begin
                            insn = 32'hFFFFFFFF;
                        end
                        32'h13D: begin //out to imm from r1
                            insn[31:25] = 32; insn[24:21] = 4'b1110; insn[20:16] = 0; insn[15:11] = 1; insn[10:6] = 0; insn[5:1] = 5'b10000; insn[0] = 0;
                        end
                        32'h13E: begin
                            insn = 32'hD;
                        end
                        32'h13F: begin //out to imm from r1
                            insn[31:25] = 32; insn[24:21] = 4'b1110; insn[20:16] = 0; insn[15:11] = 1; insn[10:6] = 0; insn[5:1] = 5'b10000; insn[0] = 0;
                        end
                        32'h140: begin
                            insn = 32'hF;
                        end
                        32'h141: begin //out to imm from r1
                            insn[31:25] = 32; insn[24:21] = 4'b1110; insn[20:16] = 0; insn[15:11] = 1; insn[10:6] = 0; insn[5:1] = 5'b10000; insn[0] = 0;
                        end
                        32'h142: begin
                            insn = 32'h11;
                        end
                        32'h143: begin //out to imm from r1
                            insn[31:25] = 32; insn[24:21] = 4'b1110; insn[20:16] = 0; insn[15:11] = 1; insn[10:6] = 0; insn[5:1] = 5'b10000; insn[0] = 0;
                        end
                        32'h144: begin
                            insn = 32'hE;
                        end
                        32'h145: begin //in from imm to 30
                            insn[31:25] = 31; insn[24:21] = 4'b1110; insn[20:16] = 0; insn[15:11] = 0; insn[10:6] = 30; insn[5:1] = 5'b10000; insn[0] = 0;
                        end
                        32'h146: begin
                            insn = 32'hA;
                        end
                        32'h5E771E7D: begin //br_pos to 0
                            insn[31:25] = 25; insn[24:21] = 4'b0101; insn[20:16] = 0; insn[15:11] = 0; insn[10:6] = 0; insn[5:1] = 5'b00000; insn[0] = 0;
                        end
                        32'h5E771E7E: begin //ret_neg
                            insn[31:25] = 28; insn[24:21] = 4'b0100; insn[20:16] = 0; insn[15:11] = 0; insn[10:6] = 0; insn[5:1] = 5'b00000; insn[0] = 0;
                        end
                        default: begin
                            insn = 32'b0;
                        end
                endcase
        end
endmodule

module fib32_rom(word, addr);
        input [31:0] addr;
        output reg [31:0] word;

        always @* begin
                #1;
                case(addr)
                        32'h0: begin //movs 0x00 -> r0
                                word[31:25] = 33; word[24:21] = 4'b1110; word[20:16] = 0; word[15:11] = 0; word[10:6] = 0; word[5:1] = 5'b10000; word[0] = 0;
                        end
                        32'h1: begin
                                word = 32'h0;
                        end
                        32'h2: begin //movs 0xFFFFFFFF -> r1
                                word[31:25] = 33; word[24:21] = 4'b1110; word[20:16] = 0; word[15:11] = 0; word[10:6] = 1; word[5:1] = 5'b10000; word[0] = 0;
                        end
                        32'h3: begin
                                word = 32'hFFFFFFFF;
                        end
                        32'h4: begin //movs r0 -> r2
                                word[31:25] = 33; word[24:21] = 4'b1110; word[20:16] = 0; word[15:11] = 0; word[10:6] = 2; word[5:1] = 5'b00000; word[0] = 0;
                        end
                        32'h5: begin //movs 0x01 -> r3
                                word[31:25] = 33; word[24:21] = 4'b1110; word[20:16] = 0; word[15:11] = 0; word[10:6] = 3; word[5:1] = 5'b10000; word[0] = 0;
                        end
                        32'h6: begin
                                word = 32'h1;
                        end
                        32'h7: begin //movs 0x0C -> r5
                                word[31:25] = 33; word[24:21] = 4'b1110; word[20:16] = 0; word[15:11] = 0; word[10:6] = 5; word[5:1] = 5'b10000; word[0] = 0;
                        end
                        32'h8: begin
                                word = 32'hC;
                        end
                        32'h9: begin //movs 0x100 -> r6
                                word[31:25] = 33; word[24:21] = 4'b1110; word[20:16] = 0; word[15:11] = 0; word[10:6] = 6; word[5:1] = 5'b10000; word[0] = 0;
                        end
                        32'hA: begin
                                word = 32'h100;
                        end
                        32'hB: begin //movs -0x03 -> r7
                                word[31:25] = 33; word[24:21] = 4'b1110; word[20:16] = 0; word[15:11] = 0; word[10:6] = 7; word[5:1] = 5'b10000; word[0] = 0;
                        end
                        32'hC: begin
                                word = 32'hFFFFFFFD;
                        end
                        32'hD: begin //out r1 -> 0x0D
                                word[31:25] = 32; word[24:21] = 4'b1110; word[20:16] = 0; word[15:11] = 1; word[10:6] = 0; word[5:1] = 5'b10000; word[0] = 0;
                        end
                        32'hE: begin
                                word = 32'hD;
                        end
                        32'hF: begin //out r3 -> [r5]
                                word[31:25] = 32; word[24:21] = 4'b1110; word[20:16] = 5; word[15:11] = 3; word[10:6] = 0; word[5:1] = 5'b00000; word[0] = 0;
                        end
                        32'h10: begin //brl [r6]
                                word[31:25] = 27; word[24:21] = 4'b1110; word[20:16] = 6; word[15:11] = 0; word[10:6] = 0; word[5:1] = 5'b00000; word[0] = 0;
                        end
                        32'h11: begin //out_lo r4 -> [r5]
                                word[31:25] = 32; word[24:21] = 4'b0011; word[20:16] = 5; word[15:11] = 4; word[10:6] = 0; word[5:1] = 5'b00000; word[0] = 0;
                        end
                        32'h12: begin //rbr_lo pc+r7
                                word[31:25] = 26; word[24:21] = 4'b0011; word[20:16] = 7; word[15:11] = 0; word[10:6] = 0; word[5:1] = 5'b00000; word[0] = 0;
                        end
                        32'h13: begin //br r0
                                word[31:25] = 25; word[24:21] = 4'b1110; word[20:16] = 0; word[15:11] = 0; word[10:6] = 0; word[5:1] = 5'b00000; word[0] = 0;
                        end
                        //fib()
                        32'h100: begin //add r2, r3 -> r4
                                word[31:25] = 14; word[24:21] = 4'b1110; word[20:16] = 2; word[15:11] = 3; word[10:6] = 4; word[5:1] = 5'b00000; word[0] = 0;
                        end
                        32'h101: begin //mov r3,r4 -> r2, r3
                                word[31:25] = 34; word[24:21] = 4'b1110; word[20:16] = 3; word[15:11] = 4; word[10:6] = 2; word[5:1] = 3; word[0] = 0;
                        end
                        32'h102: begin //ret
                                word[31:25] = 28; word[24:21] = 4'b1110; word[20:16] = 0; word[15:11] = 0; word[10:6] = 0; word[5:1] = 5'b00000; word[0] = 0;
                        end
                        default: begin //nop
                                word = 32'h0;
                        end
                endcase
        end
endmodule

//assembly test
module main();
    wire [31:0] insn;
    wire [31:0] lr, sp, st, pc;
    wire [31:0] pins0, pins1, pins2, pins3;

    reg clk;
    reg rst;

    test_processor_assembly proc0(lr, sp, st, pc, {pins3, pins2, pins1, pins0}, insn, clk, rst);

    test_rom rom0(insn, pc);

    assign pins0[15:0] = 16'h1488;

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
        for(i =0; i < 1024+128; i++) begin
            #20;
            clk = 1;
            #20;
            clk = 0;
        end
        //finish
        $dumpflush;
        $finish;
    end
endmodule


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
