#!/bin/csh

setenv VERIFY_DIR $PWD
setenv PROJ_DIR `dirname $VERIFY_DIR`
setenv GIT_LOAD_DIR `dirname $PROJ_DIR`
setenv RTL_DIR `echo $PROJ_DIR | sed 's/_verif$//'`
setenv PROJ_NAME `basename $VERIFY_DIR` 
setenv OUTPUT_DIR /output/$USER/`basename $GIT_LOAD_DIR`/$PROJ_NAME

if( $1 == "ZEBU") then
	source setenv_zebu.csh
	echo "Zebu Env"
else if( $1 == "POST") then
	module load Designware-2019
	module load synopsys_new/vcs_vP-2019.06
	module load synopsys_new/verdi_vQ-2020.03-SP2
	echo "Post Env"
else
	module load Designware-2019
	module load synopsys_new/vcs_vU-2023.03-SP2
	module load synopsys_new/verdi_vU-2023.03-SP2
	echo "Front Env"
endif

module load gcc-9.3.0
module load open-source-tools

setenv DC_HOME /tools/synopsys/syn_vO-2018.06-SP5-3/syn/O-2018.06-SP5-3
setenv LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:${OUTPUT_DIR}"

mkdir -p $OUTPUT_DIR/`basename $GIT_LOAD_DIR`"_tmp"
setenv TMPDIR $OUTPUT_DIR/`basename $GIT_LOAD_DIR`"_tmp"

#user def
setenv CONFIG_PATH $VERIFY_DIR/verify/config
setenv SCRIPT_PATH $VERIFY_DIR/verify/script
alias neu_trace_merge 'python3 ${SCRIPT_PATH}/op/neu_trace_merge.py'
#enduser

#tools
setenv TEST_DIR   $VERIFY_DIR/verify/case/tdl
setenv FILELIST_DIR $VERIFY_DIR/verify/filelist
setenv TOOLS_HOME /home/luliwei/tools/python/xrun
alias xr 'python3 $TOOLS_HOME/xrun.py'
#endtools

#risc-v
setenv TOOL_EXTENSION /tools/open/riscv64-elf-x86_64/bin
setenv RV_C_LIB_DIR $PROJ_DIR/sys/verify/sw

alias tlook 'ls $TEST_DIR'
alias clook 'xr --ln'
alias cdp 'cd $VERIFY_DIR'
alias cds 'cd $OUTPUT_DIR'
alias cdr 'cd $RTL_DIR'
alias genv 'gvim $VERIFY_DIR/setenv.csh'
alias xmk make -f ${VERIFY_DIR}/verify/script/smart_env/smart_run/makefile
