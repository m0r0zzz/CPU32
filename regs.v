
module reg32_2x2(rd0, rd1, ra0, ra1, wa0, wa1, wd0, wd1, read, write, clk, rst);
    parameter addrsize = 5;
    parameter regsnum = 32;

    input [addrsize-1:0] ra0, ra1;
    input [addrsize-1:0] wa0, wa1;

    input [31:0] wd0, wd1;

    input [1:0] read, write;

    input clk, rst;

    output reg [31:0] rd0, rd1;

    reg [31:0] regs [regsnum-1:0];

    always @(posedge clk or rst) begin
        if(rst) begin
            rd0 <= 0;
            rd1 <= 0;
            integer i;
            for( i = 0; i < regsnum; i++) regs[i] <= 0;
        end

        if(read[0]) rd0 <= regs[ra0];
        if(read[1]) rd1 <= regs[ra1];

        if(write[0]) regs[wa0] <= wd0;
        if(write[1]) regs[wa1] <= wd1;
    end
end
