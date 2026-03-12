## Clock signal (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -name sys_clk_pin -period 10.00 [get_ports clk]


### Reset Button (Center Button BTNC)
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## USB-RS232 Interface (To see "OK" in Telnet)
set_property PACKAGE_PIN A18 [get_ports usb_tx]
set_property IOSTANDARD LVCMOS33 [get_ports usb_tx]


## UART on PMOD JA (for Pmod ESP32)

## JA2 ? FPGA RX (connected to ESP32 TX)
set_property PACKAGE_PIN L2 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]

## JA3 ? FPGA TX (connected to ESP32 RX)
set_property PACKAGE_PIN J2 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports rx]
