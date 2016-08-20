onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /led_panel/clk
add wave -noupdate /led_panel/rst
add wave -noupdate /led_panel/RED
add wave -noupdate /led_panel/GREEN
add wave -noupdate /led_panel/BLUE
add wave -noupdate /led_panel/A
add wave -noupdate /led_panel/LE
add wave -noupdate /led_panel/OE_N
add wave -noupdate /led_panel/selected_buffer
add wave -noupdate /led_panel/actual_buffer
add wave -noupdate /led_panel/rd_addr
add wave -noupdate /led_panel/rd_data_hi
add wave -noupdate /led_panel/rd_data_lo
add wave -noupdate /led_panel/frame_start
add wave -noupdate /led_panel/col_start
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1025392 ps}
view wave 
wave clipboard store
wave create -pattern none -portmode input -language vlog /led_panel/clk 
wave create -pattern none -portmode input -language vlog /led_panel/rst 
wave create -pattern none -portmode output -language vlog -range 1 0 /led_panel/RED 
wave create -pattern none -portmode output -language vlog -range 1 0 /led_panel/GREEN 
wave create -pattern none -portmode output -language vlog -range 1 0 /led_panel/BLUE 
wave create -pattern none -portmode output -language vlog -range 3 0 /led_panel/A 
wave create -pattern none -portmode output -language vlog /led_panel/LE 
wave create -pattern none -portmode output -language vlog /led_panel/OE_N 
wave create -pattern none -portmode input -language vlog /led_panel/selected_buffer 
wave create -pattern none -portmode output -language vlog /led_panel/actual_buffer 
wave create -pattern none -portmode output -language vlog -range 9 0 /led_panel/rd_addr 
wave create -pattern none -portmode input -language vlog -range 23 0 /led_panel/rd_data_hi 
wave create -pattern none -portmode input -language vlog -range 23 0 /led_panel/rd_data_lo 
wave create -pattern none -portmode output -language vlog /led_panel/frame_start 
wave create -pattern none -portmode output -language vlog /led_panel/col_start 
wave modify -driver freeze -pattern clock -initialvalue 0 -period 10ns -dutycycle 50 -starttime 0us -endtime 1000us Edit:/led_panel/clk 
wave modify -driver freeze -pattern constant -value 1 -starttime 0ns -endtime 1000ns Edit:/led_panel/rst 
WaveCollapseAll -1
wave clipboard restore
