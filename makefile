baud-test:
	iverilog -o behaivoral_tests/baud_gen_tb/baud_gen.vvp  behaivoral_tests/baud_gen_tb/baud_gen_tb.sv baud_gen.v
	vvp -n behaivoral_tests/baud_gen_tb/baud_gen.vvp

rx-test:
	iverilog -g2012 -o behaivoral_tests/uart_rx_tb/rx_test.vvp  behaivoral_tests/uart_rx_tb/uart_rx_tb.sv uart_rx.v baud_gen.v
	vvp -n behaivoral_tests/uart_rx_tb/rx_test.vvp

chip-diagram:
	dot -T png chip.dot -o chip.png