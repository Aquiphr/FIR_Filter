//////////////////////////////////////////////////////////////////////////////////
//
//  Module : fir_co
//  Created : 12/16/2018
//  Author(s) : Mashood Ul Hassan, Sameem Ahmed Malik.
//  
//  Copyright (c) 2022, Mashood Ul Hassan & Sameem Ahmed Malik, All rights reserved.
// 
//  Description :
//  
//  this is the top module for a 73-tap digital fir filter. it included
//  the main fsmd that processes the input samples at a fixed rate (1MS/s).
//  this can be adjusted by changing the sampling signal. this is a 
//  discrete-form realization of said filter, and utulizes 2 adders
//  and 1 dsp multiplier to compute output samples.
//
//  top module of a symmetric digital fir filter. initially the target
//  device for this project was Spartan3AN starter kit(xc3s700an) and 
//  for demo purpose some logic has been added to target that board.
//
//////////////////////////////////////////////////////////////////////////////////


module fir_co (
  input             clk      ,  // system clock
	input             reset    ,  // sync reset  
	input             sel      ,  // selection of either byte of Y-sample
	input             sw       ,  // manual increment of OUT_RAM address
//	input [7:0] y_ra,
	output            clk_1MHz ,  // sampling clock, for on-chip debug
	output            st       ,  // indicates start filter operation
	output     [11:0] x_bus    ,  // for on-chip debug 
	output     [15:0] h_bus    ,  // for on-chip debug
//	output signed [15:0] buff_out,
	output            filt     ,  // indicates filt operation complete
	output     [15:0] y_out    ,  // output samples appear
	output reg [ 7:0] half_data   // 1Byte of Y-sample
);

// ====== Local Parameters =================================================	 

localparam [3:0] FETCH = 4'b0000,  // fetches new input sample from INP_ROM
			           PROC  = 4'b0001,  // MAC operations 
                 REDUC = 4'b0010,  // reduction of accumulator bits
                 WRT   = 4'b0011,  // writing Y-samples to OUT_RAM
                 DONE  = 4'b0100;  // lets user cycle through Y-samples

// ====== Internal signals =================================================					  

// COEFF_ROM signals
reg        [ 6:0] h_indx    ;  // for addressing COEFF_ROM
		
// INP_ROM signals
reg        [ 6:0] x_indx    ;  // for addressing INP_ROM

// OUT_RAM signals
reg signed [15:0] y_in      ;  // write data port			  
wire       [ 7:0] y_ra      ;  // read address port
reg        [ 7:0] y_wa      ;  // write address port
reg               w_en_y    ;  // write enable

// Misc internal signals
reg        [ 7:0] adr_read  ;  // counter to address read port on OUT_RAM
reg        [ 6:0] buff_indx ;  // counter to index <buf_reg>
reg signed [16:0] part_sum  ;  // to staore partial sum
reg signed [32:0] prod      ;  // to store product of <part_sum> and h(n)
reg signed [38:0] accm      ;  // final result accumulator
reg               i         ;  // keep fsm in PROC state 1 extra cycle

reg signed [15:0] buf_reg [0:72];  // delay line for x(n) samples

reg        [ 3:0] state     ;  // state register

wire              sw_s      ;  // pulse used to increment <adr_read> 

// ====== Module instantiations ============================================

smpl_sig #( .COUNT(24) ) SIG (
  .clk        ( clk      ), 
  .reset      ( reset    ), 
  .sample_sig ( clk_1MHz ), 
  .st         ( st       )
);
	 
smpl_pulse U1 (
  .clk    ( clk   ), 
  .reset  ( reset ), 
  .sig    ( sw    ), 
  .st     ( sw_s  )
);
    
h_rom COEFF_ROM (
  .clka   ( clk    ),    // input wire clka
  .addra  ( h_indx ),  // input wire [6 : 0] addra
  .douta  ( h_bus  )  // output wire [15 : 0] douta
);

x_rom INP_ROM (
  .clka   ( clk    ),    // input wire clka
  .addra  ( x_indx ),  // input wire [6 : 0] addra
  .douta  ( x_bus  )  // output wire [11 : 0] douta
);

y_ram OUT_RAM (
  .clka   ( clk    ),    // input wire clka
  .wea    ( w_en_y ),      // input wire [0 : 0] wea
  .addra  ( y_wa   ),  // input wire [7 : 0] addra
  .dina   ( y_in   ),    // input wire [15 : 0] dina
  .clkb   ( clk    ),    // input wire clkb
  .addrb  ( y_ra   ),  // input wire [7 : 0] addrb
  .doutb  ( y_out  )  // output wire [15 : 0] doutb
);

// ====== FSM with datapath ================================================

