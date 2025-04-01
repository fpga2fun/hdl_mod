#######################################################################################
## Purpose: Makefile for Chap_8_Advanced_OOP_and_Testbench_Guidelines/homework_solution
## Author: Greg Tumbush
##
## REVISION HISTORY:
## $Log: Makefile,v $
## Revision 1.2  2011/09/13 17:55:51  tumbush.tumbush
## Fixed Makefile for questa_gui. Replaced assert with SV_RAND_CHECK
##
## Revision 1.1  2011/05/29 19:16:11  tumbush.tumbush
## Check into cloud repository
##
## Revision 1.2  2011/03/29 21:22:31  Greg
## Added support for VCS
##
## Revision 1.1  2011/03/29 19:28:37  Greg
## Initial check-in
##
#######################################################################################


FILES =  packet_pkg.sv scoreboard_pkg.sv my_package.sv test_pkg.sv  test.sv top.sv
TOPLEVEL = top

help:
	@echo "Make targets:"
	@echo "> make vcs          	# Compile and run with VCS"
	@echo "> make questa_gui   	# Compile and run with Questa in GUI mode"
	@echo "> make questa_batch 	# Compile and run with Questa in batch mode"
	@echo "> make clean        	# Clean up all intermediate files"
	@echo "> make tar          	# Create a tar file for the current directory"
	@echo "> make help         	# This message"

#############################################################################
# VCS section
VCS_FLAGS = -sverilog -debug -I
vcs:	simv
	simv -l sim.log

simv:   ${FILES}
	vcs +TESTNAME=TestGood ${VCS_FLAGS} -l comp.log ${FILES}
#	vcs +TESTNAME=Test_v3 ${VCS_FLAGS} -l comp.log ${FILES}
#	vcs +TESTNAME=TestBad ${VCS_FLAGS} -l comp.log ${FILES}    

waves:	${FILES}
	vcs +TESTNAME=TestGood -sverilog -RI -debug_all -l simv.log ${FILES}
#	vcs +TESTNAME=Test_v3 -sverilog -RI -debug_all -l simv.log ${FILES}
#	vcs +TESTNAME=TestBad -sverilog -RI -debug_all -l simv.log ${FILES}

#############################################################################
# Questa section
questa_gui: ${FILES} clean
	vlib work
	vmap work work
	vlog ${FILES}
	vsim -novopt  +TESTNAME=TestGood -do "view wave;add wave -radix hex -r *;run -all" ${TOPLEVEL}
#	vsim -novopt  +TESTNAME=Test_v3 -do "view wave;add wave -radix hex -r *;run -all" ${TOPLEVEL}
#	vsim -novopt  +TESTNAME=Test_Bad -do "view wave;add wave -radix hex -r *;run -all" ${TOPLEVEL}

questa_batch: ${FILES} clean
	vlib work
	vmap work work
	vlog ${FILES}
	vsim +TESTNAME=TestGood -c -novopt -do "run -all; quit -f" ${TOPLEVEL}
#	vsim +TESTNAME=Test_v3 -c -novopt -do "run -all;quit -f" ${TOPLEVEL}
#	vsim +TESTNAME=TestBad -c -novopt -do "run -all;quit -f" ${TOPLEVEL}

#############################################################################
# Housekeeping

DIR = $(shell basename `pwd`)

tar:	clean
	cd ..; \
	tar cvf ${DIR}.tar ${DIR}

clean:
	@# VCS Stuff
	@rm -rf simv* csrc* *.log *.key vcdplus.vpd *.log .vcsmx_rebuild vc_hdrs.h
	@# Questa stuff
	@rm -rf work transcript vsim.wlf
	@# Unix stuff
	@rm -rf  *~ core.*
