#########################################################################################
## Purpose: Makefile for Chap_7_Threads_and_Interprocess_Communication/homework1_solution
## Author: Chris Spear
##
## REVISION HISTORY:
## $Log: Makefile,v $
## Revision 1.1  2011/05/29 19:13:48  tumbush.tumbush
## Check into cloud repository
##
## Revision 1.2  2011/03/18 20:13:56  Greg
## Added -f as option to rm
##
## Revision 1.1  2011/03/18 20:10:32  Greg
## Initial checkin
##
#########################################################################################

VCS_FILES = arbiter_vcs.vp golden.sv top.sv my_package.sv test.sv
QUESTA_FILES = arbiter_questa.vp golden.sv top.sv my_package.sv test.sv  
TOPLEVEL = top

help:
	@echo "Make targets:"
	@echo "> make vcs          	# Compile and run with VCS"
	@echo "> make vcs_encrypt	# Encrypt arbiter.sv with VCS"
	@echo "> make questa_gui   	# Compile and run with Questa in GUI mode"
	@echo "> make questa_batch 	# Compile and run with Questa in batch mode"
	@echo "> make questa_encrypt	# Encrypt arbiter.sv with Questa"
	@echo "> make clean        	# Clean up all intermediate files"
	@echo "> make tar          	# Create a tar file for the current directory"
	@echo "> make help         	# This message"
#############################################################################
# VCS section
VCS_FLAGS = -sverilog -debug -I
vcs:	simv
	simv -l sim.log

simv:   ${VCS_FILES}
	vcs ${VCS_FLAGS} -l comp.log ${VCS_FILES}

waves:	${VCS_FILES}
	vcs -sverilog -RI -debug_all -l simv.log ${VCS_FILES}

vcs_encrypt: arbiter.sv
	@rm -f arbiter_vcs.vp
	@rm -f arbiter.vp
	vcs +protect arbiter.sv
	@mv arbiter.vp arbiter_vcs.vp


#############################################################################
# Questa section
questa_gui: ${QUESTA_FILES} clean
	vlib work
	vmap work work
	vlog ${QUESTA_FILES}
	vsim -novopt -do "view wave;do wave.do;run -all" ${TOPLEVEL}

questa_batch: ${QUESTA_FILES} clean
	vlib work
	vmap work work
	vlog ${QUESTA_FILES}
	vsim -c -novopt -do "run -all" ${TOPLEVEL}

questa_encrypt: arbiter.v
	@rm -f arbiter_questa.vp
	@rm -f arbiter.vp
	vencrypt arbiter.v
	@mv arbiter.vp arbiter_questa.vp

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
