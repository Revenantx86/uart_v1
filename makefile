timer:
	iverilog -o timer_test.vvp  timer_tb.sv timer.sv
	vvp -n timer_test.vvpls