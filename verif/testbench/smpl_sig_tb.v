`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  Module : fir_co_tb
//  Created : 12/16/2018
//  Author(s) : Mashood Ul Hassan, Sameem Ahmed Malik.
//  
//  Copyright (c) 2022, Mashood Ul Hassan & Sameem Ahmed Malik, All rights reserved.
//  
//  Description :
//  
//  testbench for smpl_sig.sv module. only provides simple stimulus.
//  
//////////////////////////////////////////////////////////////////////////////////

module smpl_sig_tb;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire clk_1MHz;
	wire st;

	// Instantiate the Unit Under Test (UUT)
	smpl_sig uut (
		.clk(clk), 
		.reset(reset), 
		.clk_1MHz(clk_1MHz), 
		.st(st)
	);
	
	always begin
		clk = 1;
		#10;
		clk = 0;
		#10;
	end

	initial begin
		// Initialize Inputs
		reset = 1;

		// Wait 100 ns for global reset to finish
		#40;
		
		reset = 0;
        
		repeat(250) @(posedge clk);
		
		$stop;

	end
      
endmodule

