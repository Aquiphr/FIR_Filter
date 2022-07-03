# FIR_Filter
A resource constarined hardware implementation of a 73-tap FIR filter.

## Design 
This design uses a self-testing FSM, which controls the flow of data from `INP_ROM` to internal register file `buf_reg` and then stores output samples into `OUT_RAM`.

`[TODO#01] : Add input and Coeffs...`

## Architecture
The design using only single multiplier and 2 adders to filter the input sequence. 

![fig_0](./docs/assets/filt_hw_diagram.png?raw=true "Simplified MAC unit")

## Building Design
- Use the _build.tcl_ script within vivado to create the project and add all sources.
- (Optional) Synthesize the design.
- Run the testbench _fir_co_tb.v_ from __verif/testbench__.

## Sample Output
`[TODO#02] : Add waveforms and sample output from testbench.`