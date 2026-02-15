# Wi-Fi Interfacing on Basys3 FPGA using PMOD ESP32

This project implements a **UART-based communication interface** between a **Basys3 FPGA (Artix-7)** and a **PMOD ESP32 Wi-Fi module** using **Verilog HDL**.
The design enables the FPGA to send and receive serial data, forming the foundation for FPGA-based wireless and IoT applications.

## Overview

A custom UART core is designed in hardware to handle serial communication with the ESP32.
The system includes a baud rate generator, transmitter, receiver, and an FSM-based control unit, along with a simulation testbench for verification.

## Features

* UART transmitter and receiver in Verilog
* Configurable baud rate generator
* FSM-based control logic
* Simulation testbench
* Basys3 constraint file for hardware implementation

## Tools & Hardware

**Tools**

* Xilinx Vivado
* Verilog HDL

**Hardware**

* Basys3 FPGA (Artix-7)
* PMOD ESP32 Wi-Fi module

## Project Structure

```
src/           → Verilog design files
constraints/   → XDC pin constraint file
sim/           → Simulation testbench
```

## Modules

* `top.v` – Top-level integration module
* `baudgen.v` – Baud rate generator
* `transmitter.v` – UART transmitter
* `receiver.v` – UART receiver
* `fsm.v` – Control state machine
* `transmitter_tb.v` – Testbench for simulation

## Applications

* FPGA-based IoT systems
* Wireless data interfaces
* Embedded communication designs
