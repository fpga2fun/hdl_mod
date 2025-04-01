########################################################################################
## Purpose: Makefile for Chap_7_Threads_and_Interprocess_Communication/homework3_solution
## Author: Chris Spear
##
## REVISION HISTORY:
## $Log: Makefile,v $
## Revision 1.1  2011/05/29 19:12:23  tumbush.tumbush
## Check into cloud repository
##
## Revision 1.3  2011/05/11 20:06:41  Greg
## Fixed paths to risc_spm
##
## Revision 1.2  2011/03/20 20:48:18  Greg
## Added +incdir+ switch for vcs
##
## Revision 1.1  2011/03/20 20:38:24  Greg
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
