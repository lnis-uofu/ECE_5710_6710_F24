# place_route.tcl
#Change the design name as well as the required density
#set design					topmodule_withpads
set design					soc_top
set density					0.60
set max_route_layer 4
set min_route_layer 2


set rpt_dir					./RPT
set pwr_net 				VDD
set gnd_net 				VSS

#To enable multi threading. Not sure if the CADE machines can allow more cores than this.
set cpu_number 				2
#Uniquify the design, otherwise, might get error during CTS
set init_design_uniquify    1



proc put_header hdr {

   puts "\n---#-----------------------------------------------------"
   puts "---# $hdr"
   puts "---#-----------------------------------------------------\n"
}



#=========================================================================================
# set_design
#
proc set_design name {
   set lname $name
   set lrpt_dir "RPT/${lname}"

   puts "Design name set to: $lname"
   uplevel #0 set design $lname

   set root [split $lname "_"]
   set root [lindex $root 0]
   puts "Design root set to: $root"
   uplevel #0 set root $root

   uplevel #0 set rpt_dir $lrpt_dir
   puts "Report directory set to: $lrpt_dir"
   # create report directory if not yet existing
   file mkdir $lrpt_dir
}

#=========================================================================================
# free_design
#
proc free_design {} {
   put_header "Freeing design..."
   freeDesign
}

#=========================================================================================
# save_design
#
proc save_design step {
   global design

   saveDesign DBS/$design-$step.enc
}

#=========================================================================================
# restore_design
#
proc restore_design step {
   global design
   global root

   set path "./DBS/${design}-${step}.enc.dat"
   if [file exists $path] {
      restoreDesign $path $root
   } else {
      puts "-e- No design saved as $path"
   }
}

#=========================================================================================
# import_design
#     how      init | restore
#
proc import_design {{how "init"}} {
   global design
   global globalname

   put_header [concat "Importing " $design " " $how "..."]

   switch $how {
      "init"      {  uplevel #0 source CONF/picosoc.globals
                     init_design
                     save_design import
                  }
      "restore"   {  restore_design import  }
   }
   setDrawView fplan
   fit
}


#=========================================================================================
# floorplan_design
#
proc floorplan_design {} {
   global design
   global root
   global density
   put_header [concat "Floorplanning " $design "..."]

   set ASPECT_RATIO   1.0    ;# rectangle with height = 1.0*width
   set HEIGHT         910    ; #750
   set WIDTH          1070   ; #1080
   set CORE_TO_LEFT   80     ;# micron
   set CORE_TO_BOTTOM 80     ;# micron
   set CORE_TO_RIGHT  80     ;# micron
   set CORE_TO_TOP    80     ;# micron

   floorPlan -site core7T -s $WIDTH $HEIGHT $CORE_TO_LEFT $CORE_TO_BOTTOM $CORE_TO_RIGHT $CORE_TO_TOP
   setDrawView fplan
   fit

           
    ###### LEFT BOTTOM RIGHT TOP
    placeInstance soc/soc_memory_sram_2 318 315 R180
    addHaloToBlock 8 8 8 8 -fromInstBox -snapToSite soc/soc_memory_sram_2

    placeInstance soc/soc_memory_sram_1 318 1057 R0
    addHaloToBlock 8 8 8 8  -fromInstBox -snapToSite soc/soc_memory_sram_1
 
    placeInstance soc/soc_cpu_cpuregs_reg_1 315 575 R0 
    addHaloToBlock 2 2 2 2 -fromInstBox -snapToSite soc/soc_cpu_cpuregs_reg_1
    #addRoutingHalo -allBlocks -space 10 -bottom METAL1 -top METAL3

    placeInstance soc/soc_cpu_cpuregs_reg_2 315 805 R0
    addHaloToBlock 2 2 2 2  -fromInstBox -snapToSite soc/soc_cpu_cpuregs_reg_2

                
    save_design fplan
}


#=========================================================================================
# connect_global_nets
#
proc connect_global_nets {} {
   global design
   global pwr_net
   global gnd_net

   put_header "Connecting global power nets..."


   globalNetConnect $pwr_net -type pgpin -pin $pwr_net -all -verbose
   globalNetConnect $gnd_net  -type pgpin -pin $gnd_net -all -verbose
   globalNetConnect $pwr_net  -type tiehi
   globalNetConnect $gnd_net -type tielo

}

