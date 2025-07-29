`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2025 19:38:10
// Design Name: 
// Module Name: tb_neural_network_q88
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

// Enhanced Testbench with Debug
module tb_neural_network_q88;

    reg clk, rst_n, start;
    reg [3:0] sample_index;
    wire [3:0] predicted_class;
    wire valid;
    wire [15:0] debug_out0, debug_out1, debug_out2, debug_out3, debug_out4;
    wire [15:0] debug_out5, debug_out6, debug_out7, debug_out8, debug_out9;
    
    // Expected results
    reg [3:0] expected [0:9];
    initial begin
        expected[0] = 4;
        expected[1] = 8;
        expected[2] = 2;
        expected[3] = 5;
        expected[4] = 8;
        expected[5] = 5;
        expected[6] = 4;
        expected[7] = 4;
        expected[8] = 8;
        expected[9] = 2;
    end
    
    neural_network_q88 dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .sample_index(sample_index),
        .predicted_class(predicted_class),
        .valid(valid),
        .debug_out0(debug_out0), .debug_out1(debug_out1), .debug_out2(debug_out2),
        .debug_out3(debug_out3), .debug_out4(debug_out4), .debug_out5(debug_out5),
        .debug_out6(debug_out6), .debug_out7(debug_out7), .debug_out8(debug_out8),
        .debug_out9(debug_out9)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    integer i, correct;
    integer timeout_counter;
    
    initial begin
        $display("=== Starting Neural Network Test ===");
        
        clk = 0;
        rst_n = 0;
        start = 0;
        sample_index = 0;
        correct = 0;
        
        $display("Time %0t: Reset asserted", $time);
        #20 rst_n = 1;
        $display("Time %0t: Reset released", $time);
        
        #10;  // Wait a bit after reset
        
        // Test all 10 samples
        for (i = 0; i < 10; i = i + 1) begin
            $display("\n--- Testing Sample %0d ---", i);
            sample_index = i;
            start = 1;
            $display("Time %0t: Start asserted for sample %0d", $time, i);
            
            #10 start = 0;
            $display("Time %0t: Start deasserted", $time);
            
            // Wait for completion with timeout
            timeout_counter = 0;
            while (!valid && timeout_counter < 100000) begin
                #10;
                timeout_counter = timeout_counter + 1;
                if (timeout_counter % 1000 == 0) begin
                    $display("Time %0t: Waiting... state=%0d, i=%0d, j=%0d", 
                             $time, dut.state, dut.i, dut.j);
                end
            end
            
            if (timeout_counter >= 100000) begin
                $display("ERROR: Timeout waiting for sample %0d", i);
                $finish;
            end
            
            $display("Time %0t: Sample %0d completed", $time, i);
            $display("Sample %0d: Predicted = %0d, Expected = %0d %s", 
                     i, predicted_class, expected[i], 
                     (predicted_class == expected[i]) ? "✓" : "✗");
            
            if (predicted_class == expected[i]) correct = correct + 1;
            
            // Wait for valid to go low
            while (valid) #10;
            #20;  // Wait before next test
        end
        
        $display("\n=== Test Complete ===");
        $display("Accuracy: %0d/10 = %0d%%", correct, correct * 10);
        $finish;
    end

endmodule
