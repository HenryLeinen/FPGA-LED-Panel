
`timescale 1ps / 1ps
module \led_panel_tb.v   ; 

parameter READ  = 3'b101 ;
parameter LATCH  = 3'b011 ;
parameter BLANK  = 3'b010 ;
parameter WAIT  = 3'b001 ;
parameter PRE_READ  = 3'b111 ;
parameter SHIFT  = 3'b110 ;
parameter IDLE  = 3'b000 ;
parameter UNBLANK  = 3'b100 ; 
  wire  [1:0]  BLUE   ; 
  reg  [23:0]  rd_data_lo   ; 
  reg    rst   ; 
  wire  [3:0]  A   ; 
  wire  reg  LE   ; 
  wire  reg  OE_N   ; 
  wire  [1:0]  RED   ; 
  reg  [23:0]  rd_data_hi   ; 
  wire  reg  frame_start   ; 
  wire  [9:0]  rd_addr   ; 
  wire  [1:0]  GREEN   ; 
  reg    clk   ; 
  wire  reg  CLK   ; 
  reg    selected_buffer   ; 
  wire  reg  col_start   ; 
  wire  reg  actual_buffer   ; 
  led_panel    #( READ , LATCH , BLANK , WAIT , PRE_READ , SHIFT , IDLE , UNBLANK  )
   DUT  ( 
       .BLUE (BLUE ) ,
      .rd_data_lo (rd_data_lo ) ,
      .rst (rst ) ,
      .A (A ) ,
      .LE (LE ) ,
      .OE_N (OE_N ) ,
      .RED (RED ) ,
      .rd_data_hi (rd_data_hi ) ,
      .frame_start (frame_start ) ,
      .rd_addr (rd_addr ) ,
      .GREEN (GREEN ) ,
      .clk (clk ) ,
      .CLK (CLK ) ,
      .selected_buffer (selected_buffer ) ,
      .col_start (col_start ) ,
      .actual_buffer (actual_buffer ) ); 



// "Clock Pattern" : dutyCycle = 50
// Start Time = 0 ps, End Time = 1 ms, Period = 10 ns
  initial
  begin
	  clk  = 1'b0  ;
	 # 1000 ;
// dumped values till 1 ns
	always #5 clk = ~clk;
  end

// "Constant Pattern"
// Start Time = 0 ps, End Time = 1 us, Period = 0 ps
  initial
  begin
	  rst  = 1'b1  ;
	 # 1000 ;
// dumped values till 1 ns
  end

  initial
	#2000 $stop;
endmodule
