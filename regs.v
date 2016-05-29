
`timescale 1 ns / 100 ps

module reg32_2x2_pc(rd0, rd1, ra0, ra1, wa0, wa1, wd0, wd1, read, write, clk, rst, lrout, spout, stout, pcout, stin, stwr, pcincr);
    parameter addrsize = 5;
    parameter regsnum = 32;

    input [addrsize-1:0] ra0, ra1;
    input [addrsize-1:0] wa0, wa1;

    input [31:0] wd0, wd1;

    input [1:0] read, write;

    input clk, rst;

    output wire [31:0] rd0, rd1;

    reg [31:0] regs [regsnum-1:0];

    output wire [31:0] lrout, spout, stout, pcout;
    input [31:0] stin;
    input stwr, pcincr;

    assign pcout = regs[31];
    assign lrout = regs[29];
    assign spout = regs[30];
    assign stout = regs[28];

    assign rd0 = regs[ra0];
    assign rd1 = regs[ra1];

    always @(posedge clk or rst) begin
        #2;
        if(rst) begin
            integer i;
            /*rd0 <= 0;
            rd1 <= 0;*/
            for( i = 0; i < regsnum; i++) regs[i] <= 0;
        end

        //if(read[0]) rd0 <= regs[ra0];
        //if(read[1]) rd1 <= regs[ra1];

        if(write[0]) regs[wa0] <= wd0;
        if(write[1]) regs[wa1] <= wd1;

        if(stwr) regs[28] = stin;
        if(pcincr) regs[31] = regs[31] + 1;

    end
endmodule
