##############################################################
## Purpose: Makefile for Chap_Randomization/exercise4
# (c) by Chris Spear, Greg Tumbush, and Tim Pylant
# Feel free to copy and share, just report problems back to us
#
# REVISION HISTORY:
# $Log: Makefile,v $
# Revision 1.1  2011/05/29 19:09:57  tumbush.tumbush
# Check into cloud repository
#
# Revision 1.1  2011/05/10 18:19:35  Greg
# Initial check-in
#
##############################################################
help:
	@echo "Make targets:"
	@echo "> make vcs          # Compile and run with VCS"
	@echo "> make vcsgui       # Compile and run with VCS GUI"
	@echo "> make questa_gui   # Compile and run with Questa"
	@echo "> make questa_batch # Compile and run with Questa"
	@echo "> make ius      	   # Compile and run with IUS"
	@echo "> make iusgui   	   # Compile and run with IUS GUI"
	@echo "> make clean    	   # Clean up all intermediate files"
	@echo "> make tar      	   # Create a tar file for the current directory"
	@echo "> make help     	   # This message"

#############################################################################
FILES = my_package.sv test.sv top.sv
TOPLEVEL = top

# VCS section
VCS_FLAGS = -sverilog -debug_all -l comp.log
vcs:	simv
	./simv +ntb_random_seed=42 -l sim.log

vcsgui:	simv
	./simv +ntb_random_seed=42 -l sim.log -gui

simv:   ${FILES}
	vcs ${VCS_FLAGS} ${FILES}


#############################################################################
# Questa section
questa_gui: ${FILES} clean
	vlib work
	vmap work work
	vlog ${FILES}
	vsim -sv_seed 42 -novopt -do "view wave;add wave -radix hex -r *;run -all" ${TOPLEVEL}

questa_batch: ${FILES} clean
	vlib work
	vmap work work
	vlog ${FILES}
	vsim -sv_seed 42 -c -novopt -do "run -all" ${TOPLEVEL}

##############################################################################################
# Cadence IUS section
IUS_FLAGS = -debug -gui -input probe.tcl -svseed RANDOM
ius: ${FILES}
	irun ${FILES} 

iusgui: ${FILES}
	irun ${IUS_FLAGS} ${FILES} 

#############################################################################
# Housekeeping

DIR = $(shell basename `pwd`)

tar:	clean
	cd ..; \
	tar cvf ${DIR}.tar ${DIR}

clean:
	@# VCS Stuff
	@rm -rf simv* csrc* *.log *.vpd .vcsmx_rebuild vc_hdrs.h DVEfiles
	@# Questa stuff
	@rm -rf work vsim.wlf transcript modelsim.ini
	@# IUS Stuff
	@rm -rf INCA_libs *shm .simvision *.log *.key 
	@# Unix stuff
	@rm -rf  *~ core.*
