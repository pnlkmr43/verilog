
# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]




##Buttons
set_property PACKAGE_PIN U18 [get_ports resetn]						
set_property IOSTANDARD LVCMOS33 [get_ports resetn]


## SPI MOSI -> JA1
set_property PACKAGE_PIN J1 [get_ports spi_mosi]
set_property IOSTANDARD LVCMOS33 [get_ports spi_mosi]

## SPI CLK -> JA2
set_property PACKAGE_PIN L2 [get_ports spi_clk]
set_property IOSTANDARD LVCMOS33 [get_ports spi_clk]

## Data/Command -> JA3
set_property PACKAGE_PIN J2 [get_ports dc]
set_property IOSTANDARD LVCMOS33 [get_ports dc]

## LCD Reset -> JA4
set_property PACKAGE_PIN G2 [get_ports reset_lcd]
set_property IOSTANDARD LVCMOS33 [get_ports reset_lcd]
