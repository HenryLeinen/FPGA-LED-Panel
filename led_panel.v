`define FRAME_TIME 250

module led_panel	(
							clk,
							rst,

							//	LED Panel wires
							RED,
							GREEN,
							BLUE,

							//	The row address wires [3..0]
							A,
							
							//	Latch enable (which is low active)
							LE,
							//	Output enable (which is low active)
							OE_N,
							//	Clock signal for the shift registers (RED, GREEN, BLUE)
							CLK,
							
							//	Memory addressing signals (which is front and which is back buffer)
							selected_buffer,
							actual_buffer,
														
							rd_addr,
							rd_data_hi,
							rd_data_lo,
							
							frame_start,
							col_start
							
						);


						
	input						clk;
	input						rst;
	
	output reg	[1:0]		RED;
	output reg	[1:0]		GREEN;
	output reg	[1:0]		BLUE;
	
	output reg	[3:0]		A;
	output reg				LE;
	output reg				OE_N;
	output reg				CLK;
	
	input						selected_buffer;
	output reg				actual_buffer;
		
	output wire[10:0]		rd_addr;
	input		  [23:0] 	rd_data_hi, rd_data_lo;
		
		
	output reg				frame_start;			//	is set to 1 in case a new frame is started
	output reg				col_start;				//	is set to 1 as long as column data is clocked out
	
	//	State machine stuff
	localparam	IDLE 		= 3'b000,
					WAIT 		= 3'b001,				//	disable clock, wait until slice timer expires
					BLANK 	= 3'b010,				//	disable outputs and set new address a[3:0]
					LATCH 	= 3'b011,				//	latch new data le to 1 
					UNBLANK 	= 3'b100,			//	enable outputs oe_n to 0, increment bit plane, if all bitplanes displayed, increment row if all rows displayed
					READ 		= 3'b101,				//	clock to 0,
					SHIFT 	= 3'b110,			//	clock to 1, goto WAIT if all columns routed, otherwise goto SHIFT_1
					PRE_READ	= 3'b111;

	reg [2:0]	state;								//	This is the state variable

	//	Timing control
	reg [15:0]	time_slice_time = 0;				//	The timer counts ticks until the next time slice becomes active
	reg [7:0]	bit_plane = 0;						//	The counter counts the time slices (from 0 to 255)
	
	
	//	Pixel control
	reg [5:0]	col;
	reg [3:0]	row;
	
	wire [7:0]  pixel_red_hi, pixel_red_lo;
	wire [7:0]	pixel_green_hi, pixel_green_lo;
	wire [7:0]	pixel_blue_hi, pixel_blue_lo;
	
	//	Pixel RGB logic, direct addressing reading
	assign pixel_red_hi 		= rd_data_hi[7:0];
	assign pixel_green_hi	= rd_data_hi[15:8];
	assign pixel_blue_hi		= rd_data_hi[23:16];
	assign pixel_red_lo 		= rd_data_lo[7:0];
	assign pixel_green_lo	= rd_data_lo[15:8];
	assign pixel_blue_lo		= rd_data_lo[23:16];

	assign		rd_addr = {actual_buffer, row[3:0], col[5:0]};
	
		
	//	Procedural block
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			A = 4'b0;
			OE_N = 1;
			RED = 2'b11;
			GREEN = 2'b11;
			BLUE = 2'b11;
			LE = 1;
			CLK = 0;
			state = PRE_READ;
			bit_plane = 0;			//	Just for debugging, otherwise 0
			time_slice_time = 125; 
			col = 0;
			row = 0;
			frame_start = 0;
			col_start = 0;
			actual_buffer = 0;
		end else begin
			if (time_slice_time != 0) begin
					time_slice_time = time_slice_time - 1;
			end
			
			case (state)
			
				//	Wait for timeslice to elapse so that we can begin to latch the shifted values though
				WAIT:
					begin
						CLK = 0;
						if (time_slice_time == 0) begin
							//	Time slice elapsed, so move on to the next
							state = BLANK;
						end else begin
							state = WAIT;
						end
					end
				
				//	Just switch off the LEDs
				BLANK:
					begin
						OE_N = 1;
						state = LATCH;
					end

				// Latch the data and advance to the next timeslice or row
				LATCH:
					begin
						LE = 1;
						A = row;
						time_slice_time = 125; //	250 for framerate of 100Hz at clock of 100MHz
														//	125 for framerate of 100Hz at clock of 50MHz

						bit_plane = bit_plane + 1;
						if (bit_plane == 0) begin
							//	wrapped around --> all rows processed
							row = row + 1;
							if (row == 0) begin
								//	wrapped around --> all rows processed
								frame_start = 1;
								actual_buffer = selected_buffer;	//	Take over new buffer request
							end else begin
								frame_start = 0;
							end
						end
						
						state = UNBLANK;
					end
					
				UNBLANK:
					begin
						LE = 0;
						col_start = 1;
						state = PRE_READ;
					end
					
				PRE_READ:
					begin
						OE_N = 0;
						CLK = 0;
						state = READ;
					end
					
				//	Transition clock to low
				//	Determine and set new shiftregister values
				READ:	
					begin
						CLK = 0;
						if (pixel_red_hi 		> bit_plane) RED[0] = 1; 	else RED[0] = 0;
						if (pixel_red_lo 		> bit_plane) RED[1] = 1; 	else RED[1] = 0;
						if (pixel_green_hi 	> bit_plane) GREEN[0] = 1; else GREEN[0] = 0;
						if (pixel_green_lo	> bit_plane) GREEN[1] = 1; else GREEN[1] = 0;
						if (pixel_blue_hi		> bit_plane) BLUE[0] = 1; else BLUE[0] = 0;
						if (pixel_blue_lo		> bit_plane) BLUE[1] = 1; else BLUE[1] = 0;
						state = SHIFT;
					end
				
				//	Clock the new values in and check if all values are clocked in already
				SHIFT:
					begin
						CLK = 1;
						col = col + 1;
						if (col == 0) begin
							//	wrapped around --> all columns processed
							state = WAIT;		//	proceed to next row
							col_start = 0;
						end else begin	
							state = READ;		//	proceed with next column
						end
					end
									
			endcase
		end
	end
	
endmodule
	