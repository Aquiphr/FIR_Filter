// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
// Date        : Thu May  5 15:53:22 2022
// Host        : ubuntu-machineP running 64-bit Ubuntu 20.04.4 LTS
// Command     : write_verilog -force -mode synth_stub /home/mashood/aquiphr_ws/REBUILD_TEST/ip/h_rom/h_rom_stub.v
// Design      : h_rom
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2017.4" *)
module h_rom(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[6:0],douta[15:0]" */;
  input clka;
  input [6:0]addra;
  output [15:0]douta;
endmodule
