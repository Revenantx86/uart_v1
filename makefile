baud-test:
	iverilog -o behaivoral_tests/baud_gen_tb/baud_gen.vvp  behaivoral_tests/baud_gen_tb/baud_gen_tb.sv baud_gen.v
	vvp -n behaivoral_tests/baud_gen_tb/baud_gen.vvp