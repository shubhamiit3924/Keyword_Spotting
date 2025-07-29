`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2025 19:33:59
// Design Name: 
// Module Name: neural_network_q88
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// Neural Network Top Module (Q8.8 Fixed-Point)
module neural_network_q88 (
    input clk,
    input rst_n,
    input start,
    input [3:0] sample_index,  // 0 to 9 for test samples
    output reg [3:0] predicted_class,
    output reg valid,
    // Debug outputs as separate signals instead of array
    output reg [15:0] debug_out0, debug_out1, debug_out2, debug_out3, debug_out4,
    output reg [15:0] debug_out5, debug_out6, debug_out7, debug_out8, debug_out9
);

    // State machine
    reg [3:0] state;
    parameter IDLE = 0, LOAD_INPUT = 1, LAYER1 = 2, LAYER2 = 3, OUTPUT_LAYER = 4, FIND_MAX = 5, DONE = 6;
    
    // Counters
    reg [10:0] i, j;  // Loop counters
    
    // ROM interfaces
    wire signed [15:0] input_data, w0_data, b0_data, w1_data, b1_data, w2_data, b2_data;
    reg [10:0] input_addr, w0_addr, w1_addr, w2_addr;
    reg [7:0] w0_index, w1_index, w2_index;
    reg [7:0] b0_addr, b1_addr, b2_addr;
    
    // Layer outputs (Q8.8 format)
    reg signed [15:0] layer1_out [0:255];  // 256 neurons
    reg signed [15:0] layer2_out [0:127];  // 128 neurons
    reg signed [15:0] output_out [0:9];    // 10 classes
    
    // Accumulator (Q16.16 for intermediate calculations)
    reg signed [31:0] accumulator;
    reg signed [15:0] temp_result;
    
    // ROM instantiations
    rom_test_inputs input_rom (
        .addr(sample_index),
        .index(input_addr),
        .data_out(input_data)
    );
    
    rom_layer0_weights w0_rom (
        .addr(w0_addr),
        .index(w0_index),
        .data_out(w0_data)
    );
    
    rom_layer0_biases b0_rom (
        .addr(b0_addr),
        .data_out(b0_data)
    );
    
    rom_layer2_weights w1_rom (
        .addr(w1_addr),
        .index(w1_index),
        .data_out(w1_data)
    );
    
    rom_layer2_biases b1_rom (
        .addr(b1_addr),
        .data_out(b1_data)
    );
    
    rom_layer4_weights w2_rom (
        .addr(w2_addr),
        .index(w2_index),
        .data_out(w2_data)
    );
    
    rom_layer4_biases b2_rom (
        .addr(b2_addr),
        .data_out(b2_data)
    );
    
    // Main state machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            valid <= 0;
            predicted_class <= 0;
            i <= 0;
            j <= 0;
        end else begin
            case (state)
                IDLE: begin
                    valid <= 0;
                    if (start) begin
                        state <= LAYER1;
                        i <= 0;
                        j <= 0;
                    end
                end
                
                LAYER1: begin  // Compute layer 1: input (1274) -> hidden1 (256)
                    if (i < 256) begin  // For each output neuron
                        if (j == 0) begin
                            accumulator <= 0;
                            b0_addr <= i;
                            w0_index <= i;
                            w0_addr <= 0;
                            input_addr <= 0;
                        end else if (j <= 1274) begin
                            // Accumulate: input[j-1] * weight[j-1][i]
                            accumulator <= accumulator + (input_data * w0_data);
                            if (j < 1274) begin
                                w0_addr <= j;
                                input_addr <= j;
                            end
                        end else begin
                            // Add bias and apply ReLU
                            temp_result = (accumulator >>> 8) + b0_data;  // Scale down from Q16.16 to Q8.8
                            layer1_out[i] <= (temp_result < 0) ? 16'h0000 : temp_result;  // ReLU
                            i <= i + 1;
                            j <= 0;
                        end
                        
                        if (j <= 1274) j <= j + 1;
                    end else begin
                        state <= LAYER2;
                        i <= 0;
                        j <= 0;
                    end
                end
                
                LAYER2: begin  // Compute layer 2: hidden1 (256) -> hidden2 (128)
                    if (i < 128) begin
                        if (j == 0) begin
                            accumulator <= 0;
                            b1_addr <= i;
                            w1_index <= i;
                            w1_addr <= 0;
                        end else if (j <= 256) begin
                            accumulator <= accumulator + (layer1_out[j-1] * w1_data);
                            if (j < 256) begin
                                w1_addr <= j;
                            end
                        end else begin
                            temp_result = (accumulator >>> 8) + b1_data;
                            layer2_out[i] <= (temp_result < 0) ? 16'h0000 : temp_result;  // ReLU
                            i <= i + 1;
                            j <= 0;
                        end
                        
                        if (j <= 256) j <= j + 1;
                    end else begin
                        state <= OUTPUT_LAYER;
                        i <= 0;
                        j <= 0;
                    end
                end
                
                OUTPUT_LAYER: begin  // Compute output: hidden2 (128) -> output (10)
                    if (i < 10) begin
                        if (j == 0) begin
                            accumulator <= 0;
                            b2_addr <= i;
                            w2_index <= i;
                            w2_addr <= 0;
                        end else if (j <= 128) begin
                            accumulator <= accumulator + (layer2_out[j-1] * w2_data);
                            if (j < 128) begin
                                w2_addr <= j;
                            end
                        end else begin
                            output_out[i] <= (accumulator >>> 8) + b2_data;  // No ReLU on output
                            // Assign to individual debug outputs
                            case (i)
                                0: debug_out0 <= (accumulator >>> 8) + b2_data;
                                1: debug_out1 <= (accumulator >>> 8) + b2_data;
                                2: debug_out2 <= (accumulator >>> 8) + b2_data;
                                3: debug_out3 <= (accumulator >>> 8) + b2_data;
                                4: debug_out4 <= (accumulator >>> 8) + b2_data;
                                5: debug_out5 <= (accumulator >>> 8) + b2_data;
                                6: debug_out6 <= (accumulator >>> 8) + b2_data;
                                7: debug_out7 <= (accumulator >>> 8) + b2_data;
                                8: debug_out8 <= (accumulator >>> 8) + b2_data;
                                9: debug_out9 <= (accumulator >>> 8) + b2_data;
                            endcase
                            i <= i + 1;
                            j <= 0;
                        end
                        
                        if (j <= 128) j <= j + 1;
                    end else begin
                        state <= FIND_MAX;
                        i <= 0;
                    end
                end
                
                FIND_MAX: begin  // Find argmax
                    if (i == 0) begin
                        predicted_class <= 0;
                        temp_result <= output_out[0];
                        i <= 1;
                    end else if (i < 10) begin
                        if (output_out[i] > temp_result) begin
                            predicted_class <= i;
                            temp_result <= output_out[i];
                        end
                        i <= i + 1;
                    end else begin
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    valid <= 1;
                    if (!start) state <= IDLE;
                end
            endcase
        end
    end

endmodule
