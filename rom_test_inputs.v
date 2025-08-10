// Q8.8 Fixed-Point ROM (Conservative): rom_test_inputs
module rom_test_inputs (
    input [3:0] addr,
    input [10:0] index,
    output reg signed [15:0] data_out
);

    always @(*) begin
        case(addr)
            4'd0: begin
                case(index)
                    11'd0: data_out = 16'h12A5;
                    11'd1: data_out = 16'h0C59;
                    11'd2: data_out = 16'h0F5F;
                    11'd3: data_out = 16'h1122;
                    11'd4: data_out = 16'h0F9F;
                    11'd5: data_out = 16'h0D5B;
                    11'd6: data_out = 16'h0B97;
                    11'd7: data_out = 16'h0A95;
                    11'd8: data_out = 16'h0912;
                    11'd9: data_out = 16'h07D0;
                    11'd10: data_out = 16'h070E;
                    11'd11: data_out = 16'h064D;
                    11'd12: data_out = 16'h060C;
                    11'd13: data_out = 16'h060C;
                    11'd14: data_out = 16'h058B;
                    11'd15: data_out = 16'h054B;
                    11'd16: data_out = 16'h058B;
                    11'd17: data_out = 16'h064D;
                    11'd18: data_out = 16'h070E;
                    11'd19: data_out = 16'h08D2;
                    11'd50: data_out = 16'h0000;
                    11'd100: data_out = 16'h08D2;
                    11'd200: data_out = 16'hFC79;
                    11'd500: data_out = 16'hECDA;
                    11'd1000: data_out = 16'h0102;
                    11'd1269: data_out = 16'h0000;
                    11'd1270: data_out = 16'h0000;
                    11'd1271: data_out = 16'h0000;
                    11'd1272: data_out = 16'h0000;
                    11'd1273: data_out = 16'h0000;
                    default: data_out = 16'h0000;
                endcase
            end
            4'd1: begin
                case(index)
                    11'd0: data_out = 16'h0489;
                    11'd1: data_out = 16'h0408;
                    11'd2: data_out = 16'h0347;
                    11'd3: data_out = 16'h0204;
                    11'd4: data_out = 16'h00C2;
                    11'd5: data_out = 16'hFFBF;
                    11'd6: data_out = 16'h09D4;
                    11'd7: data_out = 16'h0D5B;
                    11'd8: data_out = 16'h0DDC;
                    11'd9: data_out = 16'h0D5B;
                    11'd10: data_out = 16'h0B97;
                    11'd11: data_out = 16'h08D2;
                    11'd12: data_out = 16'h064D;
                    11'd13: data_out = 16'h0387;
                    11'd14: data_out = 16'hFFBF;
                    11'd15: data_out = 16'hFCFA;
                    11'd16: data_out = 16'hFB36;
                    11'd17: data_out = 16'hFA34;
                    11'd18: data_out = 16'hF973;
                    11'd19: data_out = 16'hF932;
                    11'd50: data_out = 16'h0000;
                    11'd100: data_out = 16'h060C;
                    11'd200: data_out = 16'h0204;
                    11'd500: data_out = 16'h0C59;
                    11'd1000: data_out = 16'h070E;
                    11'd1269: data_out = 16'h0000;
                    11'd1270: data_out = 16'h0000;
                    11'd1271: data_out = 16'h0000;
                    11'd1272: data_out = 16'h0000;
                    11'd1273: data_out = 16'h0000;
                    default: data_out = 16'h0000;
                endcase
            end
            4'd2: begin
                case(index)
                    11'd0: data_out = 16'hFD3A;
                    11'd1: data_out = 16'hFBB7;
                    11'd2: data_out = 16'hFB36;
                    11'd3: data_out = 16'hFAB5;
                    11'd4: data_out = 16'hFA34;
                    11'd5: data_out = 16'hF973;
                    11'd6: data_out = 16'hFCFA;
                    11'd7: data_out = 16'h0183;
                    11'd8: data_out = 16'h0489;
                    11'd9: data_out = 16'h08D2;
                    11'd10: data_out = 16'h0C99;
                    11'd11: data_out = 16'h0DDC;
                    11'd12: data_out = 16'h0DDC;
                    11'd13: data_out = 16'h0D1A;
                    11'd14: data_out = 16'h0A14;
                    11'd15: data_out = 16'h068D;
                    11'd16: data_out = 16'h078F;
                    11'd17: data_out = 16'h0CDA;
                    11'd18: data_out = 16'h0D5B;
                    11'd19: data_out = 16'h0AD6;
                    11'd50: data_out = 16'h0000;
                    11'd100: data_out = 16'hF72E;
                    11'd200: data_out = 16'hFE3C;
                    11'd500: data_out = 16'hF830;
                    11'd1000: data_out = 16'hF9B3;
                    11'd1269: data_out = 16'h0000;
                    11'd1270: data_out = 16'h0000;
                    11'd1271: data_out = 16'h0000;
                    11'd1272: data_out = 16'h0000;
                    11'd1273: data_out = 16'h0000;
                    default: data_out = 16'h0000;
                endcase
            end
            4'd3: begin
                case(index)
                    11'd0: data_out = 16'h0A14;
                    11'd1: data_out = 16'h09D4;
                    11'd2: data_out = 16'h09D4;
                    11'd3: data_out = 16'h0953;
                    11'd4: data_out = 16'h070E;
                    11'd5: data_out = 16'h054B;
                    11'd6: data_out = 16'h0408;
                    11'd7: data_out = 16'h0285;
                    11'd8: data_out = 16'h0143;
                    11'd9: data_out = 16'hFFBF;
                    11'd10: data_out = 16'hFEFE;
                    11'd11: data_out = 16'hFE3C;
                    11'd12: data_out = 16'hFDBB;
                    11'd13: data_out = 16'hFCFA;
                    11'd14: data_out = 16'hFC79;
                    11'd15: data_out = 16'hFBF8;
                    11'd16: data_out = 16'hFBF8;
                    11'd17: data_out = 16'hFC79;
                    11'd18: data_out = 16'hFD7B;
                    11'd19: data_out = 16'h0306;
                    11'd50: data_out = 16'h0000;
                    11'd100: data_out = 16'hFDBB;
                    11'd200: data_out = 16'h0000;
                    11'd500: data_out = 16'h064D;
                    11'd1000: data_out = 16'h01C4;
                    11'd1269: data_out = 16'h0000;
                    11'd1270: data_out = 16'h0000;
                    11'd1271: data_out = 16'h0000;
                    11'd1272: data_out = 16'h0000;
                    11'd1273: data_out = 16'h0000;
                    default: data_out = 16'h0000;
                endcase
            end
            4'd4: begin
                case(index)
                    11'd0: data_out = 16'hF8B1;
                    11'd1: data_out = 16'hF9B3;
                    11'd2: data_out = 16'hF9B3;
                    11'd3: data_out = 16'hF8B1;
                    11'd4: data_out = 16'hF830;
                    11'd5: data_out = 16'hF76F;
                    11'd6: data_out = 16'hF6AD;
                    11'd7: data_out = 16'hF62C;
                    11'd8: data_out = 16'hF6EE;
                    11'd9: data_out = 16'hFCFA;
                    11'd10: data_out = 16'h0000;
                    11'd11: data_out = 16'h0204;
                    11'd12: data_out = 16'h02C6;
                    11'd13: data_out = 16'h0143;
                    11'd14: data_out = 16'hFD7B;
                    11'd15: data_out = 16'hF8F2;
                    11'd16: data_out = 16'hF5EC;
                    11'd17: data_out = 16'hF469;
                    11'd18: data_out = 16'hF3A7;
                    11'd19: data_out = 16'hF2E6;
                    11'd50: data_out = 16'h0000;
                    11'd100: data_out = 16'h0347;
                    11'd200: data_out = 16'hFC38;
                    11'd500: data_out = 16'h1326;
                    11'd1000: data_out = 16'hF7F0;
                    11'd1269: data_out = 16'h0000;
                    11'd1270: data_out = 16'h0000;
                    11'd1271: data_out = 16'h0000;
                    11'd1272: data_out = 16'h0000;
                    11'd1273: data_out = 16'h0000;
                    default: data_out = 16'h0000;
                endcase
            end
            4'd5: begin
                case(index)
                    11'd0: data_out = 16'hFCFA;
                    11'd1: data_out = 16'hFCFA;
                    11'd2: data_out = 16'hFC79;
                    11'd3: data_out = 16'hFC38;
                    11'd4: data_out = 16'h0143;
                    11'd5: data_out = 16'h060C;
                    11'd6: data_out = 16'h0810;
                    11'd7: data_out = 16'h0A95;
                    11'd8: data_out = 16'h0AD6;
                    11'd9: data_out = 16'h0993;
                    11'd10: data_out = 16'h0851;
                    11'd11: data_out = 16'h070E;
                    11'd12: data_out = 16'h064D;
                    11'd13: data_out = 16'h058B;
                    11'd14: data_out = 16'h0489;
                    11'd15: data_out = 16'h0449;
                    11'd16: data_out = 16'h0347;
                    11'd17: data_out = 16'h0143;
                    11'd18: data_out = 16'hFEFE;
                    11'd19: data_out = 16'hFCB9;
                    11'd50: data_out = 16'h0000;
                    11'd100: data_out = 16'h058B;
                    11'd200: data_out = 16'h08D2;
                    11'd500: data_out = 16'h0F1E;
                    11'd1000: data_out = 16'h08D2;
                    11'd1269: data_out = 16'h0000;
                    11'd1270: data_out = 16'h0000;
                    11'd1271: data_out = 16'h0000;
                    11'd1272: data_out = 16'h0000;
                    11'd1273: data_out = 16'h0000;
                    default: data_out = 16'h0000;
                endcase
            end
            4'd6: begin
                case(index)
                    11'd0: data_out = 16'h1A34;
                    11'd1: data_out = 16'h1973;
                    11'd2: data_out = 16'h1A34;
                    11'd3: data_out = 16'h18B1;
                    11'd4: data_out = 16'h13E8;
                    11'd5: data_out = 16'h0D5B;
                    11'd6: data_out = 16'h08D2;
                    11'd7: data_out = 16'h0347;
                    11'd8: data_out = 16'h0387;
                    11'd9: data_out = 16'h0953;
                    11'd10: data_out = 16'h0A95;
                    11'd11: data_out = 16'h0A14;
                    11'd12: data_out = 16'h09D4;
                    11'd13: data_out = 16'h09D4;
                    11'd14: data_out = 16'h0A95;
                    11'd15: data_out = 16'h0B16;
                    11'd16: data_out = 16'h0993;
                    11'd17: data_out = 16'h0851;
                    11'd18: data_out = 16'h0D1A;
                    11'd19: data_out = 16'h0EDE;
                    11'd50: data_out = 16'h0000;
                    11'd100: data_out = 16'h09D4;
                    11'd200: data_out = 16'hF56B;
                    11'd500: data_out = 16'hEF5F;
                    11'd1000: data_out = 16'hFEBD;
                    11'd1269: data_out = 16'h0000;
                    11'd1270: data_out = 16'h0000;
                    11'd1271: data_out = 16'h0000;
                    11'd1272: data_out = 16'h0000;
                    11'd1273: data_out = 16'h0000;
                    default: data_out = 16'h0000;
                endcase
            end
            4'd7: begin
                case(index)
                    11'd0: data_out = 16'h0851;
                    11'd1: data_out = 16'h0891;
                    11'd2: data_out = 16'h07D0;
                    11'd3: data_out = 16'h060C;
                    11'd4: data_out = 16'h0449;
                    11'd5: data_out = 16'h0306;
                    11'd6: data_out = 16'h0183;
                    11'd7: data_out = 16'h0081;
                    11'd8: data_out = 16'hFEFE;
                    11'd9: data_out = 16'hFE3C;
                    11'd10: data_out = 16'hFD7B;
                    11'd11: data_out = 16'hFCB9;
                    11'd12: data_out = 16'hFDFC;
                    11'd13: data_out = 16'hFF7F;
                    11'd14: data_out = 16'hFF3E;
                    11'd15: data_out = 16'hFE7D;
                    11'd16: data_out = 16'h0102;
                    11'd17: data_out = 16'h0489;
                    11'd18: data_out = 16'h064D;
                    11'd19: data_out = 16'h070E;
                    11'd50: data_out = 16'h0000;
                    11'd100: data_out = 16'h10E2;
                    11'd200: data_out = 16'hFBB7;
                    11'd500: data_out = 16'h0041;
                    11'd1000: data_out = 16'h0408;
                    11'd1269: data_out = 16'h0000;
                    11'd1270: data_out = 16'h0000;
                    11'd1271: data_out = 16'h0000;
                    11'd1272: data_out = 16'h0000;
                    11'd1273: data_out = 16'h0000;
                    default: data_out = 16'h0000;
                endcase
            end
            4'd8: begin
                case(index)
                    11'd0: data_out = 16'hFAB5;
                    11'd1: data_out = 16'hFB36;
                    11'd2: data_out = 16'hFB36;
                    11'd3: data_out = 16'hFDBB;
                    11'd4: data_out = 16'hFFBF;
                    11'd5: data_out = 16'hFFBF;
                    11'd6: data_out = 16'hFEBD;
                    11'd7: data_out = 16'hFD3A;
                    11'd8: data_out = 16'hFA34;
                    11'd9: data_out = 16'hFBF8;
                    11'd10: data_out = 16'h0000;
                    11'd11: data_out = 16'h0143;
                    11'd12: data_out = 16'h0041;
                    11'd13: data_out = 16'hFEFE;
                    11'd14: data_out = 16'hFE7D;
                    11'd15: data_out = 16'hFF3E;
                    11'd16: data_out = 16'hFE3C;
                    11'd17: data_out = 16'hFAF6;
                    11'd18: data_out = 16'hF6AD;
                    11'd19: data_out = 16'hFAB5;
                    11'd50: data_out = 16'h0000;
                    11'd100: data_out = 16'h0D5B;
                    11'd200: data_out = 16'hEAD6;
                    11'd500: data_out = 16'hEDDC;
                    11'd1000: data_out = 16'hF871;
                    11'd1269: data_out = 16'h0000;
                    11'd1270: data_out = 16'h0000;
                    11'd1271: data_out = 16'h0000;
                    11'd1272: data_out = 16'h0000;
                    11'd1273: data_out = 16'h0000;
                    default: data_out = 16'h0000;
                endcase
            end
            4'd9: begin
                case(index)
                    11'd0: data_out = 16'h0408;
                    11'd1: data_out = 16'h0449;
                    11'd2: data_out = 16'h03C8;
                    11'd3: data_out = 16'h02C6;
                    11'd4: data_out = 16'h0143;
                    11'd5: data_out = 16'h0081;
                    11'd6: data_out = 16'hFF7F;
                    11'd7: data_out = 16'hFE7D;
                    11'd8: data_out = 16'hFD3A;
                    11'd9: data_out = 16'hFC79;
                    11'd10: data_out = 16'hFB77;
                    11'd11: data_out = 16'hFA75;
                    11'd12: data_out = 16'hF9F4;
                    11'd13: data_out = 16'hF9B3;
                    11'd14: data_out = 16'hFDFC;
                    11'd15: data_out = 16'h01C4;
                    11'd16: data_out = 16'h0408;
                    11'd17: data_out = 16'h0408;
                    11'd18: data_out = 16'h03C8;
                    11'd19: data_out = 16'h03C8;
                    11'd50: data_out = 16'h0000;
                    11'd100: data_out = 16'h02C6;
                    11'd200: data_out = 16'hF3E8;
                    11'd500: data_out = 16'h0000;
                    11'd1000: data_out = 16'hFBF8;
                    11'd1269: data_out = 16'h0000;
                    11'd1270: data_out = 16'h0000;
                    11'd1271: data_out = 16'h0000;
                    11'd1272: data_out = 16'h0000;
                    11'd1273: data_out = 16'h0000;
                    default: data_out = 16'h0000;
                endcase
            end
            default: data_out = 16'h0000;
        endcase
    end
endmodule
