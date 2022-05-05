//////////////////////////////////////////////////////////////////////////////////
//
//  Module : smpl_sig
//  Created : 12/16/2018
//  Author(s) : Mashood Ul Hassan, Sameem Ahmed Malik.
//
//  Copyright (c) 2022, Mashood Ul Hassan & Sameem Ahmed Malik, All rights reserved.
//  
//  Description :
//  
//  this module generates a sampling signal from a counter. the counter is
//  parameterizable to allow configuration as per use. e.g:
//  
//  to generate 1MHz (Tp=1000ns) signal from 50MHz (Tp=20ns) clock
//      1000ns / 20ns = 50 
//      50     / 2    = 25
//      so, COUNT     = 25-1 = 24, this is not ideal it's just how 
//  the counter wraps-around that we have to subtract '1' here. 
//  
//////////////////////////////////////////////////////////////////////////////////


module smpl_sig #(parameter COUNT=24) (
  input      clk      ,
	input      reset    ,
	output reg sample_sig ,  // sampling signal
	output     st
);

localparam WIDTH = $clog2(COUNT);

reg [WIDTH - 1:0] count;

smpl_pulse pulse_gen (
    .clk(clk), 
    .reset(reset), 
    .sig(sample_sig), 
    .st(st)
    );

// simple counter that 
always @(posedge clk) begin
		if(reset) begin
			count <= 'd0;
			sample_sig <= 1'b0;
		end
		else begin
			if(count < COUNT) begin
				count <= count + 1'b1;
			end
			else begin
				count <= 'd0;
				sample_sig <= ~sample_sig;
			end
		end
end

endmodule
