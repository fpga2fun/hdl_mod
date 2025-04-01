#############################################################
## Purpose: Makefile for Chap_2_Data_Types/homework3_solution
## Author: Chris Spear
##
## REVISION HISTORY:
## $Log: Makefile,v $
## Revision 1.1  2011/05/28 19:48:17  tumbush.tumbush
## Check into cloud repository
##
## Revision 1.1  2011/03/17 15:56:34  Greg
## Initial check-in
##
############################################################

VCS_FILES = config_reg_buggy_vcs.svp test.sv
QUESTA_FILES = config_reg_buggy_questa.svp test.sv
TOPLEVEL = test

help:
	@echo "Make targets:"
	@echo "> make vcs          	# Compile and run with VCS"
	@echo "> make vcs_encrypt	# Encrypt config_reg_buggy.sv with VCS"
	@echo "> make questa_gui   	# Compile and run with Questa in GUI mode"
	@echo "> make questa_batch 	# Compile and run with Questa in batch mode"
	@echo "> make questa_encrypt	# Encrypt config_reg_buggy.sv with Questa"
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

vcs_encrypt: config_reg_buggy.sv
	@rm config_reg_buggy_vcs.svp
	@rm config_reg_buggy.svp
	vcs +protect config_reg_buggy.sv
	@mv config_reg_buggy.svp config_reg_buggy_vcs.svp


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

questa_encrypt: config_reg_buggy.sv
	@rm config_reg_buggy_questa.svp
	@rm config_reg_buggy.svp
	vencrypt config_reg_buggy.sv
	@mv config_reg_buggy.svp config_reg_buggy_questa.svp

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
