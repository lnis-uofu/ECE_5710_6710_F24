#setenv DISPLAY "lnissrv4.eng.utah.edu:1002"


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
setenv virtuoso_setup_files /research/ece/lnis/USERS/boston/DigitalVLSI/virtuoso


source /uusoc/facility/cad_tools/Mentor/mentor_setup.sh
source /uusoc/facility/cad_tools/Cadence/cadence_setup.sh

# Show the final environment configuration
echo "---------------- Digital VLSI Design Environment ----------------"
echo "Machine ....... : `uname -n` (`uname -r`)"
echo "Linux ......... : `lsb_release -sd`"
echo "----------------------------------------------------------------"

