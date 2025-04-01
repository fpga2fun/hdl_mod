ref_dir = $(shell pwd)
src_dir = ${ref_dir}/src
topmodule = top
incdir = +incdir+"${src_dir}"
worklib = worklib
cm_opt = -cm line+cond+branch+tgl+assert 
vlogan_opts = -work ${worklib} +v2k -full64 -l compile.log -nc -kdb -sverilog -v2005 +define+FSDB 
vhdlan_opts = -work ${worklib}  -full64 -l vhdlcomp.log -nc   
elab_opts = ${worklib}.${topmodule}  -full64 -debug_access+all -l elaborate.log  -kdb $(cm_opt)  
sim_opts = -licqueue -l simulate.log $(cm_opt) 


.PHONY:clean gen comp elab sim verdi
all: comp elab sim 

gen:
	find ${src_dir} -name "*.*v" > filelist.f

comp:
	bsub -Is vlogan ${vlogan_opts}  -timescale=1ns/1ps  -f filelist.f ${incdir} 
#	bsub -Is vhdlan ${vhdlan_opts}  ${src_dir}/xpm_VCOMP.vhd \
	${src_dir}/ip/rd_fifo_128_16/fifo_generator_v13_2_5/fifo_generator_v13_2_rfs.vhd \
	
elab:
	bsub -Is vcs  ${elab_opts} -timescale=1ns/1ps 

sim:
	bsub -Is ${ref_dir}/simv ${sim_opts}

verdi:
	bsub -Is -q haps verdi -dbdir simv.daidir -ssf *.fsdb  &

clean:
	rm -rf ./64 ./csrc ./verdiLog ./*.log ./top.fsdb ./ucli.key ./inter.vpd ./novas* \
		./DVEfiles ./simv ./simv.daidir file_info.txt simulate.do *.fsdb worklib filelist.f simv.vdb