#=========================================================================================
# Place the IO (by laoding the IO file) and then add the IO filler for pad ring continuity.
#
proc place_io_add_io_filler {} {
   #global design
   global rpt_dir

	 deleteIoFiller

   put_header "Loading IO file..."
   #loadIoFile SCRIPTS/place_io_pad.io


   set iofiller_cells "pad_fill_32 pad_fill_16 pad_fill_8 pad_fill_4 pad_fill_2 pad_fill_1 pad_fill_01 pad_fill_005"
   put_header "Adding IO filler cells..."

   set prefix FILLER
   set number_io_fill [llength $iofiller_cells]
   set number_io_fill_decr [expr {$number_io_fill-1}]

   #If there is only one IO, go to the else. Generally not the case
   if {$number_io_fill>2} {
	   foreach {side} [list n s e w] {
		   for {set x 0} {$x<$number_io_fill_decr} {incr x} {
		      set io_filler [lindex $iofiller_cells $x]
		      addIoFiller -cell $io_filler -prefix $prefix -side $side
		   }
		      set io_filler_last [lindex $iofiller_cells $number_io_fill_decr]
		      addIoFiller -cell $io_filler_last -prefix $prefix -side $side -fillAnyGap

	   } } else {foreach {side} [list n s e w] {
		   for {set x 0} {$x<$number_io_fill_decr} {incr x} {
		      set io_filler [lindex $iofiller_cells $x]
		      addIoFiller -cell $iofiller_cells -prefix $prefix -side $side -fillAnyGap
		   }

	   }}

}
#=========================================================================================
# add_power_nets
#   
#
 proc add_power_nets {} {
    global design
    global pwr_net
    global gnd_net

    put_header "Adding power nets..."

    set POWER_NETS    "VDD VDD VSS VSS"  ;# from core
    set CENTER_RING   1         ;# center rings between I/O and core
    set WIDTH         10       ;# width of ring segments
    set SPACING       4       ;# spacing of ring segments

    set LAYERS  {top METAL5 bottom METAL5 left METAL6 right METAL6}
    set EXTEND  {} ;# tl, tr, bl, bt, lt, rt, lb, rb

   # add power around core
   addRing \
      -type core_rings -follow core \
      -nets $POWER_NETS \
      -center $CENTER_RING \
      -width {top 10 bottom 10 left 10 right 10} \
      -spacing {top 4 bottom 4 left 4 right 4} \
      -center 1 \
      -layer $LAYERS \
      -use_wire_group 1 \
      -extend_corner $EXTEND \
      -jog_distance 0 \
      -snap_wire_center_to_grid None \
      -threshold 0



	 #####Add vertical power stripes
	addStripe \
   -nets "VDD VSS" \
   -layer METAL6 \
   -direction vertical \
   -width 5 \
   -spacing 5 \
   -number_of_sets 10 \
   -start_from left \
   -start_offset 25 \
   -stop_offset 30 \
   -switch_layer_over_obs false \
   -max_same_layer_jog_length 2 \
   -padcore_ring_top_layer_limit METAL6 \
   -padcore_ring_bottom_layer_limit METAL1 \
   -block_ring_top_layer_limit METAL6 \
   -block_ring_bottom_layer_limit METAL1 \
   -use_wire_group 0 \
   -snap_wire_center_to_grid None \
   -skip_via_on_pin {  standardcell } \
   -skip_via_on_wire_shape {  noshape }   

    ##### Add horizontal power stripe
	addStripe \
   -nets "VDD VSS" \
   -layer METAL5 \
   -direction horizontal \
   -width 5 \
   -spacing 5 \
   -number_of_sets 9 \
   -start_from left \
   -start_offset 30 \
   -stop_offset 30 \
   -switch_layer_over_obs false \
   -max_same_layer_jog_length 2 \
   -padcore_ring_top_layer_limit METAL6 \
   -padcore_ring_bottom_layer_limit METAL1 \
   -block_ring_top_layer_limit METAL6 \
   -block_ring_bottom_layer_limit METAL1 \
   -use_wire_group 0 \
   -snap_wire_center_to_grid None \
   -skip_via_on_pin {  standardcell } \
   -skip_via_on_wire_shape {  noshape }

 


	save_design power
}

