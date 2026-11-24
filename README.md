# UART Design and Simulation using Verilog

## Project Objective
Design and simulate a UART transmitter and receiver using Verilog HDL and open-source tools.

## Features
- Serial data transmission
- Serial data reception
- 8-bit data communication
- 1 start bit and 1 stop bit
- TX and RX loopback testing

## Tools Used
- Verilog HDL
- Icarus Verilog
- GTKWave
- Yosys

## Project Files
- uart_tx.v - UART transmitter
- uart_rx.v - UART receiver
- uart_tb.v - Testbench
- uart.vcd - Simulation waveform
- synthesis/ - Synthesized Verilog files and logs

## Simulation Results
Four test cases were successfully verified:

| Transmitted | Received | Result |
|---|---|---|
| A5 | A5 | PASS |
| 3C | 3C | PASS |
| 00 | 00 | PASS |
| FF | FF | PASS |

## Synthesis
Both transmitter and receiver were synthesized using Yosys.
Both modules passed the Yosys check with zero reported problems.

## Conclusion
The UART transmitter and receiver were successfully designed and verified through loopback simulation.
