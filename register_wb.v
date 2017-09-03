`timescale 1 ns / 1 ps

module register_wb( write, wr1, wr2, wa1, wa2, r1, r2, a1, a2, op, proceed, clk, rst);
    input [31:0] r1, r2;
    input [4:0] a1, a2;

    input [3:0] op;

    input proceed;

    input clk, rst;

    output reg [31:0] wr1, wr2;
    output reg [4:0] wa1, wa2;
    output reg [1:0] write;

    wire [3:0] inner_op;

    assign inner_op = proceed ? op : 4'b0;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            wr1 = 32'b0; wr2 = 32'b0;
            wa1 = 5'b0; wa2 = 5'b0;
            write = 2'b00;
        end
        else begin
            //write = 2'b00;
            case(inner_op)
                0: write <= 2'b00; //NOP
                1: begin //write r1 to addr a1
                    wr1 <= r1;
                    wa1 <= a1;
                    write = 2'b01;
                    end
                2: begin //write r1 to addr a2
                    wr1 <= r1;
                    wa1 <= a2;
                    write = 2'b01;
                    end
                3: begin //write r1 to addr r2
                    wr1 <= r1;
                    wa1 <= r2[4:0];
                    write = 2'b01;
                    end
                4: begin //write r2 to addr a1
                    wr1 <= r2;
                    wa1 <= a1;
                    write = 2'b01;
                    end
                5: begin //write r2 to addr a2
                    wr1 <= r2;
                    wa1 <= a2;
                    write = 2'b01;
                    end
                6: begin //write r2 to addr r1
                    wr1 <= r2;
                    wa1 <= r1[4:0];
                    write = 2'b01;
                    end
                7: begin //write r2, r1 to a2, a1
                    wr1 <= r1; wr2 <= r2;
                    wa1 <= a1; wa2 <= a2;
                    write = 2'b11;
                    end
                8: begin //write r1, r2 to a2, a1
                    wr1 <= r1; wr2 <= r2;
                    wa1 <= a2; wa2 <= a1;
                    write = 2'b11;
                    end
            endcase
        end
    end
endmodule

