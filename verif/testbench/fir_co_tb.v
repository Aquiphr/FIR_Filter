`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  Module : fir_co_tb
//  Created : 12/23/2018
//  Author(s) : Mashood Ul Hassan, Sameem Ahmed Malik.
//  
//  Copyright (c) 2022, Mashood Ul Hassan & Sameem Ahmed Malik, All rights reserved.
//  
//  Description :
//  
//  testbench for fir_co.v module. only provides simple stimulus, the actual
//  test is built into design. filter successful operation is indicated
//  by active HIGH signal <filt>. and <st> pulse, generated internally, 
//  shows start of operation.
//  
//////////////////////////////////////////////////////////////////////////////////

module fir_co_tb;

	// Inputs
	reg clk;
	reg reset;
	reg sel;
	reg sw;

	// Outputs
	wire clk_1MHz;
	wire st;
	wire [11:0] x_bus;
	wire [15:0] h_bus;
	wire filt;
	wire [15:0] y_out;
	wire [7:0] half_data;

	// Instantiate the Unit Under Test (UUT)
	fir_co UUT (
		.clk(clk), 
		.reset(reset), 
		.sel(sel), 
		.sw(sw), 
		.clk_1MHz(clk_1MHz), 
		.st(st), 
		.x_bus(x_bus), 
		.h_bus(h_bus), 
		.filt(filt), 
		.y_out(y_out), 
		.half_data(half_data)
	);
	
	always begin
		clk = 0;
		#10;
		clk = 1;
		#10;
	end
	
	initial begin
		reset = 1;
		#40;
		reset = 0;
	end

	initial begin
		// Initialize Inputs
		sel = 0;
    sw = 0;
		
		wait(filt == 1);
		
		repeat(2)@(negedge clk);
		sw = 1;
		
		@(negedge clk);
		
		sw = 0;
        
		repeat(2)@(negedge clk);
		sw = 1;
		
		@(negedge clk);
		
		sw = 0;
        
		repeat(2)@(negedge clk);
		sw = 1;
		// Add stimulus here

    repeat(2)@(posedge clk);
        
    $stop;
	end
      
endmodule