#=========================================================================================
# route_power_nets
#
 proc route_power_nets {} {
    global pwr_net
    global gnd_net

    set POWER_NETS    "VDD VSS"  ;

    sroute -connect { blockPin corePin padPin floatingStripe} \
           -layerChangeRange { METAL1(1) METAL6(6) } \
           -blockPinTarget { nearestTarget } \
           -padPinPortConnect { allPort oneGeom } \
           -padPintarget { nearestTarget } \
           -corePinTarget { firstAfterRowEnd } \
           -crossoverViaLayerRange { METAL1(1) METAL6(6) } \
           -nets { VDD VSS } \
           -allowJogging 1 \
           -allowLayerChange 1 \
           -blockPin useLef \
           -targetViaLayerRange { METAL1(1) METAL6(6)}



           
   fit
   save_design power-routed
}

#=========================================================================================
# place_core_cells
#  
#
proc place_core_cells {} {
   global design
   global root
   global rpt_dir
   global max_route_layer
   global cpu_number

   put_header "Placing core cells..."

   setMultiCpuUsage -localCpu $cpu_number -keepLicense true -acquireLicense $cpu_number

   set PROCESS 180    ;# process technology value [micron]
   setDesignMode -process $PROCESS

   setDesignMode -topRoutingLayer $max_route_layer
   setPlaceMode -timingDriven true \
                -congEffort high \
                -placeIOPins 1 \
                -place_global_max_density 0.45
                        
    
            
   place_design
   setDrawView place

   
   checkPlace ${rpt_dir}/place.rpt

   #Lab Transistion
   
   set name "placed"
   save_design $name
}



#=========================================================================================
# create_clock_tree
# 
#
proc create_clock_tree {{opt ""}} {
   global design
   global root
   global rpt_dir
   global max_route_layer
   global min_route_layer
   global cpu_number


   setMultiCpuUsage -localCpu $cpu_number -keepLicense true -acquireLicense $cpu_number

   set cts_buffer_cells "BUFX1"
   set cts_inverter_cells "INVX1 INVX2 INVX4 INVX8 INVX16 INVX32"
   set_ccopt_property route_type_override_preferred_routing_layer_effort none

   setDesignMode -topRoutingLayer $max_route_layer
   setDesignMode -bottomRoutingLayer $min_route_layer

   put_header "Creating clock tree..."
   create_route_type -name clkroute -top_preferred_layer $max_route_layer


   set_ccopt_property route_type clkroute -net_type trunk
   set_ccopt_property route_type clkroute -net_type leaf

   set_ccopt_property buffer_cells $cts_buffer_cells
   set_ccopt_property inverter_cells $cts_inverter_cells

   create_ccopt_clock_tree_spec -file ccopt.spec
   source ccopt.spec

   ccopt_design -cts

   #optDesign -postCTS

   save_design cts

}


##dbGet [dbGet top.nets.wires.layer.name -p3 METAL6].name -u

#=========================================================================================
# route_design
#
proc route_design {} {
   global design   
   global max_route_layer
   global cpu_number


   setMultiCpuUsage -localCpu $cpu_number -keepLicense true -acquireLicense $cpu_number

   put_header "Routing design..."

   set route_tdr_effort 5     ;# 0..10 - 0: opt. congestion; 1: opt. timing
   set rpt_dir "RPT/$design"

   setDesignMode -topRoutingLayer $max_route_layer
   setNanoRouteMode \
      -routeWithTimingDriven true \
      -routeTdrEffort $route_tdr_effort \
      -routeWithSiDriven true \
      -drouteFixAntenna true \
      -routeInsertAntennaDiode true \
      -routeAntennaCellName ANTENNA \
      -routeInsertDiodeForClockNets true
      
      


   routeDesign -globalDetail -wireOpt -viaOpt
   checkRoute

   #optDesign -postRoute


   save_design routed
}

proc optdesign_post_route {} {
	global design
	setAnalysisMode -analysisType onChipVariation -cppr both
	optDesign -postRoute -outDir RPT/$design -prefix postroute -setup -hold  
	save_design route_opt
}

proc addDiode {antennaFile antennaCell} {

  unlogCommand dbGet
  if [catch {open $antennaFile r} fileId] {
    puts stderr "Cannot open $antennaFile: $fileId"
  } else {
    foreach line [split [read $fileId] \n] {
      # Search for lines matching "instName (cellName) pinName" that have violations
      if {[regexp {^  (\S+)  (\S+) (\S+)} $line] == 1} {
        # Remove extra white space
        regsub -all -- {[[:space:]]+} $line " " line
        set line [string trimlef $line]
        # Store instance and pin name to insert diodes on
        set instName [lindex [split $line] 0]
        # Modify instance name if it contains escaped characters:
        set escapedInstName ""
        foreach hier [split $instName /] {
          if {[regexp {\[|\]|\.} $hier] == 1} {
            set hier "\\$hier "
          }
          set escapedInstName "$escapedInstName$hier/"
          set instName $escapedInstName
        }
        regsub {/$} $instName {} instName
        set pinName [lindex [split $line] 2]
        set instPtr [dbGet -p top.insts.name $instName]
        set instLoc [lindex [dbGet $instPtr.pt] 0]
        if {$instName != ""} {
          # Attach diode and place at location of instance
          attachDiode -diodeCell $antennaCell -pin $instName $pinName -loc $instLoc
        }
      }
    }
  }
  close $fileId
  # Legalize placement of diodes and run ecoRoute to route them
  refinePlace -preserveRouting true
  ecoRoute -modifyOnlyLayers 1:5
  logCommand dbGet
}

