#!/bin/tcsh
########  THIS LINE MUST BE THE FIRST COMMAND LINE AFTER THE SHEBANG  ########
set sourced=($_)
if ("$sourced" == "") then
  echo "ERROR: $0 must be sourced, not run." >> /dev/stderr
  exit 1
endif

if ( ! (-f ${cwd}/.git || -f ${cwd}/setup_env.sh) ) then
  echo "ERROR: You must go to the root directory of your GIT project database"
  echo "       where the setup_env.csh file is located."
  exit 1
endif
##############################################################################



setenv pdk_dir /research/ece/lnis-teaching/Designkits/tsmc180nm/pdk
setenv cadence_base /uusoc/facility/cad_tools/Cadence/IC6-15
setenv CDS   $cadence_base/IC6-F15
setenv virtuoso_setup_files $PWD/virtuoso
setenv CALIBRE_HOME /uusoc/facility/cad_tools/Mentor/aok_cal_2021.2_37.20/
setenv CDS_Netlisting_Mode Analog

   #Setup the path for shared libraries

   if (`uname -m` == "x86_64") then
       setenv LD_LIBRARY_PATH $CDS/tools/lib/64bit
   else
       setenv LD_LIBRARY_PATH $CDS/tools/lib/32bit
   endif


source /uusoc/facility/cad_tools/Mentor/mentor_setup.sh
source /uusoc/facility/cad_tools/Cadence/cadence_setup.sh

# Show the final environment configuration
echo "---------------- Digital VLSI Design Environment ----------------"
echo "Machine ....... : `uname -n` (`uname -r`)"
echo "Linux ......... : `lsb_release -sd`"
echo "Modelsim ...... : `vsim -version`"
echo "Genus ......... : 21.15-s080_1"
echo "Virtuoso ...... : 6.1.8-64b"
echo "Innovus ....... : v21.15-s110_1"
echo "----------------------------------------------------------------"

