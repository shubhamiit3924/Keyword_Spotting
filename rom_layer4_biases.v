// Q8.8 Fixed-Point ROM: rom_layer4_biases
module rom_layer4_biases (
    input [3:0] addr,
    output reg signed [15:0] data_out
);

    reg signed [15:0] rom [0:9];

    initial begin
        rom[0] = 16'hFFF0;
        rom[1] = 16'hFFEC;
        rom[2] = 16'hFFDF;
        rom[3] = 16'h0012;
        rom[4] = 16'h0031;
        rom[5] = 16'h003D;
        rom[6] = 16'hFFD8;
        rom[7] = 16'hFF9B;
        rom[8] = 16'h0084;
        rom[9] = 16'hFF73;
    end

    always @(*) begin
        data_out = rom[addr];
    end
endmodule
