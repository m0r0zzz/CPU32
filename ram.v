`timescale 1 ns / 100 ps

module ram(r_addr, w_addr, r_line, w_line, read, write, wrdy, rrdy, exc, clk);
    input [31:0] r_addr;
    input [31:0] w_addr;
    input [31:0] w_line;
    input        read;
    input        write;
    input        clk;

    output [31:0] r_line;
    reg    [31:0] r_line;
    output        exc;
    reg           exc;
    output        wrdy, rrdy;
    reg           wrdy, rrdy;

    //memory
    parameter mem_size = 1024; //4kb, 4b/w

    reg [31:0] mem [mem_size:0];

    integer i;

    /*initial begin
        for(i = 0; i < mem_size; i=i+1) begin
            mem[i] = 32'b0;
        end
        r_line = 32'b0;
        exc = 1'b0;
        wrdy = 1'b0;
        rrdy = 1'b0;
    end*/

    always @(posedge clk) begin
        if(wrdy) wrdy <= 1'b0;
        if(rrdy) rrdy <= 1'b0;

        if(read & !rrdy ) begin
            if(r_addr >= mem_size) begin
                r_line <= 32'b0;
                exc <= 1'b1;
            end
            else begin
                r_line <= mem[r_addr];
                rrdy <= 1'b1;
                exc <= 1'b0;
            end
        end
        else r_line <= 32'bz;

        if(write && !wrdy) begin
            if(w_addr >= mem_size) exc <= 1'b1;
            else begin
                mem[w_addr] <= w_line;
                wrdy <= 1'b1;
                exc <= 1'b0;
            end
        end
    end
endmodule

module emb_ram(r_addr, w_addr, r_line, w_line, read, write, exc, clk);
    input [31:0] r_addr;
    input [31:0] w_addr;
    input [31:0] w_line;
    input        read;
    input        write;
    input        clk;

    output [31:0] r_line;
    reg    [31:0] r_line;
    output        exc;
    reg           exc;

    //memory
    parameter mem_size = 1024; //4kb, 4b/w

    reg [31:0] mem [mem_size:0];

    integer i;

    /*initial begin
        for(i = 0; i < mem_size; i=i+1) begin
            mem[i] = 32'b0;
        end
        r_line = 32'b0;
        exc = 1'b0;
    end*/

     always @(posedge clk) begin //??????????
        #1;
        if(read) begin
            if(r_addr >= mem_size) begin
                r_line <= 32'b0;
                exc <= 1'b1;
            end
            else begin
                r_line <= mem[r_addr];
                exc <= 1'b0;
            end
        end
        else r_line <= 32'bz;

        if(write) begin
            if(w_addr >= mem_size) exc <= 1'b1;
            else begin
                mem[w_addr] <= w_line;
                exc <= 1'b0;
            end
        end
    end
endmodule
