	cpu u0 (
		.clk_clk                            (<connected-to-clk_clk>),                            //                         clk.clk
		.pio_led_external_connection_export (<connected-to-pio_led_external_connection_export>), // pio_led_external_connection.export
		.pio_wr_addr_connection_export      (<connected-to-pio_wr_addr_connection_export>),      //      pio_wr_addr_connection.export
		.pio_wr_data_connection_export      (<connected-to-pio_wr_data_connection_export>),      //      pio_wr_data_connection.export
		.pio_wr_in_flags_export             (<connected-to-pio_wr_in_flags_export>),             //             pio_wr_in_flags.export
		.pio_wr_out_flags_export            (<connected-to-pio_wr_out_flags_export>),            //            pio_wr_out_flags.export
		.reset_reset_n                      (<connected-to-reset_reset_n>)                       //                       reset.reset_n
	);

