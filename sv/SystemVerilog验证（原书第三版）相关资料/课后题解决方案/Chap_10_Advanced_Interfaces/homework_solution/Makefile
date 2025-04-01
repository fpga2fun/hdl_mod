########################################################################################
## Purpose: Makefile for Chap_10_Advanced_Interfaces/homework_solution
## Author: Chris Spear
##
## REVISION HISTORY:
## $Log: Makefile,v $
## Revision 1.2  2011/09/17 20:56:38  tumbush.tumbush
## Declare mailbox size/type instead of using a typedef. Declare mailbox argument to new as input
##
## Revision 1.1  2011/05/27 02:58:59  tumbush.tumbush
## Checked into cloud.
##
## Revision 1.2  2011/05/15 20:21:25  Greg
## Fixed log files and Purpose
##
## Revision 1.1  2011/04/05 22:24:10  Greg
## Initial check-in
##
########################################################################################

FILES = ../../risc_spm/Alu_RISC.v ../../risc_spm/Memory_Unit.v ../../risc_spm/Clock_Unit.v ../../risc_spm/mux3_1.v ../../risc_spm/mux5_1.v ../../risc_spm/Register_Unit.v ../../risc_spm/Control_Unit.v ../../risc_spm/Processing_Unit.v ../../risc_spm/RISC_SPM.v my_package.sv test.sv top.sv
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
VCS_FLAGS = -sverilog -debug -I +incdir+../../risc_spm
vcs:	simv
	simv -l sim.log

simv:   ${FILES}
	vcs ${VCS_FLAGS} -l comp.log ${FILES}

waves:	${FILES}
	vcs -sverilog -RI -debug_all -l simv.log ${FILES}

#############################################################################
# Questa section
questa_gui: ${FILES} clean
	vlib work
	vmap work work
	vlog +incdir+../../risc_spm ${FILES}
	vsim -novopt -do "view wave;do wave.do;run -all" ${TOPLEVEL}

questa_batch: ${FILES} clean
	vlib work
	vmap work work
	vlog +incdir+../../risc_spm ${FILES}
	vsim -c -novopt -do "run -all" ${TOPLEVEL}

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
