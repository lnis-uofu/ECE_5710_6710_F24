#! /bin/sh
######################################
# Set the base directory for Cadence #
######################################
export cadence_dir="/uusoc/facility/cad_tools/Cadence"

########################
# Licenses for Cadence #
########################
export CDS_LIC_FILE=$cadence_dir/common_license

##################
# Other settings #
##################
export CDS_AUTO_64BIT=ALL
export TMPDIR="/tmp"


#####################################
# Cadence SPECTRE (spice simulator) #
#####################################
export CDS_MMSIM=$cadence_dir/SPECTRE191
export PATH=$PATH:$CDS_MMSIM/bin

########################################
# Cadence Virtuoso (simulation+layout) #
########################################
export CDS_IC=$cadence_dir/IC618
export CDSHOME=$CDS_IC
export PATH=$PATH:$CDS_IC/tools/dfII/bin:$CDS_IC/tools/bin

#####################################
# Cadence Innovus (place and route) #
#####################################
export CDS_INNOVUS=$cadence_dir/INNOVUS201
export PATH=$PATH:$CDS_INNOVUS/bin

###############################################
# Cadence Liberate (library characterization) #
###############################################
export ALTOSHOME=$cadence_dir/LIBERATE192
export PATH=$PATH:$ALTOSHOME/bin

################################################################################################
# Cadence signoff tools: Tempus (STA, signal integrity) and Voltus (power analysis, integrity) #
################################################################################################
export CDS_SSV=$cadence_dir/SSV201
export PATH=$PATH:$CDS_SSV/bin

####################################
# Cadence Quantus (QRC extraction) #
####################################
export CDS_QUANTUS=$cadence_dir/QUANTUS201
export PATH=$PATH:$CDS_QUANTUS/bin

#############################
# Cadence Genus (synthesis) #
#############################
export CDS_GENUS=$cadence_dir/GENUS201
export PATH=$PATH:$CDS_GENUS/bin

#######################################
# Cadence Joules (RTL power analysis) #
#######################################
export CDS_JOULES=$cadence_dir/JLS201
export PATH=$PATH:$CDS_JOULES/bin

################################
# Cadence Allegro (PCB design) #
################################
export CDS_SPB=$cadence_dir/SPB/SPB172
export PATH=$PATH:$CDS_SPB/bin

#############################################
# Set the base directory for Synopsys tools #
#############################################
export synopsys_dir="/uusoc/facility/cad_tools/Synopsys"

###############################
# Licenses for Synopsys tools #
###############################
export SNPSLMD_LICENSE_FILE=27000@chickasaw.eng.utah.edu


#####################################
# Synopsys HSPICE (spice simulator) #
#####################################
export HSP_HOME=$synopsys_dir/hspice/R-2020.12-SP1
# source $HSP_HOME/hspice/bin/cshrc.meta
export PATH=$PATH:$HSP_HOME/hspice/bin

######################################
# Synopsys Finesim (spice simulator) #
######################################
export FSIM_HOME=$synopsys_dir/finesim_R-2020.12
export PATH=$PATH:$FSIM_HOME/bin

##########################################
# Synopsys ICC2 (P&R for advanced nodes) #
##########################################
export ICC2_HOME=$synopsys_dir/icc2/R-2020.09-SP6
export PATH=$PATH:$ICC2_HOME/bin

##############################################################################
# Synopsys PrimeTime (for signoff: static timing analysis, signal integrity) #
##############################################################################
export PRIMETIME_HOME=$synopsys_dir/prime/R-2020.09-SP5
export PATH=$PATH:$PRIMETIME_HOME/bin

#####################################################
# Synopsys PrimePower (for signoff: power analysis) #
#####################################################
export PRIMEPOWER_HOME=$synopsys_dir/pwr_P-2019.03-SP2
export PATH=$PATH:$PRIMEPOWER_HOME/bin

#############################################
# Synopsys Sentaurus (TCAD/Device modeling) #
#############################################
export SENTAURUS_HOME=$synopsys_dir/tcad_sentaurus_R-2020.09-SP1
export PATH=$PATH:$SENTAURUS_HOME/bin

########################################
# Synopsys Design Compiler (synthesis) #
########################################
export DC_HOME=$synopsys_dir/syn_P-2019.03-SP5
export PATH=$PATH:$DC_HOME/bin

#############################################
# Synopsys FORMALITY (Equivalence checking) #
#############################################
export FM_HOME=$synopsys_dir/fm_P-2019.03-SP2
export PATH=$PATH:$FM_HOME/bin

######################################
# Synopsys Tetramax (for IC testing) #
######################################
export TMAX_HOME=$synopsys_dir/txs_P-2019.03-SP2
export PATH=$PATH:$TMAX_HOME/bin

###############################
# Synopsys IDQQ (power fault) #
###############################
export IDQ_HOME=$synopsys_dir/idq_P-2019.03-SP2
export PATH=$PATH:$IDQ_HOME/bin

###########################################
# Synopsys Library Compiler (.lib to .db) #
###########################################
export LC_HOME=$synopsys_dir/lib_compiler_P-2019.03-SP2
export PATH=$PATH:$LC_HOME/bin

################################
# Synopsys VCS (HDL simulator) #
################################
export VCS_HOME=$synopsys_dir/vcs_P-2019.06-SP1
export PATH=$PATH:$VCS_HOME/bin

######################################################
# Synopsys Verdi (to analyze hdl simulation results) #
######################################################
export VERDI_HOME=$synopsys_dir/verdi_P-2019.06-SP1-1
export PATH=$PATH:$VERDI_HOME/bin

######################################################
# Synopsys Quantum ATK  #
######################################################
export QUANTUMATK_BIN=$synopsys_dir/QuantumATK/QuantumATK-Q-2019.12
export PATH=$PATH:$QUANTUMATK_BIN/bin

############################################################
# Synopsys Custom WaveView (to display simulation results) #
############################################################
export CX_HOME=$synopsys_dir/custom_wv_adv_R-2020.12
export PATH=$PATH:$CX_HOME/bin

###########################
# Synopsys StarRCXT (PEX) #
###########################
export RCXT_HOME_DIR=$synopsys_dir/starrc_P-2019.03-SP4/linux64_starrc
export AVANTI_STAR_HOME_DIR=$RCXT_HOME_DIR
export PATH=$PATH:$AVANTI_STAR_HOME_DIR/bin

###########################################
# Set the base directory for Mentor tools #
###########################################
export mentor_dir="/uusoc/facility/cad_tools/Mentor"

##############################
## Licenses for Mentor tools #
##############################
export LM_LICENSE_FILE=$mentor_dir/common_license


################################################
# Mentor AMSV (eldo: spice simulator + ezwave) #
################################################
export MGC_AMS_HOME=$mentor_dir/AMSV_20.2/amsv
export PATH=$PATH:$MGC_AMS_HOME/bin

###################################################
# Mentor Calibre (DRC and LVS verification / PEX) #
###################################################
export USE_CALIBRE_VCO=aok
export CALIBRE_HOME=$mentor_dir/aok_cal_2021.2_37.20
export MGC_HOME=$mentor_dir/aok_cal_2021.2_37.20
export PATH=$PATH:$MGC_HOME/bin

#####################################
# Mentor Questasim (HDL simulation) #
#####################################
export QUESTA_HOME=$mentor_dir/modelsim2019.4/questasim
export PATH=$PATH:$QUESTA_HOME/linux_x86_64

export PATH=$PATH:/uusoc/facility/cad_tools/Xilinx/2018/Vivado/2018.2/bin
