`timescale 1 ns / 100 ps

`include "gpio_mux.v"
`include "gpio.v"

module test_periph_assembly(pins, sys_w_addr, sys_r_addr, sys_w_line, sys_r_line, sys_w, sys_r, rst, clk);
    inout [127:0] pins; //our system will have 128 pins

    //peripheral bus
    input [31:0] sys_w_addr;
    input [31:0] sys_r_addr;
    input [31:0] sys_w_line;
    output wire [31:0] sys_r_line;
    input sys_w;
    input sys_r;

    //generic
    input clk;
    input rst;

    /*devices registry
     * 1. address
     *  00000 - 00001 - not assigned (guard band) (0x00 - 0x01)
     *  00010 - 00011 - gpio_mux pins 31:0 (0x02 - 0x03)
     *  00100 - 00101 - gpio_mux pins 63:32 (0x04 - 0x05)
     *  00110 - 00111 - gpio_mux pins 95:64 (0x06 - 0x07)
     *  01000 - 01001 - gpio_mux pins 127:96 (0x08 - 0x09)
     *  01010 - 01011 - gpio chip 1 (31:0) (0x0A - 0x0B)
     *  01100 - 01101 - gpio chip 2 (63:32) (0x0C - 0x0D)
     *  01110 - 01111 - gpio chip 3 (95:64) (0x0E - 0x0F)
     *  10000 - 10001 - gpio chip 4 (127:96) (0x10 - 0x11)
     * ---------------------------------------------
     * 2. pins
     *  all pins have gpio chip as function 0
     * ---------------------------------------------
     */

    wire [31:0] g0_out, g1_out, g2_out, g3_out;
    wire [31:0] g0_in, g1_in, g2_in, g3_in;
    wire [31:0] g0_dir, g1_dir, g2_dir, g3_dir;
    gpio chip0(g0_out, g0_in, g0_dir, 32'hA, sys_w_addr, sys_r_addr, sys_w_line, sys_r_line, sys_w, sys_r, rst, clk);
    gpio chip1(g1_out, g1_in, g1_dir, 32'hC, sys_w_addr, sys_r_addr, sys_w_line, sys_r_line, sys_w, sys_r, rst, clk);
    gpio chip2(g2_out, g2_in, g2_dir, 32'hE, sys_w_addr, sys_r_addr, sys_w_line, sys_r_line, sys_w, sys_r, rst, clk);
    gpio chip3(g3_out, g3_in, g3_dir, 32'h10, sys_w_addr, sys_r_addr, sys_w_line, sys_r_line, sys_w, sys_r, rst, clk);

    //here comes all other peripherals

    wire [31:0] mx0_f0_out, mx0_f1_out, mx0_f2_out, mx0_f3_out;
    wire [31:0] mx1_f0_out, mx1_f1_out, mx1_f2_out, mx1_f3_out;
    wire [31:0] mx2_f0_out, mx2_f1_out, mx2_f2_out, mx2_f3_out;
    wire [31:0] mx3_f0_out, mx3_f1_out, mx3_f2_out, mx3_f3_out;

    wire [31:0] mx0_f0_in, mx0_f1_in, mx0_f2_in, mx0_f3_in;
    wire [31:0] mx1_f0_in, mx1_f1_in, mx1_f2_in, mx1_f3_in;
    wire [31:0] mx2_f0_in, mx2_f1_in, mx2_f2_in, mx2_f3_in;
    wire [31:0] mx3_f0_in, mx3_f1_in, mx3_f2_in, mx3_f3_in;

    wire [31:0] mx0_f0_dir, mx0_f1_dir, mx0_f2_dir, mx0_f3_dir;
    wire [31:0] mx1_f0_dir, mx1_f1_dir, mx1_f2_dir, mx1_f3_dir;
    wire [31:0] mx2_f0_dir, mx2_f1_dir, mx2_f2_dir, mx2_f3_dir;
    wire [31:0] mx3_f0_dir, mx3_f1_dir, mx3_f2_dir, mx3_f3_dir;

    gpio_mux mx0(pins[31:0], mx0_f0_in, mx0_f1_in, mx0_f2_in, mx0_f3_in, mx0_f0_out, mx0_f1_out, mx0_f2_out, mx0_f3_out, mx0_f0_dir, mx0_f1_dir, mx0_f2_dir, mx0_f3_dir, 32'h2, sys_w_addr, sys_r_addr, sys_w_line, sys_r_line, sys_w, sys_r, rst, clk);
    gpio_mux mx1(pins[63:32], mx1_f0_in, mx1_f1_in, mx1_f2_in, mx1_f3_in, mx1_f0_out, mx1_f1_out, mx1_f2_out, mx1_f3_out, mx1_f0_dir, mx1_f1_dir, mx1_f2_dir, mx1_f3_dir, 32'h4, sys_w_addr, sys_r_addr, sys_w_line, sys_r_line, sys_w, sys_r, rst, clk);
    gpio_mux mx2(pins[95:64], mx2_f0_in, mx2_f1_in, mx2_f2_in, mx2_f3_in, mx2_f0_out, mx2_f1_out, mx2_f2_out, mx2_f3_out, mx2_f0_dir, mx2_f1_dir, mx2_f2_dir, mx2_f3_dir, 32'h6, sys_w_addr, sys_r_addr, sys_w_line, sys_r_line, sys_w, sys_r, rst, clk);
    gpio_mux mx3(pins[127:96], mx3_f0_in, mx3_f1_in, mx3_f2_in, mx3_f3_in, mx3_f0_out, mx3_f1_out, mx3_f2_out, mx3_f3_out, mx3_f0_dir, mx3_f1_dir, mx3_f2_dir, mx3_f3_dir, 32'h8, sys_w_addr, sys_r_addr, sys_w_line, sys_r_line, sys_w, sys_r, rst, clk);

    //here comes function assignments
    assign g0_in = mx0_f0_in, mx0_f0_out = g0_out, mx0_f0_dir = g0_dir;
    assign g1_in = mx1_f0_in, mx1_f0_out = g1_out, mx1_f0_dir = g1_dir;
    assign g2_in = mx2_f0_in, mx2_f0_out = g2_out, mx2_f0_dir = g2_dir;
    assign g3_in = mx3_f0_in, mx3_f0_out = g3_out, mx3_f0_dir = g3_dir;
endmodule
