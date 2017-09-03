`timescale 1 ns / 1 ps

module spi_master(miso, mosi, sck, miso_dir, mosi_dir, sck_dir, addr, sys_w_addr, sys_r_addr, sys_w_line, sys_r_line, sys_w, sys_r, rst, clk);
    input miso;
    output reg mosi;
    output reg sck;

    output wire miso_dir = 1'b0; //input
    output wire mosi_dir = 1'b1; //output
    output wire sck_dir = 1'b1; //output

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

    //output buffer, maps to reg 0 (low) write
    reg [31:0] out_buf;
    //output shift reg
    reg [31:0] out;

    //fill markers
    reg out_full;
    reg out_buf_full;

    //input buffer, maps to reg 0 (low) read
    reg [31:0] in_buf;
    //input shift reg;
    reg [31:0] in;

    //fill markers
    reg in_full;
    reg in_buf_full;

    //all buffer is filled but master requests another tx/rx session
    reg in_error;

    //control register, maps to reg 1 (high) read/write
    reg [31:0] control;

    //counts recv/send bits
    reg [5:0] recv_bits_counter
    reg [5:0] send_bits_counter;

    reg [1:0] recv_bits_ctl;
    reg [1:0] send_bits_ctl;

    reg busy;

    //counts clocks, for processor clock division
    reg [15:0] clk_counter;

    //clock polarity, 0 to start from 0 (active 1) and 1 to start from 1 (active 0)
    reg clk_polarity;

    //clock phase, 0 to clock miso on passive->active transition and change mosi on active->passive transition, 1 to invert;
    reg clk_phase;

    //clock state, 0 for active and 1 for passive
    reg clk_state;

    //clock compare value, 0 for 1, 1 for 2, 2 for 4 ... 15 for 32768
    reg [3:0] clk_compare;

    //set 1 to enable clock output, it will drop it to 0 when needed clock phase is in effect
    reg clk_enable;

    //suspend protocol execution if 0
    wire enable = control[0];

    /* control register bits allocation
     *  0  - enable signal
     *    -
     */

    always @(posedge clk) begin //sck

    end

    always @(posedge clk or posedge rst) begin //control and bus utility
        if(rst) begin
            sys_r_line <= 32'bz;
            out_buf <= 32'b0; out <= 32'b0;
            in_buf <= 32'b0; in <= 32'b0;
            out_full <= 0; out_buf_full <= 0; in_full <= 0; in_buf_full <= 0; in_error <= 0;
            recv_bits_counter <= 0; send_bits_counter <= 0; recv_bits_ctl <= 0; send_bits_ctl <= 0;
            clk_counter <= 16'b0;
        end
    end

    always @(posedge clk_state) //transmission/reception

    end

endmodule
