module dimmer (
						rst,
						clk,
						
						trigger,
						
						wr_addr,
						wr_data,
						wr_ena,
						
						selected_buffer,
						actual_buffer
					);
	
	input								rst;
	input								clk;
	input								trigger;
	
	
	reg [4:0]						wr_row;
	reg [5:0]						wr_col;
	
	reg [7:0]						wr_red, wr_green, wr_blue;		

	output  wire [10:0]			wr_addr = {wr_row[4:0], wr_col[5:0]};
	output  wire [23:0]			wr_data = {wr_blue[7:0], wr_green[7:0], wr_red[7:0]};
	output 							wr_ena;
	
	output							selected_buffer;
	input								actual_buffer;
	
	reg								selected_buffer;
	reg								wr_ena;
	
	reg	[1:0]						state;
	localparam						IDLE = 2'b00,
										FILL_START = 2'b01,
										FILL_N1 = 2'b10,
										WAIT = 2'b11;
	reg	[1:0]						color_pattern_d, color_pattern_q;
	localparam						RED = 2'b00,
										BLUE = 2'b01,
										GREEN = 2'b10,
										SWAMP = 2'b11;

	reg  [10:0]						swamp_counter;
	
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			state <= IDLE;
			selected_buffer <= 0;
			wr_ena <= 0;
			wr_red <= 0;
			wr_green <= 0;
			wr_blue <= 0;
			swamp_counter <= 0;
			color_pattern_d <= GREEN;
		end else begin
			if (!trigger) begin
				color_pattern_d = color_pattern_q + 1;
			end
			
			case (state)
				IDLE:
					begin
						if (!trigger) begin
							wr_row = 0;
							wr_col = 0;
							state = FILL_START;
						end
					end
					
				FILL_START:
					begin
						wr_ena = 1;
						state = FILL_N1;
					end
					
				FILL_N1:
					begin
						wr_ena = 0;
						wr_col = wr_col + 1;
						if (wr_col == 0) begin //	Wrapped
							//	proceed to next row
							wr_row = wr_row + 1;
							if (wr_row == 0) begin 	// wrapped
								state = WAIT;
							end else begin
								state = FILL_START;
							end
						end else begin
							state = FILL_START;
						end						
						
						if (color_pattern_q == SWAMP) begin
							if (wr_addr == swamp_counter) begin
								wr_blue = 255;
								wr_red  = 255;
								wr_green= 255;
							end else begin
								wr_blue = 0;
								wr_red = 0;
								wr_green = 0;
							end
						end
					end
					
				WAIT:
					begin
						if (actual_buffer == selected_buffer) begin
							selected_buffer <= !selected_buffer;
							case (color_pattern_q)
								RED: 
									begin
										wr_red = wr_red + 1;
										wr_green = 0;
										wr_blue = 0;
										if (wr_red == 0) begin
											if (trigger) color_pattern_q = color_pattern_d;
										end
									end
								BLUE: 
									begin
										wr_blue = wr_blue + 1;
										wr_green = 0;
										wr_red = 0;
										if (wr_blue == 0) begin
											if (trigger) color_pattern_q = color_pattern_d;
										end
									end
								GREEN:	
									begin
										wr_green = wr_green + 1;
										wr_red = 0;
										wr_blue = 0;
										if (wr_green == 0) begin
											if (trigger) color_pattern_q = color_pattern_d;
										end
									end
								SWAMP:
									begin
										if (wr_addr == 0) begin
											swamp_counter = swamp_counter + 1;
											if (trigger) color_pattern_q = color_pattern_d;
										end
									end
							endcase
							state = FILL_START;
						end else begin
							state = WAIT;
						end
					end
			endcase
		end
	end
endmodule
