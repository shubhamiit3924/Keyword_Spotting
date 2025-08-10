// neural_network_q88_fixed.v
// Clocked, Q8.8 fixed-point, uses ROM modules (1-cycle read latency modeled).
// Uses your ROM names exactly.

module neural_network_q88_fixed (
    input  wire         clk,
    input  wire         rst_n,           // active-low reset
    input  wire         start,           // hold high to start; module waits for it to go low before next run
    input  wire [3:0]   sample_index,    // selects which input sample in rom_test_inputs
    output reg  [3:0]   predicted_class, // final argmax
    output reg  [3:0]   predicted_class_final,
    output reg          valid,           // one-cycle pulse when result ready
    // debug final logits (signed Q8.8)
    output reg signed [15:0] debug_out0, debug_out1, debug_out2, debug_out3, debug_out4,
                             debug_out5, debug_out6, debug_out7, debug_out8, debug_out9
);

    // Parameters
    localparam FEAT_LEN = 1274;
    localparam L0_NEUR  = 256;
    localparam L1_NEUR  = 128;
    localparam OUT_NEUR = 10;
    localparam Q = 8; // fractional bits (Q8.8)

    // FSM states
    reg [3:0] state;
    localparam IDLE         = 4'd0,
               L0_ADDR      = 4'd1,
               L0_MAC       = 4'd2,
               L0_DONE      = 4'd3,
               L1_ADDR      = 4'd4,
               L1_MAC       = 4'd5,
               L1_DONE      = 4'd6,
               OUT_ADDR     = 4'd7,
               OUT_MAC      = 4'd8,
               OUT_DONE     = 4'd9,
               FIND_MAX     = 4'd10,
               DONE_PULSE   = 4'd11,
               WAIT_START   = 4'd12;

    // Top-level index / counters (module-scope)
    reg [10:0] feat_idx;    // 0..1273
    reg [7:0]  neuron_idx;  // 0..255 (for L0) and reused for L1
    reg [7:0]  out_idx;     // 0..9
    integer    i;           // loop counter if needed (module-scope)

    // ROM address registers
    reg [3:0]  rom_sample_sel;
    reg [10:0] input_addr;   // index into rom_test_inputs
    reg [10:0] w0_addr;      // addr for rom_layer0_weights (addr dim 0..1273)
    reg [7:0]  w0_index;     // index (neuron) for rom_layer0_weights
    reg [7:0]  b0_addr;

    reg [7:0]  w1_addr;      // addr for rom_layer2_weights (addr dim 0..255)
    reg [6:0]  w1_index;     // index (neuron) for rom_layer2_weights (0..127)
    reg [6:0]  b1_addr;

    reg [6:0]  w2_addr;      // addr for rom_layer4_weights (addr dim 0..127)
    reg [3:0]  w2_index;     // index (neuron) for rom_layer4_weights (0..9)
    reg [3:0]  b2_addr;

    // ROM outputs (wires)
    wire signed [15:0] rom_in_data;
    wire signed [15:0] rom_w0_data, rom_b0_data;
    wire signed [15:0] rom_w1_data, rom_b1_data;
    wire signed [15:0] rom_w2_data, rom_b2_data;

    // Registered ROM outputs -> rd_* (models 1-cycle read latency)
    reg signed [15:0] rd_in_data;
    reg signed [15:0] rd_w0_data, rd_b0_data;
    reg signed [15:0] rd_w1_data, rd_b1_data;
    reg signed [15:0] rd_w2_data, rd_b2_data;

    // Layer storage (synthesizable arrays)
    reg signed [15:0] layer0_out [0:L0_NEUR-1];
    reg signed [15:0] layer1_out [0:L1_NEUR-1];
    reg signed [15:0] output_out [0:OUT_NEUR-1];

    // Add debugging task - MOVED AFTER ARRAY DECLARATIONS
    task debug_layer_outputs;
        integer i;
        begin
            $display("Debug Layer 0 outputs (first 5 neurons):");
            for (i=0; i<5; i=i+1)
                $display("  Neuron %0d: %0d", i, layer0_out[i]);
                
            $display("Debug Layer 1 outputs (first 5 neurons):");
            for (i=0; i<5; i=i+1)
                $display("  Neuron %0d: %0d", i, layer1_out[i]);
        end
    endtask

    // Arithmetic regs (module-scope)
    reg signed [47:0] accumulator; // wide accumulator (48-bit)
    reg signed [31:0] product;     // product 16x16 -> 32-bit
    reg signed [47:0] acc_shr;
    reg signed [47:0] bias_ext;
    reg signed [47:0] sum48;
    reg signed [15:0] final16;
    reg signed [15:0] max_val;

    // Instantiate your ROM modules (exact names you provided)
    rom_test_inputs    rom_in  (.addr(rom_sample_sel), .index(input_addr), .data_out(rom_in_data));
    rom_layer0_weights rom_w0  (.addr(w0_addr), .index(w0_index), .data_out(rom_w0_data));
    rom_layer0_biases  rom_b0  (.addr(b0_addr), .data_out(rom_b0_data));
    rom_layer2_weights rom_w1  (.addr(w1_addr), .index(w1_index), .data_out(rom_w1_data));
    rom_layer2_biases  rom_b1  (.addr(b1_addr), .data_out(rom_b1_data));
    rom_layer4_weights rom_w2  (.addr(w2_addr), .index(w2_index), .data_out(rom_w2_data));
    rom_layer4_biases  rom_b2  (.addr(b2_addr), .data_out(rom_b2_data));

    // Register ROM outputs each clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_in_data <= 16'sd0;
            rd_w0_data <= 16'sd0; rd_b0_data <= 16'sd0;
            rd_w1_data <= 16'sd0; rd_b1_data <= 16'sd0;
            rd_w2_data <= 16'sd0; rd_b2_data <= 16'sd0;
        end else begin
            rd_in_data <= rom_in_data;
            rd_w0_data <= rom_w0_data;
            rd_b0_data <= rom_b0_data;
            rd_w1_data <= rom_w1_data;
            rd_b1_data <= rom_b1_data;
            rd_w2_data <= rom_w2_data;
            rd_b2_data <= rom_b2_data;
        end
    end

    // Main control + MAC pipeline (safe for BRAM read latency)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset everything
            state <= IDLE;
            valid <= 1'b0;
            predicted_class <= 4'd0;
            predicted_class_final <= 4'd0;
            rom_sample_sel <= 4'd0;

            feat_idx <= 11'd0;
            neuron_idx <= 8'd0;
            out_idx <= 8'd0;

            input_addr <= 11'd0;
            w0_addr <= 11'd0; w0_index <= 8'd0; b0_addr <= 8'd0;
            w1_addr <= 8'd0; w1_index <= 7'd0; b1_addr <= 7'd0;
            w2_addr <= 7'd0; w2_index <= 4'd0; b2_addr <= 4'd0;

            accumulator <= 48'sd0;
            product <= 32'sd0;
            acc_shr <= 48'sd0;
            bias_ext <= 48'sd0;
            sum48 <= 48'sd0;
            final16 <= 16'sd0;
            max_val <= 16'sd0;

            debug_out0 <= 16'sd0; debug_out1 <= 16'sd0; debug_out2 <= 16'sd0; debug_out3 <= 16'sd0; debug_out4 <= 16'sd0;
            debug_out5 <= 16'sd0; debug_out6 <= 16'sd0; debug_out7 <= 16'sd0; debug_out8 <= 16'sd0; debug_out9 <= 16'sd0;
        end else begin
            // default clear valid (it pulses for one cycle when done)
            valid <= 1'b0;

            case (state)
                IDLE: begin
                    // wait for start; latch sample index
                    if (start) begin
                        rom_sample_sel <= sample_index;
                        // prepare to compute L0 neuron 0
                        neuron_idx <= 8'd0;
                        feat_idx <= 11'd0;
                        w0_index <= 8'd0;
                        w0_addr <= 11'd0;
                        input_addr <= 11'd0;
                        b0_addr <= 8'd0;
                        accumulator <= 48'sd0;
                        state <= L0_ADDR;
                    end
                end

                // present addresses for L0 (then data will be available in rd_* next cycle)
                L0_ADDR: begin
                    accumulator <= 48'sd0;
                    feat_idx <= 11'd0;
                    b0_addr <= neuron_idx;
                    state <= L0_MAC;
                end

                // MAC loop for L0: uses registered rd_in_data & rd_w0_data
                L0_MAC: begin
                    // Add debug for first feature and first few neurons
                    if (feat_idx < 5 && neuron_idx == 0) begin
                        $display("L0 MAC - Feature %0d, Neuron 0:", feat_idx);
                        $display("  Input: %d, Weight: %d", rd_in_data, rd_w0_data);
                        $display("  Product: %d", $signed(rd_in_data) * $signed(rd_w0_data));
                        $display("  Acc before: %d", accumulator);
                        $display("  Acc after: %d", accumulator + $signed({{16{product[31]}}, product}));
                    end

                    product <= $signed(rd_in_data) * $signed(rd_w0_data); // 32-bit signed
                    accumulator <= accumulator + $signed({{16{product[31]}}, product}); // extend to 48

                    if (feat_idx < FEAT_LEN - 1) begin
                        feat_idx <= feat_idx + 11'd1;
                        input_addr <= feat_idx + 11'd1;
                        w0_addr <= feat_idx + 11'd1;
                        w0_index <= neuron_idx;
                    end else begin
                        state <= L0_DONE;
                    end
                end

                // finalize L0 neuron
                L0_DONE: begin
                    // Add debug for first few neurons
                    if (neuron_idx < 5) begin
                        $display("L0 DONE - Neuron %0d:", neuron_idx);
                        $display("  Final Accumulator: %d", accumulator);
                        $display("  Shifted (>>> %0d): %d", Q, accumulator >>> Q);
                        $display("  Bias: %d", rd_b0_data);
                        $display("  Sum: %d", (accumulator >>> Q) + $signed({{32{rd_b0_data[15]}}, rd_b0_data}));
                    end

                    acc_shr <= accumulator >>> Q; // Q8.8 scaling
                    bias_ext <= {{32{rd_b0_data[15]}}, rd_b0_data};
                    sum48 <= acc_shr + bias_ext;
                    if (sum48 > 48'sd32767) final16 <= 16'sd32767;
                    else if (sum48 < -48'sd32768) final16 <= -16'sd32768;
                    else final16 <= sum48[15:0];

                    // ReLU
                    if (final16 < 0) layer0_out[neuron_idx] <= 16'sd0;
                    else layer0_out[neuron_idx] <= final16;

                    if (neuron_idx < L0_NEUR - 1) begin
                        neuron_idx <= neuron_idx + 8'd1;
                        w0_index <= neuron_idx + 8'd1;
                        w0_addr <= 11'd0;
                        input_addr <= 11'd0;
                        b0_addr <= neuron_idx + 8'd1;
                        accumulator <= 48'sd0;
                        feat_idx <= 11'd0;
                        state <= L0_MAC;
                    end else begin
                        // finished L0 -> move to L1
                        neuron_idx <= 8'd0;
                        feat_idx <= 11'd0;
                        w1_index <= 7'd0;
                        w1_addr <= 8'd0;
                        b1_addr <= 7'd0;
                        accumulator <= 48'sd0;
                        state <= L1_ADDR;
                    end
                end

                // L1 address presenation
                L1_ADDR: begin
                    feat_idx <= 11'd0;
                    w1_addr <= 8'd0;
                    w1_index <= neuron_idx;
                    b1_addr <= neuron_idx[6:0];
                    accumulator <= 48'sd0;
                    state <= L1_MAC;
                end

                // L1 MAC: multiply layer0_out[feat_idx] (combinational) with rd_w1_data (registered)
                L1_MAC: begin
                    // Add debug for first few features of first neuron
                    if (feat_idx < 5 && neuron_idx == 0) begin
                        $display("L1 MAC - Feature %0d, Neuron 0:", feat_idx);
                        $display("  Layer0 output: %d, Weight: %d", layer0_out[feat_idx], rd_w1_data);
                        $display("  Product: %d", $signed(layer0_out[feat_idx]) * $signed(rd_w1_data));
                    end

                    product <= $signed(layer0_out[feat_idx]) * $signed(rd_w1_data);
                    accumulator <= accumulator + $signed({{16{product[31]}}, product});
                    if (feat_idx < L0_NEUR - 1) begin
                        feat_idx <= feat_idx + 11'd1;
                        w1_addr <= feat_idx + 11'd1;
                        w1_index <= neuron_idx;
                    end else begin
                        state <= L1_DONE;
                    end
                end

                L1_DONE: begin
                    // Add debug for first few neurons
                    if (neuron_idx < 5) begin
                        $display("L1 DONE - Neuron %0d:", neuron_idx);
                        $display("  Final Accumulator: %d", accumulator);
                        $display("  Shifted (>>> %0d): %d", Q, accumulator >>> Q);
                        $display("  Bias: %d", rd_b1_data);
                    end

                    acc_shr <= accumulator >>> Q;
                    bias_ext <= {{32{rd_b1_data[15]}}, rd_b1_data};
                    sum48 <= acc_shr + bias_ext;
                    if (sum48 > 48'sd32767) final16 <= 16'sd32767;
                    else if (sum48 < -48'sd32768) final16 <= -16'sd32768;
                    else final16 <= sum48[15:0];

                    if (final16 < 0) layer1_out[neuron_idx] <= 16'sd0;
                    else layer1_out[neuron_idx] <= final16;

                    if (neuron_idx < L1_NEUR - 1) begin
                        neuron_idx <= neuron_idx + 8'd1;
                        feat_idx <= 11'd0;
                        w1_index <= neuron_idx + 8'd1;
                        w1_addr <= 8'd0;
                        b1_addr <= neuron_idx + 7'd1;
                        accumulator <= 48'sd0;
                        state <= L1_MAC;
                    end else begin
                        // finished L1 -> move to output layer
                        out_idx <= 8'd0;
                        feat_idx <= 11'd0;
                        w2_index <= 4'd0;
                        w2_addr <= 7'd0;
                        b2_addr <= 4'd0;
                        accumulator <= 48'sd0;
                        state <= OUT_ADDR;
                    end
                end

                // OUT address presenation
                OUT_ADDR: begin
                    feat_idx <= 11'd0;
                    w2_index <= out_idx[3:0];
                    w2_addr <= 7'd0;
                    b2_addr <= out_idx[3:0];
                    accumulator <= 48'sd0;
                    state <= OUT_MAC;
                end

                // OUT MAC
                OUT_MAC: begin
                    // Debug output layer calculations for class 2
                    if (out_idx == 2 && feat_idx < 5) begin
                        $display("OUT MAC - Class 2, Feature %0d:", feat_idx);
                        $display("  Layer1 output: %d, Weight: %d", layer1_out[feat_idx], rd_w2_data);
                        $display("  Product: %d", $signed(layer1_out[feat_idx]) * $signed(rd_w2_data));
                    end

                    product <= $signed(layer1_out[feat_idx]) * $signed(rd_w2_data);
                    accumulator <= accumulator + $signed({{16{product[31]}}, product});
                    if (feat_idx < L1_NEUR - 1) begin
                        feat_idx <= feat_idx + 11'd1;
                        w2_addr <= feat_idx + 11'd1;
                        w2_index <= out_idx[3:0];
                    end else begin
                        state <= OUT_DONE;
                    end
                end

                OUT_DONE: begin
                    // Debug output for all classes
                    $display("OUT DONE - Class %0d:", out_idx);
                    $display("  Final Accumulator: %d", accumulator);
                    $display("  Shifted (>>> %0d): %d", Q, accumulator >>> Q);
                    $display("  Bias: %d", rd_b2_data);
                    $display("  Final sum: %d", (accumulator >>> Q) + $signed({{32{rd_b2_data[15]}}, rd_b2_data}));

                    acc_shr <= accumulator >>> Q;
                    bias_ext <= {{32{rd_b2_data[15]}}, rd_b2_data};
                    sum48 <= acc_shr + bias_ext;
                    if (sum48 > 48'sd32767) final16 <= 16'sd32767;
                    else if (sum48 < -48'sd32768) final16 <= -16'sd32768;
                    else final16 <= sum48[15:0];

                    output_out[out_idx] <= final16;

                    // store debug logits
                    case (out_idx)
                        0: debug_out0 <= final16;
                        1: debug_out1 <= final16;
                        2: debug_out2 <= final16;
                        3: debug_out3 <= final16;
                        4: debug_out4 <= final16;
                        5: debug_out5 <= final16;
                        6: debug_out6 <= final16;
                        7: debug_out7 <= final16;
                        8: debug_out8 <= final16;
                        9: debug_out9 <= final16;
                    endcase

                    if (out_idx < OUT_NEUR - 1) begin
                        out_idx <= out_idx + 8'd1;
                        feat_idx <= 11'd0;
                        w2_addr <= 7'd0;
                        w2_index <= out_idx + 8'd1;
                        b2_addr <= out_idx + 4'd1;
                        accumulator <= 48'sd0;
                        state <= OUT_MAC;
                    end else begin
                        // Call debug task before finding max
                        debug_layer_outputs;
                        
                        // move to find max
                        out_idx <= 8'd1;
                        max_val <= output_out[0];
                        predicted_class <= 4'd0;
                        state <= FIND_MAX;
                    end
                end

                // Argmax
                FIND_MAX: begin
                    if (out_idx < OUT_NEUR) begin
                        // Debug argmax process
                        $display("FIND_MAX - Comparing class %0d: %d with current max (class %0d): %d", 
                                out_idx, output_out[out_idx], predicted_class, max_val);
                                
                        if (output_out[out_idx] > max_val) begin
                            max_val <= output_out[out_idx];
                            predicted_class <= out_idx[3:0];
                            $display("  New max! Class %0d is now the predicted class", out_idx);
                        end
                        out_idx <= out_idx + 8'd1;
                    end else begin
                        state <= DONE_PULSE;
                    end
                end

                // one-cycle valid pulse
                DONE_PULSE: begin
                    valid <= 1'b1;
                    // latch final stable result so waveform/testbench can read one stable reg
                    predicted_class_final <= predicted_class;
                    $display("FINAL PREDICTION: Class %0d", predicted_class);
                    state <= WAIT_START;
                end


                // wait for start release before new run
                WAIT_START: begin
                    if (!start) begin
                        neuron_idx <= 8'd0;
                        feat_idx <= 11'd0;
                        out_idx <= 8'd0;
                        accumulator <= 48'sd0;
                        product <= 32'sd0;
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule