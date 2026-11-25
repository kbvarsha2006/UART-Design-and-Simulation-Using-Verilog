# UART Design and Simulation using Verilog

## Project Objective
Design and simulate a UART transmitter and receiver using Verilog HDL and open-source tools.

## Features
- 8-bit serial data transmission and reception
- 1 start bit (LOW)
- 8 data bits (LSB first)
- 1 stop bit (HIGH)
- 115200 baud configuration for a 100 MHz clock
- Parameterized clock cycles per bit

## Tools Used
- Icarus Verilog
- GTKWave
- Yosys

## Project Files
- uart_tx.v - UART transmitter
- uart_rx.v - UART receiver
- uart_tb.v - Testbench
- uart.vcd - Simulation waveform
- synthesis/ - Synthesized Verilog files and logs

## Baud Rate Configuration
Default CLKS_PER_BIT = 868 for a 100 MHz clock and approximately 115200 baud.

The testbench uses CLKS_PER_BIT = 868 in both modules to verify operation at approximately 115200 baud.

## Simulation Results

| Transmitted | Received | Result |
|---|---|---|
| A5 | A5 | PASS |
| 3C | 3C | PASS |
| 00 | 00 | PASS |
| FF | FF | PASS |

All four test cases passed using TX-to-RX loopback simulation.

## Synthesis
Both transmitter and receiver were synthesized using Yosys.
Both modules passed the Yosys check with zero reported problems.

## Conclusion
The UART transmitter and receiver were successfully designed, simulated and synthesized using open-source tools.
