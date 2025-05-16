# Radix-4-booth-Multiplier
Implementation of 4 bit and 8 bit multiplication using Radix-4 multiplier.

##  Overview

This project implements both 4-bit and 8-bit **Radix-4 Booth Multipliers** using Verilog.  
The design is based on a **datapath and controller FSM** architecture, aimed at efficient signed multiplication using the Booth encoding technique.

Both versions simulate the multiplication of signed numbers using the Radix-4 algorithm, reducing the number of partial products and improving performance compared to basic shift-and-add methods.

---

##  Features

-  Radix-4 Booth encoding logic (grouping, decoding)
-  Structural datapath with:
-  A and B registers
-  Partial product generation
-  Control FSM
-  Shift and accumulation logic
-  Separate designs for:
-  **4-bit × 4-bit**
-  **8-bit × 8-bit**
-  Fully synthesizable and testbench-verifiable
-  XDC files provided for Testing on Basys 3 board
-  Signed multiplication support (2’s complement)

## 📂 File Structure

4bit/ contains:
- radix4_4bit.v – Verilog code for 4-bit Radix-4 Booth multiplier

- radix4_4bit_tb.v – Testbench for simulation

- radix4_4bit.xdc – FPGA constraints file

8bit/  contains:
- radix4_8bit.v – Verilog code for 8-bit Radix-4 Booth multiplier

- radix4_8bit_tb.v – Testbench for simulation

- radix4_8bit.xdc – FPGA constraints file
