export DESIGN_NAME = uart
export PLATFORM    = sky130hd

export VERILOG_FILES = ./user_design/$(DESIGN_NICKNAME)/uart.v \
	./user_design/$(DESIGN_NICKNAME)/uart_rx.v \
	./user_design/$(DESIGN_NICKNAME)/uart_tx.v \
	./user_design/$(DESIGN_NICKNAME)/baud_gen.v 

export SDC_FILE      = ./user_design/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION = 75
export CORE_ASPECT_RATIO = 1.5
export FP_PDN_CORE_RING = 1

export TNS_END_PERCENT = 100

export PLACE_DENSITY ?= 0.99

# Power #
export PDN_TCL ?= ./user_design/$(DESIGN_NICKNAME)/script/pdn.tcl