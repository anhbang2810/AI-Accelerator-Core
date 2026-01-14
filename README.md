#  AI Accelerator Core (NPU Processor) on FPGA

![Language](https://img.shields.io/badge/Language-SystemVerilog-blue)
![Tools](https://img.shields.io/badge/Tools-Quartus%20Prime%20%7C%20ModelSim-green)
![Status](https://img.shields.io/badge/Status-Completed-success)

> **Dự án thiết kế Bộ vi xử lý NPU (Neural Processing Unit) tùy biến, hỗ trợ tính toán song song pipeline 3 tầng và thực thi tập lệnh AI chuyên dụng.**

---

## 📖 Tổng quan (Overview)

Dự án này tập trung thiết kế và hiện thực hóa một lõi phần cứng chuyên dụng cho các tác vụ Trí tuệ nhân tạo (AI) trên nền tảng FPGA. Khác với các thiết kế mạch số cơ bản, hệ thống này được xây dựng dưới dạng một **System-on-Chip (SoC)** hoàn chỉnh với kiến trúc Harvard, bao gồm CPU, Bộ nhớ và Lõi tính toán.

Hệ thống có khả năng thực hiện các phép toán nhân chập (Convolution/Dot Product) và hàm kích hoạt phi tuyến (ReLU) - hai thành phần cốt lõi của Mạng nơ-ron nhân tạo (ANN).

##  Tính năng nổi bật (Key Features)

* **Kiến trúc Harvard:** Tách biệt Bộ nhớ Lệnh (Instruction ROM) và Bộ nhớ Dữ liệu (Data RAM) giúp tăng băng thông xử lý.
* **3-Stage Pipeline Processing Element (PE):**
    1.  **Stage 1:** Nhân số nguyên có dấu (Signed Multiplier).
    2.  **Stage 2:** Cộng dồn (Accumulator) với thanh ghi mở rộng 20-bit chống tràn.
    3.  **Stage 3:** Hàm kích hoạt ReLU & Bão hòa (Saturation) đầu ra 8-bit.
* **Programmable Control Unit:** Bộ điều khiển FSM hỗ trợ thực thi tập lệnh tùy biến (Firmware).
* **Backdoor Memory Loading:** Kỹ thuật nạp dữ liệu trực tiếp vào RAM/ROM trong quá trình mô phỏng SystemVerilog.

##  Kiến trúc Hệ thống (Architecture)

Hệ thống bao gồm 4 khối chính kết nối qua bus nội bộ:

1.  **Control Unit (CU):** "Bộ não" của chip, giải mã lệnh Fetch-Decode-Execute.
2.  **Processing Element (PE):** Đơn vị thực thi toán học (ALU).
3.  **Instruction Memory:** Chứa mã máy (Firmware).
4.  **Data Memory:** Chứa Feature Map và Weights.

### 📜 Tập lệnh (Instruction Set Architecture - ISA)

| Opcode | Mnemonic | Operand (12-bit) | Mô tả |
| :--- | :--- | :--- | :--- |
| `0011` | **CALC** | `Length` | Kích hoạt PE tính toán vector với độ dài `Length`. |
| `1111` | **HALT** | `0` | Dừng hệ thống. |

---

##  Kết quả Mô phỏng (Simulation Results)

Hệ thống đã được kiểm chứng thành công trên **ModelSim**.

### 1. Kịch bản kiểm thử (Test Scenario)
* **Input:** Vector Feature `[10, 5, 2]` và Weight `[2, -3, 4]`.
* **Bias:** `5`.
* **Phép tính:** `(10*2) + (5*-3) + (2*4) + 5 = 18`.

### 2. Giản đồ xung (Waveform)
*(Hình ảnh mô phỏng cấp hệ thống, cho thấy Control Unit tự động điều khiển dòng dữ liệu)*

![System Simulation](https://github.com/anhbang2810/AI-Accelerator-Core/blob/main/images/system_waveform.png?raw=true)
> *Kết quả: Tín hiệu `result_out` trả về giá trị **18** (`00010010`) và `result_valid` mức cao -> **CHÍNH XÁC**.*

---

##  Cấu trúc Thư mục (Folder Structure)

```text
├── npu_pe.sv                 # Lõi tính toán (Processing Element)
├── control_unit.sv           # Bộ điều khiển FSM
├── data_memory.sv            # RAM dữ liệu
├── instruction_memory.sv     # ROM chứa Firmware
├── npu_processor_top.sv      # Top-level SoC Wrapper
├── tb_npu_processor_top.sv   # Testbench tự động (System Level)
└── README.md                 # Tài liệu dự án
