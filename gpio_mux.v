`timescale 1 ns / 1 ps

module gpio_mux(pins, func0_in, func1_in, func2_in, func3_in, func0_out, func1_out, func2_out, func3_out, func0_dir, func1_dir, func2_dir, func3_dir, addr, sys_w_addr, sys_r_addr, sys_w_line, sys_r_line, sys_w, sys_r, rst, clk);
    inout [31:0] pins;

    //functions
    //output signals
    input [31:0] func0_out;
    input [31:0] func1_out;
    input [31:0] func2_out;
    input [31:0] func3_out;

    //input signals
    output wire [31:0] func0_in;
    output wire [31:0] func1_in;
    output wire [31:0] func2_in;
    output wire [31:0] func3_in;

    //direction signals, 1 - out, 0 - in
    input [31:0] func0_dir;
    input [31:0] func1_dir;
    input [31:0] func2_dir;
    input [31:0] func3_dir;

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

    //pin control register;
    reg [63:0] control;

    //generate muxes for every pin
    genvar i;
    generate
    for(i = 0; i < 32; i = i + 1) begin : pin_mux
        wire [1:0] pin_control = control[(i*2 + 1):(i*2)];
        wire pin_out = pin_control == 0 ? func0_out[i] : (pin_control == 1 ? func1_out[i] : (pin_control == 2 ? func2_out[i] : func3_out[i]));
        wire pin_dir = pin_control == 0 ? func0_dir[i] : (pin_control == 1 ? func1_dir[i] : (pin_control == 2 ? func2_dir[i] : func3_dir[i]));
        assign pins[i] = pin_dir == 1 ? pin_out : 1'bz;
        assign func0_in[i] = pin_dir == 1 ? pin_out : pins[i];
        assign func1_in[i] = pin_dir == 1 ? pin_out : pins[i];
        assign func2_in[i] = pin_dir == 1 ? pin_out : pins[i];
        assign func3_in[i] = pin_dir == 1 ? pin_out : pins[i];
    end
    endgenerate

    always @(posedge clk or posedge rst) begin
        #1;
        if(rst) begin
            control = 64'b0;
        end
        else begin
            if(sys_r) begin //read requested
                if(sys_r_addr[31:1] == addr[31:1]) begin //if r addr is same
                    if(sys_r_addr[0]) begin //high part
                        sys_r_line = control[63:32];
                    end else begin //low part
                        sys_r_line = control[31:0];
                    end
                end else begin
                    sys_r_line = 32'bz; //don't scramble other devices
                end
            end else begin
                sys_r_line = 32'bz; //minimize power consumption
            end
            if(sys_w) begin //write requested
                if(sys_w_addr[31:1] == addr[31:1]) begin //if w addr is same
                    if(sys_w_addr[0]) begin //high part
                        control[63:32] = sys_w_line;
                    end else begin //low part
                        control[31:0] = sys_w_line;
                    end
                end
            end
        end
    end
endmodule
