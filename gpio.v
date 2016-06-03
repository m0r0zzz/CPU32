`timescale 1 ns / 100 ps

module gpio(gpio_out, gpio_in, gpio_dir, addr, sys_w_addr, sys_r_addr, sys_w_line, sys_r_line, sys_w, sys_r, rst, clk);
    //control signals
    input [31:0] gpio_in;
    output wire [31:0] gpio_out;
    output wire [31:0] gpio_dir;

    //address, constant
    input [31:0] addr;

    //peripheral bus
    input [31:0] sys_w_addr;
    input [31:0] sys_r_addr;
    input [31:0] sys_w_line;
    output reg [31:0] sys_r_line;
    input sys_w;
    input sys_r;

    //generic
    input clk;
    input rst;

    //control regs
    reg [31:0] direction; // 1 for out, 0 for in
    reg [31:0] value; //default

    assign gpio_out = value;
    assign gpio_dir = direction;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            direction <= 32'b0;
            value <= 32'b0;
            sys_r_line <= 32'bz;
        end
        else begin
            #1;
            if(sys_r) begin //read requested
                if(sys_r_addr[31:1] == addr[31:1]) begin //if r addr is same
                    if(sys_r_addr[0]) begin //high part, direction
                        sys_r_line <= direction;
                    end else begin //low part, read value
                        sys_r_line <= gpio_in;
                    end
                end else begin
                    sys_r_line = 32'bz; //don't scramble other devices
                end
            end else begin
                sys_r_line = 32'bz; //minimize power consumption
            end
            if(sys_w) begin //write requested
                if(sys_w_addr[31:1] == addr[31:1]) begin //if w addr is same
                    if(sys_w_addr[0]) begin //high part, direction
                        direction <= sys_w_line;
                    end else begin //low part, write value
                        value <= sys_w_line;
                    end
                end
            end
        end
    end
endmodule
