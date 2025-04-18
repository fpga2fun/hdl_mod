all:vhdl_comp vlog_uvm_comp vlog_comp vcs_comp

vhdl_comp:

vlog_uvm_comp:
	vlogan +v2k -nc -q -full64 -sverilog -ntb_opts uvm-1.2 +libext+.v+.sv -l vlogan.log -timescale=1ns/1ps -kdb +warn=noTFIPC +define+MAX_NPU_NUM=1 +define+SYS_TB +define+ZEBU_SIMXL +define+INCLUDE_SVT_DPI +define+SVT_UVM_TECHNOLOGY +define+TIME_ACCURACY=1.0e-9 +define+CLK_NUM=13 +define+RST_NUM=3 +define+INTERRUPT_CH1 

vlog_comp:
	vlogan +v2k -nc -q -full64 -sverilog -ntb_opts uvm-1.2 +libext+.v+.sv -l vlogan.log -timescale=1ns/1ps -kdb +warn=noTFIPC +define+MAX_NPU_NUM=1 +define+SYS_TB +define+ZEBU_SIMXL +define+INCLUDE_SVT_DPI +define+SVT_UVM_TECHNOLOGY +define+TIME_ACCURACY=1.0e-9 +define+CLK_NUM=13 +define+RST_NUM=3 +define+INTERRUPT_CH1 -f filelist.f

vcs_comp:
	vcs -full64 -q -CFLAGS -DVCS -l vcs.log -notice +error+100 +vpi -ntb_opts uvm-1.2 -debug_access+all -debug_region+cell+encrypt -zebu_string=512 -top tb_top -kdb -top svt_dpi -DVCS -L${ZEBU_IP_ROOT}/lib -L${ZEBU_ROOT}/lib -lxtor_amba_master -lxtor_amba_master_svdpi -lxtor_amba_slave -lxtor_amba_slave_svdpi -lZebuXtor -lZebuXtorUVM -lZebuXtorSim -lZebu -Xhwcosim=clkopt 

verdi:
	verdi -simflow -simBin simv &
verdi_f:
	verdi -f filelist_verdi.f -sv -uvm -top tb_top &