always @(posedge clk) begin
  if(reset) begin
			state <= FETCH;
			i <= 0;
//			buff_in <= 0;
			y_in <= 0;
			buff_indx <= 0;
			x_indx <= 0;
			h_indx <= 0;
			y_wa <= 0;
//			w_en_buff <= 0;
			w_en_y <= 0;
//			mul_h <= 0;
//			mul_h2 <= 0;
//			mul_x <= 0;
			part_sum <= 0;
			prod <= 0;
			accm <= 0;
			adr_read <= 0;
//			adj_op <= 0;
			buf_reg[0] <= 0;
			buf_reg[1] <= 0;
			buf_reg[2] <= 0;
			buf_reg[3] <= 0;
			buf_reg[4] <= 0;
			buf_reg[5] <= 0;
			buf_reg[6] <= 0;
			buf_reg[7] <= 0;
			buf_reg[8] <= 0;
			buf_reg[9] <= 0;
			buf_reg[10] <= 0;
			buf_reg[11] <= 0;
			buf_reg[12] <= 0;
			buf_reg[13] <= 0;
			buf_reg[14] <= 0;
			buf_reg[15] <= 0;
			buf_reg[16] <= 0;
			buf_reg[17] <= 0;
			buf_reg[18] <= 0;
			buf_reg[19] <= 0;
			buf_reg[20] <= 0;
			buf_reg[21] <= 0;
			buf_reg[22] <= 0;
			buf_reg[23] <= 0;
			buf_reg[24] <= 0;
			buf_reg[25] <= 0;
			buf_reg[26] <= 0;
			buf_reg[27] <= 0;
			buf_reg[28] <= 0;
			buf_reg[29] <= 0;
			buf_reg[30] <= 0;
			buf_reg[31] <= 0;
			buf_reg[32] <= 0;
			buf_reg[33] <= 0;
			buf_reg[34] <= 0;
			buf_reg[35] <= 0;
			buf_reg[36] <= 0;
			buf_reg[37] <= 0;
			buf_reg[38] <= 0;
			buf_reg[39] <= 0;
			buf_reg[40] <= 0;
			buf_reg[41] <= 0;
			buf_reg[42] <= 0;
			buf_reg[43] <= 0;
			buf_reg[44] <= 0;
			buf_reg[45] <= 0;
			buf_reg[46] <= 0;
			buf_reg[47] <= 0;
			buf_reg[48] <= 0;
			buf_reg[49] <= 0;
			buf_reg[50] <= 0;
			buf_reg[51] <= 0;
			buf_reg[52] <= 0;
			buf_reg[53] <= 0;
			buf_reg[54] <= 0;
			buf_reg[55] <= 0;
			buf_reg[56] <= 0;
			buf_reg[57] <= 0;
			buf_reg[58] <= 0;
			buf_reg[59] <= 0;
			buf_reg[60] <= 0;
			buf_reg[61] <= 0;
			buf_reg[62] <= 0;
			buf_reg[63] <= 0;
			buf_reg[64] <= 0;
			buf_reg[65] <= 0;
			buf_reg[66] <= 0;
			buf_reg[67] <= 0;
			buf_reg[68] <= 0;
			buf_reg[69] <= 0;
			buf_reg[70] <= 0;
			buf_reg[71] <= 0;
			buf_reg[72] <= 0;
  end
		
  else begin
			
			case(state)
			
			FETCH : begin
				if(st) begin
					if(x_indx < 100) begin
						buf_reg[0] <= {x_bus[11], x_bus[11], x_bus[11], x_bus[11], x_bus};						
						x_indx <= x_indx + 1;
					end
					else begin
						buf_reg[0] <= 0;
						x_indx <= 100;
					end
					
					buf_reg[1] <= buf_reg[0];
					buf_reg[2] <= buf_reg[1];
					buf_reg[3] <= buf_reg[2];
					buf_reg[4] <= buf_reg[3];
					buf_reg[5] <= buf_reg[4];
					buf_reg[6] <= buf_reg[5];
					buf_reg[7] <= buf_reg[6];
					buf_reg[8] <= buf_reg[7];
					buf_reg[9] <= buf_reg[8];
					buf_reg[10] <= buf_reg[9];
					buf_reg[11] <= buf_reg[10];
					buf_reg[12] <= buf_reg[11];
					buf_reg[13] <= buf_reg[12];
					buf_reg[14] <= buf_reg[13];
					buf_reg[15] <= buf_reg[14];
					buf_reg[16] <= buf_reg[15];
					buf_reg[17] <= buf_reg[16];
					buf_reg[18] <= buf_reg[17];
					buf_reg[19] <= buf_reg[18];
					buf_reg[20] <= buf_reg[19];
					buf_reg[21] <= buf_reg[20];
					buf_reg[22] <= buf_reg[21];
					buf_reg[23] <= buf_reg[22];
					buf_reg[24] <= buf_reg[23];
					buf_reg[25] <= buf_reg[24];
					buf_reg[26] <= buf_reg[25];
					buf_reg[27] <= buf_reg[26];
					buf_reg[28] <= buf_reg[27];
					buf_reg[29] <= buf_reg[28];
					buf_reg[30] <= buf_reg[29];
					buf_reg[31] <= buf_reg[30];
					buf_reg[32] <= buf_reg[31];
					buf_reg[33] <= buf_reg[32];
					buf_reg[34] <= buf_reg[33];
					buf_reg[35] <= buf_reg[34];
					buf_reg[36] <= buf_reg[35];
					buf_reg[37] <= buf_reg[36];
					buf_reg[38] <= buf_reg[37];
					buf_reg[39] <= buf_reg[38];
					buf_reg[40] <= buf_reg[39];
					buf_reg[41] <= buf_reg[40];
					buf_reg[42] <= buf_reg[41];
					buf_reg[43] <= buf_reg[42];
					buf_reg[44] <= buf_reg[43];
					buf_reg[45] <= buf_reg[44];
					buf_reg[46] <= buf_reg[45];
					buf_reg[47] <= buf_reg[46];
					buf_reg[48] <= buf_reg[47];
					buf_reg[49] <= buf_reg[48];
					buf_reg[50] <= buf_reg[49];
					buf_reg[51] <= buf_reg[50];
					buf_reg[52] <= buf_reg[51];
					buf_reg[53] <= buf_reg[52];
					buf_reg[54] <= buf_reg[53];
					buf_reg[55] <= buf_reg[54];
					buf_reg[56] <= buf_reg[55];
					buf_reg[57] <= buf_reg[56];
					buf_reg[58] <= buf_reg[57];
					buf_reg[59] <= buf_reg[58];
					buf_reg[60] <= buf_reg[59];
					buf_reg[61] <= buf_reg[60];
					buf_reg[62] <= buf_reg[61];
					buf_reg[63] <= buf_reg[62];
					buf_reg[64] <= buf_reg[63];
					buf_reg[65] <= buf_reg[64];
					buf_reg[66] <= buf_reg[65];
					buf_reg[67] <= buf_reg[66];
					buf_reg[68] <= buf_reg[67];
					buf_reg[69] <= buf_reg[68];
					buf_reg[70] <= buf_reg[69];
					buf_reg[71] <= buf_reg[70];
					buf_reg[72] <= buf_reg[71];
					
					state <= PROC;
        end
				
				else
					state <= FETCH;
			
			end
			
			PROC : begin
					if(buff_indx < 36) begin

						part_sum <= buf_reg[buff_indx] + buf_reg[72-buff_indx];
						prod <= part_sum * $signed(h_bus); 
						accm <= prod + accm;
						h_indx <= h_indx + 1;
						buff_indx <= buff_indx + 1;
						
						state <= PROC;
					end
					else begin

						part_sum <= buf_reg[buff_indx] + 0;
						prod <= part_sum * $signed(h_bus); 
						accm <= prod + accm;

						if(~i) begin
							i <= ~i;
							state <= PROC;
						end
						else begin
							i <= 0;
							h_indx <= 0;
							buff_indx <= 0;
							state <= REDUC;
						end	
					
					end
			end
			
			REDUC : begin
				if(accm[38]) begin
					if(&accm[37:27])
						y_in <= accm[26:11];
					else
						y_in <= 16'b100_0000000000000;
				end
				else begin
					
					if(|accm[37:27])
						y_in <= 16'b011_1111111111111;
					else
						y_in <= accm[26:11];
				
				end
				
				state <= WRT;
				w_en_y <= 1;
			
			end
			
			WRT : begin
				if(y_wa < 171) begin
					y_wa <= y_wa + 1;
					accm <= 0;
					w_en_y <= 0;
					state <= FETCH;
				end
				else begin
					y_wa <= 0;
					w_en_y <= 0;
					state <= DONE;
				end
			end
			
			DONE : begin
				if(~sel)
					half_data <= y_out[7:0];
				else
					half_data <= y_out[15:8];
					
				if(adr_read < 172) begin
					if(sw_s)
						adr_read <= adr_read + 1;
					else
						adr_read <= adr_read;
				end
				else
					adr_read <= 0;
					
				state <= DONE;
			end
			
			default : state <= FETCH;
			
			endcase
  end		
end

assign y_ra = adr_read; // redundant ?

assign filt = (state == DONE);  // indicates filtering is complete

endmodule
