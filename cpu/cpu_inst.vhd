	component cpu is
		port (
			clk_clk                            : in  std_logic                     := 'X';             -- clk
			pio_led_external_connection_export : out std_logic_vector(7 downto 0);                     -- export
			pio_wr_addr_connection_export      : out std_logic_vector(11 downto 0);                    -- export
			pio_wr_data_connection_export      : out std_logic_vector(23 downto 0);                    -- export
			pio_wr_in_flags_export             : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			pio_wr_out_flags_export            : out std_logic_vector(7 downto 0);                     -- export
			reset_reset_n                      : in  std_logic                     := 'X'              -- reset_n
		);
	end component cpu;

	u0 : component cpu
		port map (
			clk_clk                            => CONNECTED_TO_clk_clk,                            --                         clk.clk
			pio_led_external_connection_export => CONNECTED_TO_pio_led_external_connection_export, -- pio_led_external_connection.export
			pio_wr_addr_connection_export      => CONNECTED_TO_pio_wr_addr_connection_export,      --      pio_wr_addr_connection.export
			pio_wr_data_connection_export      => CONNECTED_TO_pio_wr_data_connection_export,      --      pio_wr_data_connection.export
			pio_wr_in_flags_export             => CONNECTED_TO_pio_wr_in_flags_export,             --             pio_wr_in_flags.export
			pio_wr_out_flags_export            => CONNECTED_TO_pio_wr_out_flags_export,            --            pio_wr_out_flags.export
			reset_reset_n                      => CONNECTED_TO_reset_reset_n                       --                       reset.reset_n
		);

