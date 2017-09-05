
`timescale 1 ns / 1 ps

module reg32_2x2_pc(rd0, rd1, ra0, ra1, wa0, wa1, wd0, wd1, read, write, clk, rst, lrout, spout, stout, pcout, stin, stwr, pcincr);
    parameter addrsize = 5;
    parameter gpregsnum = 28;
    
    parameter st_addr = 28;
    parameter lr_addr = 29;
    parameter sp_addr = 30;
    parameter pc_addr = 31;

    input [addrsize-1:0] ra0, ra1;
    input [addrsize-1:0] wa0, wa1;

    input [31:0] wd0, wd1;

    input [1:0] read, write;

    input clk, rst;

    output reg [31:0] rd0, rd1;

    reg [31:0] regs [gpregsnum-1:0];
    reg [31:0] lr, sp, st, pc;
    
    output wire [31:0] lrout, spout, stout, pcout;
    input [31:0] stin;
    input stwr, pcincr;

    assign pcout = pc;
    assign lrout = lr;
    assign spout = sp;
    assign stout = st;
    
    always @* begin
    	case(ra0)
    		st_addr: rd0 = st;
    		lr_addr: rd0 = lr;
    		sp_addr: rd0 = sp;
    		pc_addr: rd0 = pc;
    		default: rd0 = regs[ra0];
    	endcase
    	case(ra1)
    		st_addr: rd1 = st;
    		lr_addr: rd1 = lr;
    		sp_addr: rd1 = sp;
    		pc_addr: rd1 = pc;
    		default: rd1 = regs[ra1];
    	endcase
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            /*rd0 <= 0;
            rd1 <= 0;*/
            regs[0] <= 32'b0;
            lr <= 32'b0;
            pc <= 32'b0;
            sp <= 32'b0;
            st <= 32'b0;
        end
        else begin
            if(write[0]) begin
            	case(wa0)
            		st_addr: st <= wd0;
            		lr_addr: lr <= wd0;
            		sp_addr: sp <= wd0;
            		pc_addr: pc <= wd0;
            		default: regs[wa0] <= wd0;
            	endcase
            end
            if(write[1]) begin
            	case(wa1)
            		st_addr: st <= wd1;
            		lr_addr: lr <= wd1;
            		sp_addr: sp <= wd1;
            		pc_addr: pc <= wd1;
            		default: regs[wa1] <= wd1;
            	endcase
            end

            if(stwr) st <= stin;
            if(pcincr) pc <= pc + 1;
        end
    end
endmodule
