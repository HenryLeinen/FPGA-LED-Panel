transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Repositories/FPGA/Altera/LED\ Panel/FPGA-LED-Panel {D:/Repositories/FPGA/Altera/LED Panel/FPGA-LED-Panel/pll.v}
vlog -vlog01compat -work work +incdir+D:/Repositories/FPGA/Altera/LED\ Panel/FPGA-LED-Panel {D:/Repositories/FPGA/Altera/LED Panel/FPGA-LED-Panel/led_panel.v}
vlog -vlog01compat -work work +incdir+D:/Repositories/FPGA/Altera/LED\ Panel/FPGA-LED-Panel {D:/Repositories/FPGA/Altera/LED Panel/FPGA-LED-Panel/dpram.v}
vlog -vlog01compat -work work +incdir+D:/Repositories/FPGA/Altera/LED\ Panel/FPGA-LED-Panel {D:/Repositories/FPGA/Altera/LED Panel/FPGA-LED-Panel/dimmer.v}
vlog -vlog01compat -work work +incdir+D:/Repositories/FPGA/Altera/LED\ Panel/FPGA-LED-Panel {D:/Repositories/FPGA/Altera/LED Panel/FPGA-LED-Panel/ext_mem.v}
vlog -vlog01compat -work work +incdir+D:/Repositories/FPGA/Altera/LED\ Panel/FPGA-LED-Panel {D:/Repositories/FPGA/Altera/LED Panel/FPGA-LED-Panel/de0ledpanel.v}
vlog -vlog01compat -work work +incdir+D:/Repositories/FPGA/Altera/LED\ Panel/FPGA-LED-Panel/db {D:/Repositories/FPGA/Altera/LED Panel/FPGA-LED-Panel/db/pll_altpll.v}

vlog -vlog01compat -work work +incdir+D:/Repositories/FPGA/Altera/LED\ Panel/FPGA-LED-Panel/simulation/modelsim {D:/Repositories/FPGA/Altera/LED Panel/FPGA-LED-Panel/simulation/modelsim/led_panel_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  led_panel_tb

add wave *
view structure
view signals
run -all
