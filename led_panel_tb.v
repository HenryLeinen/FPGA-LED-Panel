module led_panel_tb ();

	reg			clk, rst, selected_buffer;
	wire 			frame_start, col_start;
	wire 	[1:0]	RED, GREEN, BLUE;
	wire  [3:0] A;
	wire	OE_N, LE, CLK, actual_buffer;
	
	wire	[9:0] rd_addr;
	wire  [23:0] rd_data_hi, rd_data_lo;
	
	led_panel DUT (
		.clk(clk),
		.rst(rst),
		.RED(RED),
		.GREEN(GREEN),
		.BLUE(BLUE),
		.A(A),
		.OE_N(OE_N),
		.LE(LE),
		.CLK(CLK),
		.selected_buffer(selected_buffer),
		.actual_buffer(actual_buffer),
		
		.rd_addr(rd_addr),
		.rd_data_hi(rd_data_hi),
		.rd_data_lo(rd_data_lo),
		
		.frame_start(frame_start),
		.col_start(col_start)
	);
		
		
	initial begin
		clk = 0;
		rst = 0;
		selected_buffer = 0;
		
		forever #5 clk = ~clk;
	end
	
	initial begin
		repeat (1) @(posedge clk);
		rst = 1;
		repeat (1) @(posedge clk);
		rst = 0;
		
		repeat (2000) @(posedge clk);
		$finish;
		
	end
endmodule
