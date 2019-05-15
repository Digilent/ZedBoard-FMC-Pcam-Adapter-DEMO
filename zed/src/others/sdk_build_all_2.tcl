#=============================================================================
# This is an HSI script (ug1138) that builds the img1_pwr and img2_loopback
# applications imported from the proj/sdk workspace.
# It is made to work with the limitations of 2014.4. Expect this script to be
# updated for 2015.1.
# Limitations: no project import
# Workaround: create new "empty application"-templated projects, overwrite its
# bsp mss and its Makefile, copy source files from workspace projects to the
# re-created projects.
#=============================================================================
set script_path [file dirname [info script]]
set projects_path $script_path/../../sdk
set repo_path $script_path/../../../repo
set new_ws_path ./
#source $script_path/pushdpopd.tcl

set targets [list]
if {$::argc > 0} {
   for {set i 0} {$i < $::argc} {incr i} {
      # any argument is a target for now
      lappend targets [lindex $::argv $i]
   }
}

# build all, if no target is specified
if {0 == [llength $targets]} {
   lappend targets all
}

setws -switch $new_ws_path

repo -set $repo_path
repo -scan

puts "Looking for hardware platforms..."
foreach target $targets {
   if {$target == "all"} {
      # Get first hardware platform
      set hw_platform [lindex [glob -nocomplain -type {f r} -path $new_ws_path/ */*.hdf] 0]
      if {$hw_platform != ""} {
         puts "Loading $hw_platform"
         # Loading it will extract hdf and load stuff we need for BSP generation
         hsi::open_hw_design $hw_platform
      } else {
        puts "Hardware platform was not found!"
        exit 1
      }
   } else {
      set hw_platform [lindex [glob -nocomplain -type {f r} -path $new_ws_path/$target/ *.hdf] 0]
      if {$hw_platform != ""} {
         puts "Loading $hw_platform"
         # Loading it will extract hdf and load stuff we need for BSP generation
         hsi::open_hw_design $hw_platform
      } else {
         puts "Hardware platform was not found!"
         exit 1
      }
   }
}

puts "Looking for BSPs..."
foreach target $targets {
   if {$target == "all"} {
      # Get all BSP definition files
      foreach bsp [glob -nocomplain -type {f r} -path $new_ws_path/ */*.mss] {
         puts "Generating BSP1 $bsp"
         # Generate BSP files
         hsi::generate_bsp -dir [file dirname $bsp] -sw_mss $bsp
      }
   } else {
      # Get the first MSS file in the $target directory
      set bsp [lindex [glob -nocomplain -type {f r} -path $new_ws_path/$target/ *.mss] 0]
      if {$bsp != ""} {
         puts "Generating BSP2 $bsp"
         # Generate BSP files and compile them
         hsi::generate_bsp -dir [file dirname $bsp] -sw_mss $bsp
      }
   }
}

foreach app [getprojects -type app] {
	puts ">>>>>>>>>>>>>>> $app has been set to RELEASE"
	if { [catch {configapp -app $app build-config release } result] } {
		puts "configapp failed with result $result"
		exit 1
	}
}

# Build everything we just imported in the new workspace
if { [catch {projects -build} result] } {
   puts "Build failed with result $result"
   exit 1
}

exit 0
