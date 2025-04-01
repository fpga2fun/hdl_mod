#!/bin/csh
setenv XILINXD_LICENSE_FILE 2100@server8
#setenv LM_LICENSE_FILE      2100@server8:27000@server8
setenv SNPSLMD_LICENSE_FILE 27000@server8

setenv  VCS_HOME    /project/zebu/tools/zebu2020.03-1/vcs/Q-2020.03-1-Z
setenv  VERDI_HOME  /project/zebu/tools/zebu2020.03-1/verdi/Q-2020.03-SP1-Z
setenv  SYNOPSYS    /tools/synopsys/syn/Q-2019.12-SP4

source  /tools/synopsys/zebu/Q-2020.03-SP1-1/zebu_env.csh

module load synopsys_new/snps_lic

setenv  ZEBU_IP_ROOT  /tools/synopsys/zebu/xtor_vQ2021.06
setenv  ZEBU_SYSTEM_DIR  /tools/synopsys/zebu_system_dir_2u
setenv  FILE_CONF $ZEBU_SYSTEM_DIR/config/zse_configuration.tcl
setenv  LD_LIBRARY_PATH  $VERDI_HOME/share/FsdbWriter/LINUX64:$VERDI_HOME/share/FsdbReader/LINUX64:$VERDI_HOME/share/PLI/VCS/LINUX64:$ZEBU_IP_ROOT/lib:$ZEBU_ROOT/lib:$ZEBU_ROOT/thirdparty/gtk:$LD_LIBRARY_PATH
setenv PATH $VERDI_HOME/bin:$ZEBU_ROOT/bin:$VCS_HOME/bin:$VCS_HOME/linux64/bin:$PATH

setenv ZEBU_DEBUG_ZWD_PLUS_R                    1
setenv ZEBU_DEBUG_DYN_GRAPH_LOADING             1
setenv ZEBU_DEBUG_USE_SIMZILLA                  1
setenv ZEBU_DEBUG_USE_DFS                       1
setenv ZEBU_SIMZILLA_VIRTUAL_SLICING            1
setenv ZEBU_DEBUG_SIMZILLA_REMOVE_DEAD_LOGIC_ON 1
setenv VIVADO_ENABLE_MULTITHREADING             2
setenv ZEBU_FULL_FRAME_INTERVAL_FWC             6
setenv ZEBU_EXTEND_CLIENT_SERVER_TIMEOUTS_VALUE 480
setenv ZEBU_RTBFE_IMPROVE_IF_PATHS              1
setenv ZCUI_EXPERT                              zRtbAwareTiming
setenv ZEBU_ACTIVATE_EMU_QUEUE                  true
setenv ZEBU_GZIP_PARALLEL                       6000,12
setenv REMOTECMD                                "bsub -I -J zxpar_simzilla"
setenv ZEBU_DISABLE_PRINT                       0

alias m0 'setenv ZEBU_U0_PHYSICAL_LOCATION U0; setenv ZEBU_M0_PHYSICAL_LOCATION M0'
alias m1 'setenv ZEBU_U0_PHYSICAL_LOCATION U0; setenv ZEBU_M0_PHYSICAL_LOCATION M1'
alias m2 'setenv ZEBU_U0_PHYSICAL_LOCATION U0; setenv ZEBU_M0_PHYSICAL_LOCATION M2'
alias m3 'setenv ZEBU_U0_PHYSICAL_LOCATION U0; setenv ZEBU_M0_PHYSICAL_LOCATION M3'
alias m4 'setenv ZEBU_U0_PHYSICAL_LOCATION U0; setenv ZEBU_M0_PHYSICAL_LOCATION M4'
alias m5 'setenv ZEBU_U0_PHYSICAL_LOCATION U1; setenv ZEBU_M0_PHYSICAL_LOCATION M0'
alias m6 'setenv ZEBU_U0_PHYSICAL_LOCATION U1; setenv ZEBU_M0_PHYSICAL_LOCATION M1'
alias m7 'setenv ZEBU_U0_PHYSICAL_LOCATION U1; setenv ZEBU_M0_PHYSICAL_LOCATION M2'
alias m8 'setenv ZEBU_U0_PHYSICAL_LOCATION U1; setenv ZEBU_M0_PHYSICAL_LOCATION M3'
alias m9 'setenv ZEBU_U0_PHYSICAL_LOCATION U1; setenv ZEBU_M0_PHYSICAL_LOCATION M4'
alias zlook 'zRscManager -sysstat $ZEBU_SYSTEM_DIR'
alias zspy 'zSpy -batch -systemDir $ZEBU_SYSTEM_DIR'

limit maxproc unlimit

setenv DESIGNWARE_HOME /tools/synopsys/Designware

setenv ZEBU_ENV__H
setenv ZEBU_SERVER 1
setenv SYNOPSYS_SIM_SETUP ${PROJ_DIR}/sys/verify/config/zebu/synopsys_sim.setup
