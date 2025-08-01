// Q8.8 Fixed-Point ROM: rom_layer2_biases
module rom_layer2_biases (
    input [6:0] addr,
    output reg signed [15:0] data_out
);

    reg signed [15:0] rom [0:127];

    initial begin
        rom[0] = 16'h0000;
        rom[1] = 16'h0017;
        rom[2] = 16'h000C;
        rom[3] = 16'hFFDF;
        rom[4] = 16'h0026;
        rom[5] = 16'h0036;
        rom[6] = 16'hFFDD;
        rom[7] = 16'hFFDD;
        rom[8] = 16'h001C;
        rom[9] = 16'hFFFD;
        rom[10] = 16'hFFFE;
        rom[11] = 16'h000C;
        rom[12] = 16'h0001;
        rom[13] = 16'hFFEE;
        rom[14] = 16'h0006;
        rom[15] = 16'h002C;
        rom[16] = 16'hFFEC;
        rom[17] = 16'hFFF9;
        rom[18] = 16'h000A;
        rom[19] = 16'h0004;
        rom[20] = 16'h001E;
        rom[21] = 16'h0016;
        rom[22] = 16'hFFE8;
        rom[23] = 16'hFFDD;
        rom[24] = 16'h002E;
        rom[25] = 16'h0021;
        rom[26] = 16'h0030;
        rom[27] = 16'h000E;
        rom[28] = 16'hFFEA;
        rom[29] = 16'h0020;
        rom[30] = 16'h001A;
        rom[31] = 16'hFFE0;
        rom[32] = 16'hFFFE;
        rom[33] = 16'hFFF2;
        rom[34] = 16'hFFD4;
        rom[35] = 16'h000A;
        rom[36] = 16'hFFE3;
        rom[37] = 16'h0018;
        rom[38] = 16'hFFF2;
        rom[39] = 16'h0009;
        rom[40] = 16'hFFD4;
        rom[41] = 16'h001D;
        rom[42] = 16'hFFDD;
        rom[43] = 16'hFFFD;
        rom[44] = 16'hFFF8;
        rom[45] = 16'h0005;
        rom[46] = 16'hFFDC;
        rom[47] = 16'h0011;
        rom[48] = 16'h0004;
        rom[49] = 16'h0024;
        rom[50] = 16'hFFF2;
        rom[51] = 16'h000B;
        rom[52] = 16'hFFD9;
        rom[53] = 16'hFFD3;
        rom[54] = 16'h0023;
        rom[55] = 16'h001A;
        rom[56] = 16'h003C;
        rom[57] = 16'hFFF6;
        rom[58] = 16'hFFDC;
        rom[59] = 16'h001A;
        rom[60] = 16'h0016;
        rom[61] = 16'h0019;
        rom[62] = 16'h0017;
        rom[63] = 16'hFFE8;
        rom[64] = 16'hFFFC;
        rom[65] = 16'hFFD1;
        rom[66] = 16'h0039;
        rom[67] = 16'h0036;
        rom[68] = 16'h0007;
        rom[69] = 16'h0024;
        rom[70] = 16'h0028;
        rom[71] = 16'hFFDC;
        rom[72] = 16'hFFFC;
        rom[73] = 16'h0044;
        rom[74] = 16'hFFDE;
        rom[75] = 16'h0002;
        rom[76] = 16'h001D;
        rom[77] = 16'h000E;
        rom[78] = 16'h001A;
        rom[79] = 16'hFFE3;
        rom[80] = 16'h001A;
        rom[81] = 16'hFFFF;
        rom[82] = 16'h0023;
        rom[83] = 16'hFFB4;
        rom[84] = 16'h0004;
        rom[85] = 16'h0000;
        rom[86] = 16'hFFE6;
        rom[87] = 16'hFFE4;
        rom[88] = 16'hFFF9;
        rom[89] = 16'h0008;
        rom[90] = 16'h0029;
        rom[91] = 16'hFFF8;
        rom[92] = 16'h0018;
        rom[93] = 16'h0015;
        rom[94] = 16'hFFE5;
        rom[95] = 16'h0000;
        rom[96] = 16'h0021;
        rom[97] = 16'hFFEF;
        rom[98] = 16'hFFE6;
        rom[99] = 16'hFFF8;
        rom[100] = 16'hFFE9;
        rom[101] = 16'h0014;
        rom[102] = 16'hFFDD;
        rom[103] = 16'hFFF9;
        rom[104] = 16'hFFF3;
        rom[105] = 16'h0010;
        rom[106] = 16'h0008;
        rom[107] = 16'h0005;
        rom[108] = 16'hFFE2;
        rom[109] = 16'hFFF4;
        rom[110] = 16'h002A;
        rom[111] = 16'h000B;
        rom[112] = 16'h0011;
        rom[113] = 16'hFFFC;
        rom[114] = 16'hFFFA;
        rom[115] = 16'hFFCB;
        rom[116] = 16'hFFF6;
        rom[117] = 16'h001B;
        rom[118] = 16'h0007;
        rom[119] = 16'h002D;
        rom[120] = 16'h000A;
        rom[121] = 16'hFFDF;
        rom[122] = 16'h000A;
        rom[123] = 16'hFFF8;
        rom[124] = 16'hFFFA;
        rom[125] = 16'hFFEC;
        rom[126] = 16'hFFDC;
        rom[127] = 16'hFFD7;
    end

    always @(*) begin
        data_out = rom[addr];
    end
endmodule
