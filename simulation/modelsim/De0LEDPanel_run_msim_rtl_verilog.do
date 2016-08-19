transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Henry/Documents/Altera/Projects {C:/Users/Henry/Documents/Altera/Projects/pll.v}
vlog -vlog01compat -work work +incdir+C:/Users/Henry/Documents/Altera/Projects {C:/Users/Henry/Documents/Altera/Projects/led_panel.v}
vlog -vlog01compat -work work +incdir+C:/Users/Henry/Documents/Altera/Projects {C:/Users/Henry/Documents/Altera/Projects/dpram.v}
vlog -vlog01compat -work work +incdir+C:/Users/Henry/Documents/Altera/Projects {C:/Users/Henry/Documents/Altera/Projects/de0ledpanel.v}
vlog -vlog01compat -work work +incdir+C:/Users/Henry/Documents/Altera/Projects/db {C:/Users/Henry/Documents/Altera/Projects/db/pll_altpll.v}

