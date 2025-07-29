# Hardware Accelerator for Keyword Spotting

This project implements a complete pipeline for real-time keyword spotting, from audio preprocessing to a hardware-ready neural network accelerator in Verilog. The system recognizes spoken commands such as `up`, `down`, `left`, `right`, `go`, `stop`, `yes`, `no`, `forward`, and `backward`.

---

## 🚀 Project Overview

- **Audio Preprocessing:** Converts raw audio files to MFCC features.
- **Neural Network Training:** Trains a compact neural network in Python (Keras).
- **Quantization:** Calibrates and converts the model to 8-bit (Q8.8) fixed-point for hardware.
- **Verilog Implementation:** Generates ROM modules and a synthesizable neural network inference engine, ready for FPGA deployment.

---

## 📊 Results

- **Floating-point accuracy:** 86%
- **Quantized (Q8.8) accuracy:** 60%
- **Classes:** up, down, left, right, go, stop, yes, no, forward, backward


---

## 📝 How It Works

### 1. Audio Preprocessing

- Extracts 13 MFCC coefficients from each 1-second audio file.
- Flattens to a 1274-dimensional feature vector.
- Stores all features and labels in a CSV file.

### 2. Model Training

- Loads the dataset, encodes labels, and normalizes features.
- Trains a neural network: 1274 → 256 → 128 → 10 (softmax).
- Achieves 86% accuracy on the test set.

### 3. Quantization

- Calibrates per-layer scale factors using the 99.9th percentile.
- Converts weights, biases, and test samples to int8, then to Q8.8 fixed-point.
- Achieves 60% accuracy after quantization.

### 4. Verilog Generation

- Python scripts generate Verilog ROM modules for all weights, biases, and test samples.
- The main Verilog module implements the neural network inference engine in Q8.8.
- Testbench provided for simulation and verification.

---

## 💡 Key Features

- **End-to-end pipeline:** Audio → MFCC → Neural Net → Quantization → Verilog
- **Calibrated quantization:** Per-layer scaling for best accuracy
- **FPGA-ready:** All modules are synthesizable and ready for hardware deployment
- **Automated code generation:** Scripts for ROM and testbench creation

---

## ⚡ How to Use

1. **Extract MFCC features:**  
   Use the provided Python scripts in `audio_preprocessing/` to process your audio files.

2. **Train the neural network:**  
   Run the scripts in `model_training/` to train and quantize the model.

3. **Generate Verilog ROMs:**  
   Use the ROM generator scripts to create Verilog modules from quantized weights and test data.

4. **Simulate in Vivado/ModelSim:**  
   Add all Verilog files in `verilog/` to your project and run the testbench.

5. **FPGA Deployment:**  
   Synthesize the design and program your FPGA board (see notes below).

---

## 🖥️ FPGA Implementation Notes

- The design is fully synthesizable and ready for FPGA deployment.
- For real-time performance, parallel MAC units or pipelining can be added.
- The Q8.8 format is optimized for FPGA DSP slices and block RAM.
- The current design is sequential for clarity and resource efficiency.

---

## 📈 Limitations and Future Work

- Full simulation of large models is slow in software; on FPGA, inference will be real-time.
- Future improvements: parallel MACs, pipelined architecture, int4 quantization, live audio input.

---

## 🤝 Acknowledgements

- [Librosa](https://librosa.org/) for audio processing
- [TensorFlow/Keras](https://www.tensorflow.org/) for neural network training
- [Xilinx Vivado](https://www.xilinx.com/products/design-tools/vivado.html) for Verilog simulation

---

## 📬 Contact

For questions or collaboration, please open an issue or contact [shubhammeena.iit@gmail.com.com](mailto:your.email@domain.com).

---
