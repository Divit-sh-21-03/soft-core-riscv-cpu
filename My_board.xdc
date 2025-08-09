## Constrain clock and led[2] to satisfy DRC UCIO-1
set_property PACKAGE_PIN D14 [get_ports clk]                     # Clock on CCIO (D14)
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0 5} [get_ports clk]

set_property PACKAGE_PIN M10 [get_ports {led[2]}]                # led[2] on M10
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]

## 1. Clock input — must be on a GCLK/CCIO pin
##    Use FPGA package pin D14 (IO_L11P_T1_SRCC_14), which is clock-capable
# (Already constrained above)

## 2. Reset button — assign to CCIO complementary pin for best routing
set_property PACKAGE_PIN B12 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

## 3. LED outputs — map silkscreen LEDs (M1,M3,J2,P2,K4,P4,L3,J4,M4,L5,P11,N11,P13,M14,M12,K12)
set_property PACKAGE_PIN D10  [get_ports {led[0]}]
set_property PACKAGE_PIN C10  [get_ports {led[1]}]
# led[2] already constrained above
set_property PACKAGE_PIN A10  [get_ports {led[3]}]
set_property PACKAGE_PIN A12  [get_ports {led[4]}]
set_property PACKAGE_PIN A13  [get_ports {led[5]}]
set_property PACKAGE_PIN B13  [get_ports {led[6]}]
set_property PACKAGE_PIN B14  [get_ports {led[7]}]
set_property PACKAGE_PIN C11  [get_ports {led[8]}]
set_property PACKAGE_PIN C12  [get_ports {led[9]}]
set_property PACKAGE_PIN F12  [get_ports {led[10]}]
set_property PACKAGE_PIN E12  [get_ports {led[11]}]
set_property PACKAGE_PIN D12  [get_ports {led[12]}]
set_property PACKAGE_PIN D13  [get_ports {led[13]}]
set_property PACKAGE_PIN G14  [get_ports {led[14]}]
set_property PACKAGE_PIN F14  [get_ports {led[15]}]

## 4. Set IO standard for all LEDs
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

## 5. (Optional) suppress clock-dedicated route rule if you must
# set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_IBUF]
