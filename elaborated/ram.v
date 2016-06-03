
//
// Verific Verilog Description of module emb_ram
//

module emb_ram (r_addr, w_addr, r_line, w_line, read, write, exc, 
            clk);   // ram.v(63)
    input [31:0]r_addr;   // ram.v(64)
    input [31:0]w_addr;   // ram.v(65)
    output [31:0]r_line;   // ram.v(71)
    input [31:0]w_line;   // ram.v(66)
    input read;   // ram.v(67)
    input write;   // ram.v(68)
    output exc;   // ram.v(73)
    input clk;   // ram.v(69)
    
    wire [31:0]mem;   // ram.v(79)
    
    wire n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, 
        n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, 
        n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, 
        n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, 
        n55, n56, n57, n58, n60, n61, n62, n63, n64, n65, 
        n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, 
        n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, 
        n86, n87, n88, n89, n90, n91, n92, n125, n126, n127, 
        n128, n129, n130, n131, n132, n133, n134, n135, n136, 
        n137, n138, n139, n140, n141, n142, n143, n144, n145, 
        n146, n147, n148, n149, n150, n151, n152, n153, n154, 
        n155, n156, n157, n158, n159, n160, n161, n165;
    
    DualPortRam_11_32 mem_c (.write_enable(n58), .write_address({n47, n48, 
            n49, n50, n51, n52, n53, n54, n55, n56, n57}), 
            .write_data({n15, n16, n17, n18, n19, n20, n21, n22, 
            n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, 
            n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, 
            n43, n44, n45, n46}), .read_address({r_addr[10:0]}), .read_data({mem}));   // ram.v(79)
    LessThan_32u_32u LessThan_5 (.cin(1'b1), .a({32'b00000000000000000000010000000000}), 
            .b({r_addr}), .o(n60));   // ram.v(94)
    assign n61 = n60 ? 1'b0 : mem[31];   // ram.v(98)
    assign n62 = n60 ? 1'b0 : mem[30];   // ram.v(98)
    assign n63 = n60 ? 1'b0 : mem[29];   // ram.v(98)
    assign n64 = n60 ? 1'b0 : mem[28];   // ram.v(98)
    assign n65 = n60 ? 1'b0 : mem[27];   // ram.v(98)
    assign n66 = n60 ? 1'b0 : mem[26];   // ram.v(98)
    assign n67 = n60 ? 1'b0 : mem[25];   // ram.v(98)
    assign n68 = n60 ? 1'b0 : mem[24];   // ram.v(98)
    assign n69 = n60 ? 1'b0 : mem[23];   // ram.v(98)
    assign n70 = n60 ? 1'b0 : mem[22];   // ram.v(98)
    assign n71 = n60 ? 1'b0 : mem[21];   // ram.v(98)
    assign n72 = n60 ? 1'b0 : mem[20];   // ram.v(98)
    assign n73 = n60 ? 1'b0 : mem[19];   // ram.v(98)
    assign n74 = n60 ? 1'b0 : mem[18];   // ram.v(98)
    assign n75 = n60 ? 1'b0 : mem[17];   // ram.v(98)
    assign n76 = n60 ? 1'b0 : mem[16];   // ram.v(98)
    assign n77 = n60 ? 1'b0 : mem[15];   // ram.v(98)
    assign n78 = n60 ? 1'b0 : mem[14];   // ram.v(98)
    assign n79 = n60 ? 1'b0 : mem[13];   // ram.v(98)
    assign n80 = n60 ? 1'b0 : mem[12];   // ram.v(98)
    assign n81 = n60 ? 1'b0 : mem[11];   // ram.v(98)
    assign n82 = n60 ? 1'b0 : mem[10];   // ram.v(98)
    assign n83 = n60 ? 1'b0 : mem[9];   // ram.v(98)
    assign n84 = n60 ? 1'b0 : mem[8];   // ram.v(98)
    assign n85 = n60 ? 1'b0 : mem[7];   // ram.v(98)
    assign n86 = n60 ? 1'b0 : mem[6];   // ram.v(98)
    assign n87 = n60 ? 1'b0 : mem[5];   // ram.v(98)
    assign n88 = n60 ? 1'b0 : mem[4];   // ram.v(98)
    assign n89 = n60 ? 1'b0 : mem[3];   // ram.v(98)
    assign n90 = n60 ? 1'b0 : mem[2];   // ram.v(98)
    assign n91 = n60 ? 1'b0 : mem[1];   // ram.v(98)
    assign n92 = n60 ? 1'b0 : mem[0];   // ram.v(98)
    assign n125 = read ? n60 : exc;   // ram.v(103)
    LessThan_32u_32u LessThan_71 (.cin(1'b1), .a({32'b00000000000000000000010000000000}), 
            .b({w_addr}), .o(n126));   // ram.v(106)
    not (n127, n126) ;   // ram.v(107)
    assign n128 = write ? n126 : n125;   // ram.v(105)
    assign n129 = write ? n127 : 1'b0;   // ram.v(105)
    VERIFIC_DFFRS i77 (.d(n62), .clk(clk), .s(1'b0), .r(1'b0), .q(n131));   // ram.v(91)
    VERIFIC_DFFRS i78 (.d(n63), .clk(clk), .s(1'b0), .r(1'b0), .q(n132));   // ram.v(91)
    VERIFIC_DFFRS i79 (.d(n64), .clk(clk), .s(1'b0), .r(1'b0), .q(n133));   // ram.v(91)
    VERIFIC_DFFRS i80 (.d(n65), .clk(clk), .s(1'b0), .r(1'b0), .q(n134));   // ram.v(91)
    VERIFIC_DFFRS i81 (.d(n66), .clk(clk), .s(1'b0), .r(1'b0), .q(n135));   // ram.v(91)
    VERIFIC_DFFRS i82 (.d(n67), .clk(clk), .s(1'b0), .r(1'b0), .q(n136));   // ram.v(91)
    VERIFIC_DFFRS i83 (.d(n68), .clk(clk), .s(1'b0), .r(1'b0), .q(n137));   // ram.v(91)
    VERIFIC_DFFRS i84 (.d(n69), .clk(clk), .s(1'b0), .r(1'b0), .q(n138));   // ram.v(91)
    VERIFIC_DFFRS i85 (.d(n70), .clk(clk), .s(1'b0), .r(1'b0), .q(n139));   // ram.v(91)
    VERIFIC_DFFRS i86 (.d(n71), .clk(clk), .s(1'b0), .r(1'b0), .q(n140));   // ram.v(91)
    VERIFIC_DFFRS i87 (.d(n72), .clk(clk), .s(1'b0), .r(1'b0), .q(n141));   // ram.v(91)
    VERIFIC_DFFRS i88 (.d(n73), .clk(clk), .s(1'b0), .r(1'b0), .q(n142));   // ram.v(91)
    VERIFIC_DFFRS i89 (.d(n74), .clk(clk), .s(1'b0), .r(1'b0), .q(n143));   // ram.v(91)
    VERIFIC_DFFRS i90 (.d(n75), .clk(clk), .s(1'b0), .r(1'b0), .q(n144));   // ram.v(91)
    VERIFIC_DFFRS i91 (.d(n76), .clk(clk), .s(1'b0), .r(1'b0), .q(n145));   // ram.v(91)
    VERIFIC_DFFRS i92 (.d(n77), .clk(clk), .s(1'b0), .r(1'b0), .q(n146));   // ram.v(91)
    VERIFIC_DFFRS i93 (.d(n78), .clk(clk), .s(1'b0), .r(1'b0), .q(n147));   // ram.v(91)
    VERIFIC_DFFRS i94 (.d(n79), .clk(clk), .s(1'b0), .r(1'b0), .q(n148));   // ram.v(91)
    VERIFIC_DFFRS i95 (.d(n80), .clk(clk), .s(1'b0), .r(1'b0), .q(n149));   // ram.v(91)
    VERIFIC_DFFRS i96 (.d(n81), .clk(clk), .s(1'b0), .r(1'b0), .q(n150));   // ram.v(91)
    VERIFIC_DFFRS i97 (.d(n82), .clk(clk), .s(1'b0), .r(1'b0), .q(n151));   // ram.v(91)
    VERIFIC_DFFRS i98 (.d(n83), .clk(clk), .s(1'b0), .r(1'b0), .q(n152));   // ram.v(91)
    VERIFIC_DFFRS i99 (.d(n84), .clk(clk), .s(1'b0), .r(1'b0), .q(n153));   // ram.v(91)
    VERIFIC_DFFRS i100 (.d(n85), .clk(clk), .s(1'b0), .r(1'b0), .q(n154));   // ram.v(91)
    VERIFIC_DFFRS i101 (.d(n86), .clk(clk), .s(1'b0), .r(1'b0), .q(n155));   // ram.v(91)
    VERIFIC_DFFRS i102 (.d(n87), .clk(clk), .s(1'b0), .r(1'b0), .q(n156));   // ram.v(91)
    VERIFIC_DFFRS i103 (.d(n88), .clk(clk), .s(1'b0), .r(1'b0), .q(n157));   // ram.v(91)
    VERIFIC_DFFRS i104 (.d(n89), .clk(clk), .s(1'b0), .r(1'b0), .q(n158));   // ram.v(91)
    VERIFIC_DFFRS i105 (.d(n90), .clk(clk), .s(1'b0), .r(1'b0), .q(n159));   // ram.v(91)
    VERIFIC_DFFRS i106 (.d(n91), .clk(clk), .s(1'b0), .r(1'b0), .q(n160));   // ram.v(91)
    VERIFIC_DFFRS i107 (.d(n92), .clk(clk), .s(1'b0), .r(1'b0), .q(n161));   // ram.v(91)
    VERIFIC_DFFRS i111 (.d(read), .clk(clk), .s(1'b0), .r(1'b0), .q(n165));   // ram.v(91)
    assign r_line[31] = n165 ? n130 : 1'bz;   // ram.v(91)
    assign r_line[30] = n165 ? n131 : 1'bz;   // ram.v(91)
    assign r_line[29] = n165 ? n132 : 1'bz;   // ram.v(91)
    assign r_line[28] = n165 ? n133 : 1'bz;   // ram.v(91)
    assign r_line[27] = n165 ? n134 : 1'bz;   // ram.v(91)
    assign r_line[26] = n165 ? n135 : 1'bz;   // ram.v(91)
    assign r_line[25] = n165 ? n136 : 1'bz;   // ram.v(91)
    assign r_line[24] = n165 ? n137 : 1'bz;   // ram.v(91)
    assign r_line[23] = n165 ? n138 : 1'bz;   // ram.v(91)
    assign r_line[22] = n165 ? n139 : 1'bz;   // ram.v(91)
    assign r_line[21] = n165 ? n140 : 1'bz;   // ram.v(91)
    assign r_line[20] = n165 ? n141 : 1'bz;   // ram.v(91)
    assign r_line[19] = n165 ? n142 : 1'bz;   // ram.v(91)
    assign r_line[18] = n165 ? n143 : 1'bz;   // ram.v(91)
    assign r_line[17] = n165 ? n144 : 1'bz;   // ram.v(91)
    assign r_line[16] = n165 ? n145 : 1'bz;   // ram.v(91)
    assign r_line[15] = n165 ? n146 : 1'bz;   // ram.v(91)
    assign r_line[14] = n165 ? n147 : 1'bz;   // ram.v(91)
    assign r_line[13] = n165 ? n148 : 1'bz;   // ram.v(91)
    assign r_line[12] = n165 ? n149 : 1'bz;   // ram.v(91)
    assign r_line[11] = n165 ? n150 : 1'bz;   // ram.v(91)
    assign r_line[10] = n165 ? n151 : 1'bz;   // ram.v(91)
    assign r_line[9] = n165 ? n152 : 1'bz;   // ram.v(91)
    assign r_line[8] = n165 ? n153 : 1'bz;   // ram.v(91)
    assign r_line[7] = n165 ? n154 : 1'bz;   // ram.v(91)
    assign r_line[6] = n165 ? n155 : 1'bz;   // ram.v(91)
    assign r_line[5] = n165 ? n156 : 1'bz;   // ram.v(91)
    assign r_line[4] = n165 ? n157 : 1'bz;   // ram.v(91)
    assign r_line[3] = n165 ? n158 : 1'bz;   // ram.v(91)
    assign r_line[2] = n165 ? n159 : 1'bz;   // ram.v(91)
    assign r_line[1] = n165 ? n160 : 1'bz;   // ram.v(91)
    VERIFIC_DFFRS i268 (.d(n128), .clk(clk), .s(1'b0), .r(1'b0), .q(exc));   // ram.v(91)
    assign r_line[0] = n165 ? n161 : 1'bz;   // ram.v(91)
    VERIFIC_DFFRS i269 (.d(w_line[31]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n15));   // ram.v(91)
    VERIFIC_DFFRS i270 (.d(w_line[30]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n16));   // ram.v(91)
    VERIFIC_DFFRS i271 (.d(w_line[29]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n17));   // ram.v(91)
    VERIFIC_DFFRS i272 (.d(w_line[28]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n18));   // ram.v(91)
    VERIFIC_DFFRS i273 (.d(w_line[27]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n19));   // ram.v(91)
    VERIFIC_DFFRS i274 (.d(w_line[26]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n20));   // ram.v(91)
    VERIFIC_DFFRS i275 (.d(w_line[25]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n21));   // ram.v(91)
    VERIFIC_DFFRS i276 (.d(w_line[24]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n22));   // ram.v(91)
    VERIFIC_DFFRS i277 (.d(w_line[23]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n23));   // ram.v(91)
    VERIFIC_DFFRS i278 (.d(w_line[22]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n24));   // ram.v(91)
    VERIFIC_DFFRS i279 (.d(w_line[21]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n25));   // ram.v(91)
    VERIFIC_DFFRS i280 (.d(w_line[20]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n26));   // ram.v(91)
    VERIFIC_DFFRS i281 (.d(w_line[19]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n27));   // ram.v(91)
    VERIFIC_DFFRS i282 (.d(w_line[18]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n28));   // ram.v(91)
    VERIFIC_DFFRS i283 (.d(w_line[17]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n29));   // ram.v(91)
    VERIFIC_DFFRS i284 (.d(w_line[16]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n30));   // ram.v(91)
    VERIFIC_DFFRS i285 (.d(w_line[15]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n31));   // ram.v(91)
    VERIFIC_DFFRS i286 (.d(w_line[14]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n32));   // ram.v(91)
    VERIFIC_DFFRS i287 (.d(w_line[13]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n33));   // ram.v(91)
    VERIFIC_DFFRS i288 (.d(w_line[12]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n34));   // ram.v(91)
    VERIFIC_DFFRS i289 (.d(w_line[11]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n35));   // ram.v(91)
    VERIFIC_DFFRS i290 (.d(w_line[10]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n36));   // ram.v(91)
    VERIFIC_DFFRS i291 (.d(w_line[9]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n37));   // ram.v(91)
    VERIFIC_DFFRS i292 (.d(w_line[8]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n38));   // ram.v(91)
    VERIFIC_DFFRS i293 (.d(w_line[7]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n39));   // ram.v(91)
    VERIFIC_DFFRS i294 (.d(w_line[6]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n40));   // ram.v(91)
    VERIFIC_DFFRS i295 (.d(w_line[5]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n41));   // ram.v(91)
    VERIFIC_DFFRS i296 (.d(w_line[4]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n42));   // ram.v(91)
    VERIFIC_DFFRS i297 (.d(w_line[3]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n43));   // ram.v(91)
    VERIFIC_DFFRS i298 (.d(w_line[2]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n44));   // ram.v(91)
    VERIFIC_DFFRS i299 (.d(w_line[1]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n45));   // ram.v(91)
    VERIFIC_DFFRS i300 (.d(w_line[0]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n46));   // ram.v(91)
    VERIFIC_DFFRS i301 (.d(w_addr[10]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n47));   // ram.v(91)
    VERIFIC_DFFRS i302 (.d(w_addr[9]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n48));   // ram.v(91)
    VERIFIC_DFFRS i303 (.d(w_addr[8]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n49));   // ram.v(91)
    VERIFIC_DFFRS i304 (.d(w_addr[7]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n50));   // ram.v(91)
    VERIFIC_DFFRS i305 (.d(w_addr[6]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n51));   // ram.v(91)
    VERIFIC_DFFRS i306 (.d(w_addr[5]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n52));   // ram.v(91)
    VERIFIC_DFFRS i307 (.d(w_addr[4]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n53));   // ram.v(91)
    VERIFIC_DFFRS i308 (.d(w_addr[3]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n54));   // ram.v(91)
    VERIFIC_DFFRS i309 (.d(w_addr[2]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n55));   // ram.v(91)
    VERIFIC_DFFRS i310 (.d(w_addr[1]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n56));   // ram.v(91)
    VERIFIC_DFFRS i311 (.d(w_addr[0]), .clk(clk), .s(1'b0), .r(1'b0), 
            .q(n57));   // ram.v(91)
    VERIFIC_DFFRS i312 (.d(n129), .clk(clk), .s(1'b0), .r(1'b0), .q(n58));   // ram.v(91)
    VERIFIC_DFFRS i76 (.d(n61), .clk(clk), .s(1'b0), .r(1'b0), .q(n130));   // ram.v(91)
    
endmodule

//
// Verific Verilog Description of OPERATOR DualPortRam_11_32
//

module DualPortRam_11_32 (write_enable, write_address, write_data, read_address, 
            read_data);
    input write_enable;
    input [10:0]write_address;
    input [31:0]write_data;
    input [10:0]read_address;
    output [31:0]read_data;
    reg [32-1:0] ram [2**11-1:0];
    
    always @ (write_data or write_enable or write_address)
    begin
        if (write_enable)  begin
            ram[write_address] <= write_data;
        end
    end
    
    assign read_data = ram[read_address];
    
endmodule

//
// Verific Verilog Description of OPERATOR LessThan_32u_32u
//

module LessThan_32u_32u (cin, a, b, o);
    input cin;
    input [31:0]a;
    input [31:0]b;
    output o;
    assign o = cin ? a<=b : a<b ;
    
endmodule

//
// Verific Verilog Description of PRIMITIVE VERIFIC_DFFRS
//

module VERIFIC_DFFRS (d, clk, s, r, q);
    input d;
    input clk;
    input s;
    input r;
    output q;
    reg q ;
    always @(posedge clk or posedge s or posedge r) begin
        if (s) q = 1'b1;
        else if (r) q = 1'b0;
        else q = d;
    end
    
endmodule
