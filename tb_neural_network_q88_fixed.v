`timescale 1ns / 1ps

module tb_neural_network_q88_fixed;

    // ===== Adjustable Parameter for Sample Index =====
    parameter SAMPLE_INDEX = 2; // Change this to run for a different input sample

    reg clk;
    reg rst_n;
    reg start;
    reg [3:0] sample_index;
    wire [3:0] predicted_class;
    wire [3:0] predicted_class_final;
    wire valid;

    // Debug outputs (optional)
    wire signed [15:0] debug_out0, debug_out1, debug_out2, debug_out3, debug_out4,
                        debug_out5, debug_out6, debug_out7, debug_out8, debug_out9;

    // Instantiate DUT
    neural_network_q88_fixed uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .sample_index(sample_index),
        .predicted_class(predicted_class),
        .predicted_class_final(predicted_class_final),
        .valid(valid),
        .debug_out0(debug_out0),
        .debug_out1(debug_out1),
        .debug_out2(debug_out2),
        .debug_out3(debug_out3),
        .debug_out4(debug_out4),
        .debug_out5(debug_out5),
        .debug_out6(debug_out6),
        .debug_out7(debug_out7),
        .debug_out8(debug_out8),
        .debug_out9(debug_out9)
    );

    // Clock generation: 100 MHz
    always #5 clk = ~clk;

    // Variables for stability check
    reg [3:0] prev_class;
    integer stable_count;
    reg done;

    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        start = 0;
        sample_index = SAMPLE_INDEX;
        done = 0;
        stable_count = 0;
        prev_class = 0;

        // Release reset after some time
        #20;
        rst_n = 1;

        // Start the NN inference
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        // Wait for valid signal indicating output ready
        wait(valid == 1);
                  wait(valid == 1);
        $display("=================================================");
        $display("Final Predicted Class for SAMPLE_INDEX=%0d = %0d", SAMPLE_INDEX, predicted_class_final);
        $display("Raw Logits (Q8.8 format):");
        $display(" Class 0: %d", debug_out0);
        $display(" Class 1: %d", debug_out1);
        $display(" Class 2: %d", debug_out2);
        $display(" Class 3: %d", debug_out3);
        $display(" Class 4: %d", debug_out4);
        $display(" Class 5: %d", debug_out5);
        $display(" Class 6: %d", debug_out6);
        $display(" Class 7: %d", debug_out7);
        $display(" Class 8: %d", debug_out8);
        $display(" Class 9: %d", debug_out9);
        $display("=================================================");
        #20;
        $stop;
    end

endmodule
