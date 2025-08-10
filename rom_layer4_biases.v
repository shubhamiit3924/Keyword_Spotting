// Q8.8 Fixed-Point ROM (Conservative): rom_layer4_biases
module rom_layer4_biases (
    input [3:0] addr,
    output reg signed [15:0] data_out
);

    always @(*) begin
        case(addr)
            4'd0: data_out = 16'hFFFA;
            4'd1: data_out = 16'hFFFA;
            4'd2: data_out = 16'hFFF6;
            4'd3: data_out = 16'hFFE0;
            4'd4: data_out = 16'h0032;
            4'd5: data_out = 16'h0050;
            4'd6: data_out = 16'hFFCB;
            4'd7: data_out = 16'hFFA6;
            4'd8: data_out = 16'h0070;
            4'd9: data_out = 16'hFF8B;
            default: data_out = 16'h0000;
        endcase
    end
endmodule
