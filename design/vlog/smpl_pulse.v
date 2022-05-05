//////////////////////////////////////////////////////////////////////////////////
//
//  Module : smpl_pulse
//  Created : 12/16/2018
//  Author(s) : Mashood Ul Hassan, Sameem Ahmed Malik.
//
//  Copyright (c) 2022, Mashood Ul Hassan & Sameem Ahmed Malik, All rights reserved.
//  
//  Description :
//  
//  simple positive edge detection circuit. although, the input is not
//  registered first so glitches might be introduced if <sig> is not
//  registered externally.
//  
//////////////////////////////////////////////////////////////////////////////////


module smpl_pulse (
	input  clk   ,
	input  reset ,
	input  sig   ,
	output st
);

reg d_ff;

always @(posedge clk) begin
		if(reset)
			d_ff <= 0;
		else
			d_ff <= sig;
end

assign st = (sig & ~d_ff) ? 1'b1 : 1'b0;

endmodule
