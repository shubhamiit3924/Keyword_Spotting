module rom_test;
  reg [3:0] addr = 4'd2; // Sample 2
  reg [10:0] idx = 11'd0;
  wire signed [15:0] data;
  
  rom_test_inputs rom (.addr(addr), .index(idx), .data_out(data));
  
  initial begin
    $display("Checking ROM values for sample 2:");
    for (idx = 0; idx < 5; idx = idx + 1) begin
      #5;
      $display("Value at index %d: %d", idx, data);
    end
    $finish;
  end
endmodule
