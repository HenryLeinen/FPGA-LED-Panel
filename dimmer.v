module dimmer #(parameter COLS=5) (
						rst,
						clk,
						
						trigger,
						
						wr_addr,
						wr_data,
						wr_ena,
						
						selected_buffer,
						actual_buffer,
						
						LED
					);
	
	input								rst;
	input								clk;
	input								trigger;
	
	
	reg [4:0]						wr_row;
	reg [COLS-1:0]					wr_col;
	
	reg [7:0]						wr_red, wr_green, wr_blue;		

	output  wire [5+COLS-1:0]	wr_addr = {wr_row[4:0], wr_col[COLS-1:0]};
	output  wire [23:0]			wr_data = {wr_blue[7:0], wr_green[7:0], wr_red[7:0]};
	output 							wr_ena;
	
	output							selected_buffer;
	input								actual_buffer;
	
	output reg [7:0]				LED;
	
	reg								selected_buffer;
	reg								wr_ena;
	
	reg	[1:0]						state_d, state_q;
	localparam						IDLE = 2'b00,
										FILL_START = 2'b01,
										FILL_N1 = 2'b10,
										WAIT = 2'b11;
	reg	[1:0]						color_pattern_d, color_pattern_q;
	localparam						RED = 2'b00,
										BLUE = 2'b01,
										GREEN = 2'b10,
										SWAMP = 2'b11;
	
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			state_d <= IDLE;
			selected_buffer <= 0;
			wr_ena <= 0;
			wr_red <= 10;
			wr_green <= 10;
			wr_blue <= 10;
			color_pattern_d <= GREEN;
		end else begin
			if (!trigger) begin
				color_pattern_d = color_pattern_q + 1;
			end
			
			case (state_q)
				IDLE:
					begin
						if (!trigger) begin
							wr_row <= 0;
							wr_col <= 0;
							state_d <= FILL_START;
						end
					end
					
				FILL_START:
					begin
						wr_ena <= 1;
						state_d <= FILL_N1;
					end
					
				FILL_N1:
					begin
						wr_ena <= 0;
						if (wr_col == ((1<<COLS)-1)) begin
							wr_col = 0;
							if (wr_row == 31) begin
								wr_row = 0;
								state_d <= WAIT;
							end else begin
								wr_row = wr_row + 1;
								state_d <= FILL_START;
							end
						end else begin
							wr_col = wr_col + 1;
							state_d <= FILL_START;
						end
						if (color_pattern_q == SWAMP) begin
							wr_blue = wr_row << 3;
							wr_red  = wr_col << 3;
						end
					end
					
				WAIT:
					begin
						if (actual_buffer == selected_buffer) begin
							selected_buffer <= !selected_buffer;
							case (color_pattern_q)
								RED: 
									begin
										wr_red <= wr_red + 1;
										LED <= wr_red;
										if (wr_red == 0) begin
											if (trigger) color_pattern_q <= color_pattern_d;
										end
									end
								BLUE: 
									begin
										wr_blue <= wr_blue + 1;
										LED <= wr_blue;
										if (wr_blue == 0) begin
											if (trigger) color_pattern_q <= color_pattern_d;
										end
									end
								GREEN:	
									begin
										wr_green <= wr_green + 1;
										LED <= wr_red;
										if (wr_green == 0) begin
											if (trigger) color_pattern_q <= color_pattern_d;
										end
									end
								SWAMP:
									begin
										wr_green = wr_green + 1;
										if (wr_green == 0) begin
											if (trigger) color_pattern_q <= color_pattern_d;
										end
									end
							endcase
							state_d <= FILL_START;
						end else begin
							state_d <= WAIT;
						end
					end
			endcase
			state_q <= state_d;
		end
	end
endmodule
