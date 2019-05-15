#=============================================================================
# Call syntax: <SDK_PATH>/bin/xsct.bat sdk_build_all.tcl <targets>...
# Specifying targets is optional. If none is specified, all projects are
# imported from the sdk/ directory. If desired specify targets by their
# directory name in sdk/. For example:
# xsct sdk_build_all.tcl img1 bist_bsp system_hw_wrapper_0
# Keep in mind that for a successful application build, BSP and HW platform
# should be imported too.
# This is an SDK batch/HSI script (ug1138) that imports projects from the
# SDK workspace into the current WORKING DIRECTORY and builds them.
# This script is split into two, because mixing SDK batch and HSI commands
# in a single xsct batch execution results in errors.
#=============================================================================
set script_path [file dirname [info script]]
set projects_path $script_path/../../sdk
set new_ws_path ./

# Process arguments
set targets [list]
if {$::argc > 0} {
   for {set i 0} {$i < $::argc} {incr i} {
      # any argument is a target for now
      lappend targets [lindex $::argv $i]
   }
}

# If no target is specified, build everything
if {0 == [llength $targets]} {
   lappend targets all
}
# This is where the temporary workspace will be set up
sdk setws -switch $new_ws_path

# Import all the targets
foreach target $targets {
   puts "Importing target $target"
   if {$target == "all"} {
      sdk importprojects $projects_path/
   } else {
      sdk importprojects $projects_path/$target/
   }
}
# foreach bsp [glob -nocomplain -type {f r} -path $new_ws_path/ */*.mss] {
   # foreach bsp_src [glob -nocomplain -type {d} -dir [file dirname $bsp] *] {
      # puts "Deleting BSP sources from $bsp_src"
      # file delete -force -- $bsp_src
   # }
# }
#after 10000
