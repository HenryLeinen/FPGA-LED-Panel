
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module De0LEDPanel(

	//////////// CLOCK //////////
	CLOCK_50,

	//////////// LED //////////
	LED,

	//////////// KEY //////////
	KEY,

	//////////// FRAME ///////////
	FRAME,
	COL,
	
//	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	RED,
	GREEN,
	BLUE,
	A,
	OE,
	LATCH,
	CLK
);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input 		          		CLOCK_50;

//////////// LED //////////
output		     [7:0]		LED;

//////////// KEY //////////
input 		     [1:0]		KEY;

//////////// FRAME //////////
output							FRAME;
output							COL;

//////////// LED PANEL signals //////////////
output			  [1:0]		RED;			//	RED[0] 	= GPIO31, RED[1] 	 = GPIO21
output			  [1:0]		GREEN;		//	GREEN[0] = GPIO33, GREEN[1] = GPIO23
output			  [1:0]		BLUE;			//	BLUE[0]	= GPIO32, BLUE[1]	 = GPIO22
output			  [3:0]		A;				//	GPIO_24..GPIO27 = A0 .. A3
output			  				CLK;			//	GPIO28
output							LATCH;		//	GPIO29
output							OE;			//	GPIO30


//=======================================================
//  REG/WIRE declarations
//=======================================================

	wire 							clk100,
									clk50,
									clk25,
									clk10;

	wire							actual_buffer, selected_buffer;

	wire			[23:0]		wr_data;
	wire			[10:0]		wr_addr;
	wire							wr_ena;
	wire			[23:0]		rd_data_hi, rd_data_lo;
	wire			[10:0]		rd_addr;
	
//=======================================================
//  Structural coding
//=======================================================

//	Instantiate the PLL to generate a couple of new clocks
	pll	pll(
		.inclk0(CLOCK_50),
		.c0(clk100),
		.c1(clk50),
		.c2(clk25),
		.c3(clk10)
	);

//	Instantiate the memory wrapper
	ext_mem		memory(
		.clk(clk100),
		.wr_addr(wr_addr),
		.wr_data(wr_data),
		.wr_ena(wr_ena),
		.rd_addr(rd_addr),
		.rd_data_hi(rd_data_hi),
		.rd_data_lo(rd_data_lo),
		.actual_buffer(actual_buffer)
	);
	
//	Instantiate the LED Panel driver
	led_panel	led_panel (
		.clk(clk100),
		.rst(KEY[0]),
		.RED(RED),
		.GREEN(GREEN),
		.BLUE(BLUE),
		.A(A),
		.LE(LATCH),
		.OE_N(OE),
		.CLK(CLK),
		
		.selected_buffer(selected_buffer),
		.actual_buffer(actual_buffer),
		
		.rd_addr(rd_addr),
		.rd_data_hi(rd_data_hi),
		.rd_data_lo(rd_data_lo),
		
		//	DEBUG SIGNALS
		.frame_start(FRAME),
		.col_start(COL)
	);
	
//	Instantiate the automatic dimmer module
	dimmer	dimmer(
		.clk(clk50),
		.rst(KEY[0]),
		.trigger(KEY[1]),
		.wr_addr(wr_addr),
		.wr_data(wr_data),
		.wr_ena(wr_ena),
		.selected_buffer(selected_buffer),
		.actual_buffer(actual_buffer),
		.LED(LED)

	);
endmodule
