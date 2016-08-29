
module cpu (
	clk_clk,
	pio_led_external_connection_export,
	pio_wr_addr_connection_export,
	pio_wr_data_connection_export,
	pio_wr_in_flags_export,
	pio_wr_out_flags_export,
	reset_reset_n);	

	input		clk_clk;
	output	[7:0]	pio_led_external_connection_export;
	output	[11:0]	pio_wr_addr_connection_export;
	output	[23:0]	pio_wr_data_connection_export;
	input	[7:0]	pio_wr_in_flags_export;
	output	[7:0]	pio_wr_out_flags_export;
	input		reset_reset_n;
endmodule
