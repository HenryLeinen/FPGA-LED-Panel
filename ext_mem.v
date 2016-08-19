module ext_mem (
						clk,
						
						rd_addr,
						rd_data_hi,
						rd_data_lo,
						
						wr_addr,
						wr_data,
						wr_ena,
						
						actual_buffer
						
					);
					
	input 						clk;
	
	input 	[9:0]				rd_addr;
	output  [23:0]				rd_data_lo;
	output  [23:0]				rd_data_hi;
	
	input		[9:0]				wr_addr;
	input	  [23:0]				wr_data;
	input							wr_ena;
	
	input							actual_buffer;
		
		
	//	Memory writing control
	wire			we_hi			= wr_ena && !wr_addr[9];	//	Lower address region selects ram_hi
	wire			we_lo			= wr_ena && wr_addr[9];		//	Upper address region selects ram_lo
		
		
//	Instantiate the two memory components
	dpram ram_hi(
		.data(wr_data),
		.rdaddress(rd_addr),
		.clock(clk),
		.wraddress({actual_buffer, wr_addr[8:0]}),
		.wren(we_hi),
		.q(rd_data_hi)
	);
	dpram ram_lo(
		.data(wr_data),
		.rdaddress(rd_addr),
		.clock(clk),
		.wraddress({actual_buffer,wr_addr[8:0]}),
		.wren(we_lo),
		.q(rd_data_lo)
	);

endmodule

	