proc correct_antenna {} {
   global rpt_dir

   set antenna_rpt_file ${rpt_dir}/antenna.rpt
   verifyProcessAntenna -report $antenna_rpt_file
   addDiode $antenna_rpt_file ANTENNA
   save_design antenna
}
#=========================================================================================
 
# add_filler_cells

 proc add_filler_cells {} {
    global design


    put_header "Adding filler cells..."

    set filler_cells \
       "FILL32 FILL16 FILL8 FILL4 FILL2 FILL1"
    set prefix FILLER

    addFiller \
       -cell $filler_cells \
       -prefix $prefix
    setDrawView place

    save_design filled
 }


# =========================================================================================
#  verify_design

proc verify_design {} {
   global rpt_dir
   set antenna_rpt_file ${rpt_dir}/antenna.rpt


   put_header "Verifying design..."

   verifyConnectivity -type all -report ${rpt_dir}/connectivity.rpt

   setVerifyGeometryMode -regRoutingOnly true -error 100000
   verifyGeometry -report ${rpt_dir}/geometry.rpt
   
   set_verify_drc_mode -check_only regular
   verify_drc -report ${rpt_dir}/geometry.rpt

   verifyProcessAntenna -report ${rpt_dir}/antenna.rpt
   #addDiode ./RPT/antenna.rpt ANTENNA
   verifyProcessAntenna -report ${rpt_dir}/antenna.rpt

}

#=========================================================================================
# generate_reports
#
proc generate_reports {} {
   global rpt_dir

   put_header "Generating reports..."

   reportNetStat > ${rpt_dir}/netlist_stats_final.rpt
   report_area > ${rpt_dir}/area_final.rpt
   report_timing > ${rpt_dir}/timing_final.rpt
   summaryReport -noHtml -outfile ${rpt_dir}/summary_report.rpt
}

#=========================================================================================
# export_design
#
proc export_design {} {
   global design
   global root
   global rpt_dir

   put_header "Exporting design..."

   #To be used for importing into Virtuoso
   saveNetlist -includePowerGround -excludeLeafCell  "./HDL/PLACED/${design}_placed_virtuoso.v"
   #To be used for modelsim verification (does not contain VDD/VSS ports)
   saveNetlist -excludeLeafCell "../HDL/PLACED/${design}_placed_modelsim.v"

	exec mkdir -p SDF
	#write_sdf ‐view wc SDF/${design}_placed.sdf
	write_sdf SDF/${design}_placed.sdf

   streamOut "GDS/${design}.gds" \
             -mapFile /research/ece/lnis-teaching/Designkits/tsmc180nm/pdk/captable/gds2.map \
             -libName DesignLib \
             -structureName $design \
             -units 2000 -mode ALL
}

#-merge "/research/ece/lnis-teaching/Designkits/tsmc180nm/full_custom_lib/gds/sclib_tsmc180.gds /research/ece/lnis-teaching/Designkits/tsmc180nm/full_custom_lib/gds/padlib_tsmc180.gds"

#=========================================================================================
# do_steps
#
proc do_steps {start {end -1}} {

   if {$end == -1} {set end $start}
   for {set i $start} {$i <= $end} {incr i} {
      set st [format "%d" $i]
      uplevel #0 set step $st
      switch $st {
         "0"   { free_design }
         "1"   { import_design init }
         "2"   { floorplan_design }
         "3"   { connect_global_nets }
         "4"   { place_io_add_io_filler }
         "5"   { add_power_nets }
         "6"   { route_power_nets }
         "7"   { place_core_cells }
         "8"   { create_clock_tree }
         "9"   { route_design }
         "10"  { add_filler_cells }
         "11"  { verify_design }
         "12"  { generate_reports }
         "13"  { export_design }
      }
  }}
