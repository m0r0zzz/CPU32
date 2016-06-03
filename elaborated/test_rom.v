
//
// Verific Verilog Description of module test_rom
//

module test_rom (word, addr);   // main.v(5)
    output [31:0]word;   // main.v(8)
    input [31:0]addr;   // main.v(6)
    
    
    wire n4, n5, n6, n8, n9, n10, n11, n14, n17, n21, n22, 
        n23, n26, n29, n33, n36, n40, n44, n46, n47, n48, 
        n49, n55, n60, n66, n72, n79, n84, n90, n96, n103, 
        n109, n116, n123, n131, n132, n134, n138, n142, n147, 
        n151, n156, n161, n168, n169, n170, n171, n172, n173, 
        n174, n175, n176, n177, n178, n179, n180, n181, n182, 
        n183, n205, n206, n210, n217, n220;
    
    assign word[22] = word[24];   // main.v(8)
    assign word[18] = word[19];   // main.v(8)
    assign word[9] = word[10];   // main.v(8)
    nor (n4, addr[31], addr[30], addr[29], addr[28], addr[27], addr[26], 
        addr[25], addr[24], addr[23], addr[22], addr[21], addr[20], 
        addr[19], addr[18], addr[17], addr[16], addr[15], addr[14], 
        addr[13], addr[12], addr[11], addr[10], addr[9], addr[8], 
        addr[7], addr[6], addr[5], addr[4], addr[3], addr[2], addr[1], 
        addr[0]) ;   // main.v(19)
    not (n5, addr[0]) ;   // main.v(22)
    nor (n6, addr[31], addr[30], addr[29], addr[28], addr[27], addr[26], 
        addr[25], addr[24], addr[23], addr[22], addr[21], addr[20], 
        addr[19], addr[18], addr[17], addr[16], addr[15], addr[14], 
        addr[13], addr[12], addr[11], addr[10], addr[9], addr[8], 
        addr[7], addr[6], addr[5], addr[4], addr[3], addr[2], addr[1], 
        n5) ;   // main.v(22)
    not (n8, addr[1]) ;   // main.v(25)
    nor (n9, addr[31], addr[30], addr[29], addr[28], addr[27], addr[26], 
        addr[25], addr[24], addr[23], addr[22], addr[21], addr[20], 
        addr[19], addr[18], addr[17], addr[16], addr[15], addr[14], 
        addr[13], addr[12], addr[11], addr[10], addr[9], addr[8], 
        addr[7], addr[6], addr[5], addr[4], addr[3], addr[2], n8, 
        n5) ;   // main.v(25)
    not (n10, addr[2]) ;   // main.v(28)
    nor (n11, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        addr[8], addr[7], addr[6], addr[5], addr[4], addr[3], n10, 
        addr[1], addr[0]) ;   // main.v(28)
    nor (n14, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        addr[8], addr[7], addr[6], addr[5], addr[4], addr[3], n10, 
        addr[1], n5) ;   // main.v(31)
    nor (n17, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        addr[8], addr[7], addr[6], addr[5], addr[4], addr[3], n10, 
        n8, addr[0]) ;   // main.v(34)
    nor (n21, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        addr[8], addr[7], addr[6], addr[5], addr[4], addr[3], n10, 
        n8, n5) ;   // main.v(37)
    not (n22, addr[3]) ;   // main.v(40)
    nor (n23, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        addr[8], addr[7], addr[6], addr[5], addr[4], n22, addr[2], 
        addr[1], addr[0]) ;   // main.v(40)
    nor (n26, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        addr[8], addr[7], addr[6], addr[5], addr[4], n22, addr[2], 
        addr[1], n5) ;   // main.v(43)
    nor (n29, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        addr[8], addr[7], addr[6], addr[5], addr[4], n22, addr[2], 
        n8, addr[0]) ;   // main.v(46)
    nor (n33, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        addr[8], addr[7], addr[6], addr[5], addr[4], n22, addr[2], 
        n8, n5) ;   // main.v(49)
    nor (n36, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        addr[8], addr[7], addr[6], addr[5], addr[4], n22, n10, 
        addr[1], addr[0]) ;   // main.v(52)
    nor (n40, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        addr[8], addr[7], addr[6], addr[5], addr[4], n22, n10, 
        addr[1], n5) ;   // main.v(55)
    nor (n44, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        addr[8], addr[7], addr[6], addr[5], addr[4], n22, n10, 
        n8, addr[0]) ;   // main.v(58)
    not (n46, addr[4]) ;   // main.v(61)
    not (n47, addr[5]) ;   // main.v(61)
    not (n48, addr[8]) ;   // main.v(61)
    nor (n49, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], addr[6], n47, n46, addr[3], addr[2], n8, 
        addr[0]) ;   // main.v(61)
    nor (n55, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], addr[6], n47, n46, addr[3], addr[2], n8, 
        n5) ;   // main.v(64)
    nor (n60, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], addr[6], n47, n46, addr[3], n10, addr[1], 
        addr[0]) ;   // main.v(67)
    nor (n66, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], addr[6], n47, n46, addr[3], n10, addr[1], 
        n5) ;   // main.v(70)
    nor (n72, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], addr[6], n47, n46, addr[3], n10, n8, addr[0]) ;   // main.v(73)
    nor (n79, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], addr[6], n47, n46, addr[3], n10, n8, n5) ;   // main.v(76)
    nor (n84, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], addr[6], n47, n46, n22, addr[2], addr[1], 
        addr[0]) ;   // main.v(79)
    nor (n90, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], addr[6], n47, n46, n22, addr[2], addr[1], 
        n5) ;   // main.v(82)
    nor (n96, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], addr[6], n47, n46, n22, addr[2], n8, addr[0]) ;   // main.v(85)
    nor (n103, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], addr[6], n47, n46, n22, addr[2], n8, n5) ;   // main.v(88)
    nor (n109, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], addr[6], n47, n46, n22, n10, addr[1], 
        addr[0]) ;   // main.v(91)
    nor (n116, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], addr[6], n47, n46, n22, n10, addr[1], 
        n5) ;   // main.v(94)
    nor (n123, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], addr[6], n47, n46, n22, n10, n8, addr[0]) ;   // main.v(97)
    nor (n131, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], addr[6], n47, n46, n22, n10, n8, n5) ;   // main.v(100)
    not (n132, addr[6]) ;   // main.v(103)
    nor (n134, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], n132, addr[5], addr[4], addr[3], addr[2], 
        addr[1], addr[0]) ;   // main.v(103)
    nor (n138, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], n132, addr[5], addr[4], addr[3], addr[2], 
        addr[1], n5) ;   // main.v(106)
    nor (n142, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], n132, addr[5], addr[4], addr[3], addr[2], 
        n8, addr[0]) ;   // main.v(109)
    nor (n147, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], n132, addr[5], addr[4], addr[3], addr[2], 
        n8, n5) ;   // main.v(112)
    nor (n151, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], n132, addr[5], addr[4], addr[3], n10, addr[1], 
        addr[0]) ;   // main.v(115)
    nor (n156, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], n132, addr[5], addr[4], addr[3], n10, addr[1], 
        n5) ;   // main.v(118)
    nor (n161, addr[31], addr[30], addr[29], addr[28], addr[27], 
        addr[26], addr[25], addr[24], addr[23], addr[22], addr[21], 
        addr[20], addr[19], addr[18], addr[17], addr[16], addr[15], 
        addr[14], addr[13], addr[12], addr[11], addr[10], addr[9], 
        n48, addr[7], n132, addr[5], addr[4], addr[3], n10, n8, 
        addr[0]) ;   // main.v(121)
    not (n168, addr[9]) ;   // main.v(124)
    not (n169, addr[10]) ;   // main.v(124)
    not (n170, addr[11]) ;   // main.v(124)
    not (n171, addr[12]) ;   // main.v(124)
    not (n172, addr[16]) ;   // main.v(124)
    not (n173, addr[17]) ;   // main.v(124)
    not (n174, addr[18]) ;   // main.v(124)
    not (n175, addr[20]) ;   // main.v(124)
    not (n176, addr[21]) ;   // main.v(124)
    not (n177, addr[22]) ;   // main.v(124)
    not (n178, addr[25]) ;   // main.v(124)
    not (n179, addr[26]) ;   // main.v(124)
    not (n180, addr[27]) ;   // main.v(124)
    not (n181, addr[28]) ;   // main.v(124)
    not (n182, addr[30]) ;   // main.v(124)
    nor (n183, addr[31], n182, addr[29], n181, n180, n179, n178, 
        addr[24], addr[23], n177, n176, n175, addr[19], n174, 
        n173, n172, addr[15], addr[14], addr[13], n171, n170, 
        n169, n168, addr[8], addr[7], n132, n47, n46, n22, n10, 
        addr[1], n5) ;   // main.v(124)
    nor (n205, addr[31], n182, addr[29], n181, n180, n179, n178, 
        addr[24], addr[23], n177, n176, n175, addr[19], n174, 
        n173, n172, addr[15], addr[14], addr[13], n171, n170, 
        n169, n168, addr[8], addr[7], n132, n47, n46, n22, n10, 
        n8, addr[0]) ;   // main.v(127)
    nor (n206, n4, n6, n9, n11, n14, n17, n21, n23, n26, 
        n29, n33, n36, n40, n44, n49, n55, n60, n66, n72, 
        n79, n84, n90, n96, n103, n109, n116, n123, n131, 
        n134, n138, n142, n147, n151, n156, n161, n183, n205) ;   // main.v(15)
    or (word[31], n23, n109) ;   // main.v(15)
    or (word[30], n4, n9, n23, n79, n103, n109) ;   // main.v(15)
    or (word[29], n26, n40, n49, n55, n60, n66, n84, n90, 
        n109, n116, n131, n138, n147, n156, n183, n205) ;   // main.v(15)
    or (n210, n4, n6, n9, n11, n21, n26, n29, n36, n44, 
        n72, n79, n96, n103, n123, n134, n142, n151, n161, 
        n206) ;   // main.v(15)
    not (word[28], n210) ;   // main.v(15)
    or (word[27], n14, n17, n23, n29, n49, n55, n66, n84, 
        n90, n109, n116, n131, n138, n147, n156) ;   // main.v(15)
    or (word[26], n23, n29, n33, n49, n55, n60, n84, n109, 
        n116, n131, n138, n147, n156, n205) ;   // main.v(15)
    or (word[25], n14, n17, n23, n26, n33, n49, n55, n66, 
        n79, n84, n109, n116, n131, n138, n147, n205) ;   // main.v(15)
    or (n217, n6, n11, n21, n23, n36, n44, n72, n96, n123, 
        n134, n142, n151, n161, n183, n205, n206) ;   // main.v(15)
    not (word[24], n217) ;   // main.v(15)
    or (n220, n6, n11, n21, n36, n44, n72, n96, n123, n134, 
        n142, n151, n161, n206) ;   // main.v(15)
    not (word[23], n220) ;   // main.v(15)
    or (word[21], n23, n109, n183) ;   // main.v(15)
    or (word[20], n14, n26, n29, n33, n49, n55, n60, n79, 
        n84, n109) ;   // main.v(15)
    or (word[19], n14, n23, n26, n29, n33, n49, n55, n60, 
        n79, n84, n109) ;   // main.v(15)
    or (word[17], n11, n21, n33, n49, n60, n109) ;   // main.v(15)
    or (word[16], n6, n14, n21, n23, n26, n29, n55, n79, n84, 
        n109) ;   // main.v(15)
    or (word[15], n14, n23, n26, n29, n49, n55, n66, n79, 
        n84, n109) ;   // main.v(15)
    or (word[14], n6, n14, n21, n26, n29, n49, n55, n66, n79, 
        n84, n109) ;   // main.v(15)
    or (word[13], n11, n14, n23, n26, n29, n49, n55, n66, 
        n79, n84, n109) ;   // main.v(15)
    or (word[12], n14, n21, n23, n26, n29, n55, n66, n79, 
        n84, n109) ;   // main.v(15)
    or (word[11], n6, n11, n21, n23, n49, n109, n116, n131, 
        n138, n147) ;   // main.v(15)
    or (word[10], n4, n9, n14, n17, n23, n26, n29, n33, n79, 
        n90, n109, n156) ;   // main.v(15)
    or (word[8], n4, n9, n14, n17, n21, n26, n29, n33, n44, 
        n79, n90, n109, n156) ;   // main.v(15)
    or (word[7], n4, n6, n11, n14, n23, n29, n79, n90, n109, 
        n156) ;   // main.v(15)
    or (word[6], n9, n17, n21, n26, n33, n103, n109) ;   // main.v(15)
    or (word[5], n4, n9, n17, n23, n26, n40, n44, n66, n79, 
        n90, n103, n109, n116, n131, n138, n147, n156) ;   // main.v(15)
    or (word[4], n17, n26, n33, n44, n72, n79, n96, n109, 
        n142) ;   // main.v(15)
    or (word[3], n6, n11, n23, n26, n36, n79, n109, n123, 
        n134, n151, n161) ;   // main.v(15)
    or (word[2], n23, n26, n109, n123, n134, n151) ;   // main.v(15)
    or (word[1], n21, n23, n36, n44, n79, n109, n134, n151, 
        n161) ;   // main.v(15)
    or (word[0], n23, n36, n109, n123, n134, n142) ;   // main.v(15)
    
endmodule
