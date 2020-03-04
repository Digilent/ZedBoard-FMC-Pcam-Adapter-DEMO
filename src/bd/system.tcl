
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# DVIClocking

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg484-1
   set_property BOARD_PART em.avnet.com:zed:part0:1.4 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
digilentinc.com:user:AXI_BayerToRGB:1.0\
digilentinc.com:user:AXI_GammaCorrection:1.0\
digilentinc.com:ip:MIPI_CSI_2_RX:1.2\
digilentinc.com:ip:MIPI_D_PHY_RX:1.3\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axi_vdma:6.3\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:processing_system7:5.5\
digilentinc.com:ip:rgb2vga:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:v_axi4s_vid_out:4.0\
digilentinc.com:video:video_scaler:1.0\
xilinx.com:ip:v_tc:6.1\
xilinx.com:ip:xlconcat:2.1\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
DVIClocking\
"

   set list_mods_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_msg_id "BD_TCL-008" "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  set cam_iic [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 cam_iic ]

  set cam_pwup [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 cam_pwup ]

  set cama_bta [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 cama_bta ]

  set cama_gpio [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 cama_gpio ]

  set dphy_a_hs_clock [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dphy_a_hs_clock ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {336000000} \
   ] $dphy_a_hs_clock

  set dphy_b_hs_clock [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dphy_b_hs_clock ]

  set dphy_c_hs_clock [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dphy_c_hs_clock ]

  set dphy_d_hs_clock [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dphy_d_hs_clock ]


  # Create ports
  set cam_gpio_dir [ create_bd_port -dir O -from 0 -to 0 cam_gpio_dir ]
  set cam_gpio_oen [ create_bd_port -dir O -from 0 -to 0 cam_gpio_oen ]
  set dphy_a_clk_lp_n [ create_bd_port -dir I dphy_a_clk_lp_n ]
  set dphy_a_clk_lp_p [ create_bd_port -dir I dphy_a_clk_lp_p ]
  set dphy_a_data_hs_n [ create_bd_port -dir I -from 1 -to 0 dphy_a_data_hs_n ]
  set dphy_a_data_hs_p [ create_bd_port -dir I -from 1 -to 0 dphy_a_data_hs_p ]
  set dphy_a_data_lp_n [ create_bd_port -dir I -from 1 -to 0 dphy_a_data_lp_n ]
  set dphy_a_data_lp_p [ create_bd_port -dir I -from 1 -to 0 dphy_a_data_lp_p ]
  set dphy_b_clk_lp_n [ create_bd_port -dir I dphy_b_clk_lp_n ]
  set dphy_b_clk_lp_p [ create_bd_port -dir I dphy_b_clk_lp_p ]
  set dphy_b_data_hs_n [ create_bd_port -dir I -from 1 -to 0 dphy_b_data_hs_n ]
  set dphy_b_data_hs_p [ create_bd_port -dir I -from 1 -to 0 dphy_b_data_hs_p ]
  set dphy_b_data_lp_n [ create_bd_port -dir I -from 1 -to 0 dphy_b_data_lp_n ]
  set dphy_b_data_lp_p [ create_bd_port -dir I -from 1 -to 0 dphy_b_data_lp_p ]
  set dphy_c_clk_lp_n [ create_bd_port -dir I dphy_c_clk_lp_n ]
  set dphy_c_clk_lp_p [ create_bd_port -dir I dphy_c_clk_lp_p ]
  set dphy_c_data_hs_n [ create_bd_port -dir I -from 1 -to 0 dphy_c_data_hs_n ]
  set dphy_c_data_hs_p [ create_bd_port -dir I -from 1 -to 0 dphy_c_data_hs_p ]
  set dphy_c_data_lp_n [ create_bd_port -dir I -from 1 -to 0 dphy_c_data_lp_n ]
  set dphy_c_data_lp_p [ create_bd_port -dir I -from 1 -to 0 dphy_c_data_lp_p ]
  set dphy_d_clk_lp_n [ create_bd_port -dir I dphy_d_clk_lp_n ]
  set dphy_d_clk_lp_p [ create_bd_port -dir I dphy_d_clk_lp_p ]
  set dphy_d_data_hs_n [ create_bd_port -dir I -from 1 -to 0 dphy_d_data_hs_n ]
  set dphy_d_data_hs_p [ create_bd_port -dir I -from 1 -to 0 dphy_d_data_hs_p ]
  set dphy_d_data_lp_n [ create_bd_port -dir I -from 1 -to 0 dphy_d_data_lp_n ]
  set dphy_d_data_lp_p [ create_bd_port -dir I -from 1 -to 0 dphy_d_data_lp_p ]
  set vga_pBlue [ create_bd_port -dir O -from 3 -to 0 vga_pBlue ]
  set vga_pGreen [ create_bd_port -dir O -from 3 -to 0 vga_pGreen ]
  set vga_pHSync [ create_bd_port -dir O vga_pHSync ]
  set vga_pRed [ create_bd_port -dir O -from 3 -to 0 vga_pRed ]
  set vga_pVSync [ create_bd_port -dir O vga_pVSync ]

  # Create instance: AXI_BayerToRGB_A, and set properties
  set AXI_BayerToRGB_A [ create_bd_cell -type ip -vlnv digilentinc.com:user:AXI_BayerToRGB:1.0 AXI_BayerToRGB_A ]

  # Create instance: AXI_BayerToRGB_B, and set properties
  set AXI_BayerToRGB_B [ create_bd_cell -type ip -vlnv digilentinc.com:user:AXI_BayerToRGB:1.0 AXI_BayerToRGB_B ]

  # Create instance: AXI_BayerToRGB_C, and set properties
  set AXI_BayerToRGB_C [ create_bd_cell -type ip -vlnv digilentinc.com:user:AXI_BayerToRGB:1.0 AXI_BayerToRGB_C ]

  # Create instance: AXI_BayerToRGB_D, and set properties
  set AXI_BayerToRGB_D [ create_bd_cell -type ip -vlnv digilentinc.com:user:AXI_BayerToRGB:1.0 AXI_BayerToRGB_D ]

  # Create instance: AXI_GammaCorrection_A, and set properties
  set AXI_GammaCorrection_A [ create_bd_cell -type ip -vlnv digilentinc.com:user:AXI_GammaCorrection:1.0 AXI_GammaCorrection_A ]

  # Create instance: AXI_GammaCorrection_B, and set properties
  set AXI_GammaCorrection_B [ create_bd_cell -type ip -vlnv digilentinc.com:user:AXI_GammaCorrection:1.0 AXI_GammaCorrection_B ]

  # Create instance: AXI_GammaCorrection_C, and set properties
  set AXI_GammaCorrection_C [ create_bd_cell -type ip -vlnv digilentinc.com:user:AXI_GammaCorrection:1.0 AXI_GammaCorrection_C ]

  # Create instance: AXI_GammaCorrection_D, and set properties
  set AXI_GammaCorrection_D [ create_bd_cell -type ip -vlnv digilentinc.com:user:AXI_GammaCorrection:1.0 AXI_GammaCorrection_D ]

  # Create instance: DVIClocking_0, and set properties
  set block_name DVIClocking
  set block_cell_name DVIClocking_0
  if { [catch {set DVIClocking_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $DVIClocking_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: MIPI_CSI_2_RX_A, and set properties
  set MIPI_CSI_2_RX_A [ create_bd_cell -type ip -vlnv digilentinc.com:ip:MIPI_CSI_2_RX:1.2 MIPI_CSI_2_RX_A ]
  set_property -dict [ list \
   CONFIG.kDebug {false} \
   CONFIG.kGenerateAXIL {true} \
 ] $MIPI_CSI_2_RX_A

  # Create instance: MIPI_CSI_2_RX_B, and set properties
  set MIPI_CSI_2_RX_B [ create_bd_cell -type ip -vlnv digilentinc.com:ip:MIPI_CSI_2_RX:1.2 MIPI_CSI_2_RX_B ]
  set_property -dict [ list \
   CONFIG.kGenerateAXIL {true} \
 ] $MIPI_CSI_2_RX_B

  # Create instance: MIPI_CSI_2_RX_C, and set properties
  set MIPI_CSI_2_RX_C [ create_bd_cell -type ip -vlnv digilentinc.com:ip:MIPI_CSI_2_RX:1.2 MIPI_CSI_2_RX_C ]
  set_property -dict [ list \
   CONFIG.kGenerateAXIL {true} \
 ] $MIPI_CSI_2_RX_C

  # Create instance: MIPI_CSI_2_RX_D, and set properties
  set MIPI_CSI_2_RX_D [ create_bd_cell -type ip -vlnv digilentinc.com:ip:MIPI_CSI_2_RX:1.2 MIPI_CSI_2_RX_D ]
  set_property -dict [ list \
   CONFIG.kGenerateAXIL {true} \
 ] $MIPI_CSI_2_RX_D

  # Create instance: MIPI_D_PHY_RX_A, and set properties
  set MIPI_D_PHY_RX_A [ create_bd_cell -type ip -vlnv digilentinc.com:ip:MIPI_D_PHY_RX:1.3 MIPI_D_PHY_RX_A ]
  set_property -dict [ list \
   CONFIG.kDebug {false} \
   CONFIG.kGenerateAXIL {true} \
   CONFIG.kLPFromLane0 {false} \
   CONFIG.kNoOfDataLanes {2} \
 ] $MIPI_D_PHY_RX_A

  # Create instance: MIPI_D_PHY_RX_B, and set properties
  set MIPI_D_PHY_RX_B [ create_bd_cell -type ip -vlnv digilentinc.com:ip:MIPI_D_PHY_RX:1.3 MIPI_D_PHY_RX_B ]
  set_property -dict [ list \
   CONFIG.kDebug {false} \
   CONFIG.kGenerateAXIL {true} \
   CONFIG.kLPFromLane0 {false} \
   CONFIG.kSharedLogic {false} \
 ] $MIPI_D_PHY_RX_B

  # Create instance: MIPI_D_PHY_RX_C, and set properties
  set MIPI_D_PHY_RX_C [ create_bd_cell -type ip -vlnv digilentinc.com:ip:MIPI_D_PHY_RX:1.3 MIPI_D_PHY_RX_C ]
  set_property -dict [ list \
   CONFIG.kDebug {false} \
   CONFIG.kGenerateAXIL {true} \
   CONFIG.kLPFromLane0 {false} \
   CONFIG.kSharedLogic {false} \
 ] $MIPI_D_PHY_RX_C

  # Create instance: MIPI_D_PHY_RX_D, and set properties
  set MIPI_D_PHY_RX_D [ create_bd_cell -type ip -vlnv digilentinc.com:ip:MIPI_D_PHY_RX:1.3 MIPI_D_PHY_RX_D ]
  set_property -dict [ list \
   CONFIG.kDebug {false} \
   CONFIG.kGenerateAXIL {true} \
   CONFIG.kLPFromLane0 {false} \
   CONFIG.kSharedLogic {false} \
 ] $MIPI_D_PHY_RX_D

  # Create instance: axi_cama_bta, and set properties
  set axi_cama_bta [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_cama_bta ]
  set_property -dict [ list \
   CONFIG.C_GPIO_WIDTH {4} \
 ] $axi_cama_bta

  # Create instance: axi_cama_gpio, and set properties
  set axi_cama_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_cama_gpio ]
  set_property -dict [ list \
   CONFIG.C_GPIO_WIDTH {4} \
 ] $axi_cama_gpio

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.SYNCHRONIZATION_STAGES {2} \
 ] $axi_mem_intercon

  # Create instance: axi_mem_intercon_1, and set properties
  set axi_mem_intercon_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {4} \
   CONFIG.SYNCHRONIZATION_STAGES {2} \
 ] $axi_mem_intercon_1

  # Create instance: axi_vdma_a, and set properties
  set axi_vdma_a [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_a ]
  set_property -dict [ list \
   CONFIG.c_enable_mm2s_frmstr_reg {1} \
   CONFIG.c_enable_s2mm_frmstr_reg {1} \
   CONFIG.c_enable_s2mm_sts_reg {1} \
   CONFIG.c_include_mm2s_dre {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_m_axi_s2mm_data_width {64} \
   CONFIG.c_m_axis_mm2s_tdata_width {24} \
   CONFIG.c_mm2s_genlock_mode {1} \
   CONFIG.c_mm2s_genlock_num_masters {4} \
   CONFIG.c_mm2s_linebuffer_depth {1024} \
   CONFIG.c_num_fstores {5} \
   CONFIG.c_s2mm_genlock_mode {0} \
   CONFIG.c_s2mm_linebuffer_depth {1024} \
 ] $axi_vdma_a

  # Create instance: axi_vdma_b, and set properties
  set axi_vdma_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_b ]
  set_property -dict [ list \
   CONFIG.c_enable_s2mm_frmstr_reg {1} \
   CONFIG.c_enable_s2mm_sts_reg {1} \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_mm2s_dre {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_m_axi_s2mm_data_width {64} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_mm2s_genlock_mode {0} \
   CONFIG.c_mm2s_linebuffer_depth {512} \
   CONFIG.c_num_fstores {5} \
   CONFIG.c_s2mm_genlock_mode {0} \
   CONFIG.c_s2mm_linebuffer_depth {1024} \
 ] $axi_vdma_b

  # Create instance: axi_vdma_c, and set properties
  set axi_vdma_c [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_c ]
  set_property -dict [ list \
   CONFIG.c_enable_s2mm_frmstr_reg {1} \
   CONFIG.c_enable_s2mm_sts_reg {1} \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_mm2s_dre {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_m_axi_s2mm_data_width {64} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_mm2s_genlock_mode {0} \
   CONFIG.c_mm2s_linebuffer_depth {512} \
   CONFIG.c_num_fstores {5} \
   CONFIG.c_s2mm_genlock_mode {0} \
   CONFIG.c_s2mm_linebuffer_depth {1024} \
 ] $axi_vdma_c

  # Create instance: axi_vdma_d, and set properties
  set axi_vdma_d [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_d ]
  set_property -dict [ list \
   CONFIG.c_enable_s2mm_frmstr_reg {1} \
   CONFIG.c_enable_s2mm_sts_reg {1} \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_mm2s_dre {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_m_axi_s2mm_data_width {64} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_mm2s_genlock_mode {0} \
   CONFIG.c_mm2s_linebuffer_depth {512} \
   CONFIG.c_num_fstores {5} \
   CONFIG.c_s2mm_genlock_mode {0} \
   CONFIG.c_s2mm_linebuffer_depth {1024} \
 ] $axi_vdma_d

  # Create instance: cama_gpio_dir, and set properties
  set cama_gpio_dir [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 cama_gpio_dir ]

  # Create instance: cama_gpio_oen, and set properties
  set cama_gpio_oen [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 cama_gpio_oen ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $cama_gpio_oen

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_DRIVES {BUFG} \
   CONFIG.CLKOUT1_JITTER {174.353} \
   CONFIG.CLKOUT1_PHASE_ERROR {132.063} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50} \
   CONFIG.CLKOUT2_DRIVES {BUFG} \
   CONFIG.CLKOUT2_JITTER {139.594} \
   CONFIG.CLKOUT2_PHASE_ERROR {132.063} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {150} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_DRIVES {BUFG} \
   CONFIG.CLKOUT3_JITTER {132.221} \
   CONFIG.CLKOUT3_PHASE_ERROR {132.063} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {200} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLKOUT4_DRIVES {BUFG} \
   CONFIG.CLKOUT5_DRIVES {BUFG} \
   CONFIG.CLKOUT6_DRIVES {BUFG} \
   CONFIG.CLKOUT7_DRIVES {BUFG} \
   CONFIG.CLK_OUT2_PORT {clk_out2} \
   CONFIG.CLK_OUT3_PORT {clk_out3} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {6.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {10.0} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {12.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {4} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {3} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {3} \
   CONFIG.PRIM_SOURCE {Global_buffer} \
   CONFIG.RESET_PORT {reset} \
   CONFIG.RESET_TYPE {ACTIVE_HIGH} \
   CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.USE_PHASE_ALIGNMENT {false} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
   CONFIG.PCW_ACT_CAN0_PERIPHERAL_FREQMHZ {23.8095} \
   CONFIG.PCW_ACT_CAN1_PERIPHERAL_FREQMHZ {23.8095} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_I2C_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_ACT_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
   CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666667} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
   CONFIG.PCW_CAN0_BASEADDR {0xE0008000} \
   CONFIG.PCW_CAN0_CAN0_IO {<Select>} \
   CONFIG.PCW_CAN0_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN0_GRP_CLK_IO {<Select>} \
   CONFIG.PCW_CAN0_HIGHADDR {0xE0008FFF} \
   CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_CAN0_PERIPHERAL_FREQMHZ {-1} \
   CONFIG.PCW_CAN1_BASEADDR {0xE0009000} \
   CONFIG.PCW_CAN1_CAN1_IO {<Select>} \
   CONFIG.PCW_CAN1_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN1_GRP_CLK_IO {<Select>} \
   CONFIG.PCW_CAN1_HIGHADDR {0xE0009FFF} \
   CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_CAN1_PERIPHERAL_FREQMHZ {-1} \
   CONFIG.PCW_CAN_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_CAN_PERIPHERAL_VALID {0} \
   CONFIG.PCW_CLK0_FREQ {100000000} \
   CONFIG.PCW_CLK1_FREQ {10000000} \
   CONFIG.PCW_CLK2_FREQ {10000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CORE0_FIQ_INTR {0} \
   CONFIG.PCW_CORE0_IRQ_INTR {0} \
   CONFIG.PCW_CORE1_FIQ_INTR {0} \
   CONFIG.PCW_CORE1_IRQ_INTR {0} \
   CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
   CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
   CONFIG.PCW_DCI_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ {10.159} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_HPRLPR_QUEUE_PARTITION {HPR(0)/LPR(32)} \
   CONFIG.PCW_DDR_HPR_TO_CRITICAL_PRIORITY_LEVEL {15} \
   CONFIG.PCW_DDR_LPR_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_PORT0_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT1_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT2_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT3_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PRIORITY_READPORT_0 {<Select>} \
   CONFIG.PCW_DDR_PRIORITY_READPORT_1 {<Select>} \
   CONFIG.PCW_DDR_PRIORITY_READPORT_2 {<Select>} \
   CONFIG.PCW_DDR_PRIORITY_READPORT_3 {<Select>} \
   CONFIG.PCW_DDR_PRIORITY_WRITEPORT_0 {<Select>} \
   CONFIG.PCW_DDR_PRIORITY_WRITEPORT_1 {<Select>} \
   CONFIG.PCW_DDR_PRIORITY_WRITEPORT_2 {<Select>} \
   CONFIG.PCW_DDR_PRIORITY_WRITEPORT_3 {<Select>} \
   CONFIG.PCW_DDR_RAM_BASEADDR {0x00100000} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x1FFFFFFF} \
   CONFIG.PCW_DDR_WRITE_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_DM_WIDTH {4} \
   CONFIG.PCW_DQS_WIDTH {4} \
   CONFIG.PCW_DQ_WIDTH {32} \
   CONFIG.PCW_ENET0_BASEADDR {0xE000B000} \
   CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
   CONFIG.PCW_ENET0_HIGHADDR {0xE000BFFF} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {0} \
   CONFIG.PCW_ENET0_RESET_IO {<Select>} \
   CONFIG.PCW_ENET1_BASEADDR {0xE000C000} \
   CONFIG.PCW_ENET1_ENET1_IO {<Select>} \
   CONFIG.PCW_ENET1_GRP_MDIO_ENABLE {0} \
   CONFIG.PCW_ENET1_GRP_MDIO_IO {<Select>} \
   CONFIG.PCW_ENET1_HIGHADDR {0xE000CFFF} \
   CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET1_RESET_IO {<Select>} \
   CONFIG.PCW_ENET_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_POLARITY {Active Low} \
   CONFIG.PCW_ENET_RESET_SELECT {<Select>} \
   CONFIG.PCW_EN_4K_TIMER {0} \
   CONFIG.PCW_EN_CAN0 {0} \
   CONFIG.PCW_EN_CAN1 {0} \
   CONFIG.PCW_EN_CLK0_PORT {1} \
   CONFIG.PCW_EN_CLK1_PORT {0} \
   CONFIG.PCW_EN_CLK2_PORT {0} \
   CONFIG.PCW_EN_CLK3_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG0_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG1_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG2_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG3_PORT {0} \
   CONFIG.PCW_EN_DDR {1} \
   CONFIG.PCW_EN_EMIO_CAN0 {0} \
   CONFIG.PCW_EN_EMIO_CAN1 {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_ENET0 {0} \
   CONFIG.PCW_EN_EMIO_ENET1 {0} \
   CONFIG.PCW_EN_EMIO_GPIO {1} \
   CONFIG.PCW_EN_EMIO_I2C0 {1} \
   CONFIG.PCW_EN_EMIO_I2C1 {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART0 {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART1 {0} \
   CONFIG.PCW_EN_EMIO_PJTAG {0} \
   CONFIG.PCW_EN_EMIO_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_SPI0 {0} \
   CONFIG.PCW_EN_EMIO_SPI1 {0} \
   CONFIG.PCW_EN_EMIO_SRAM_INT {0} \
   CONFIG.PCW_EN_EMIO_TRACE {0} \
   CONFIG.PCW_EN_EMIO_TTC0 {0} \
   CONFIG.PCW_EN_EMIO_TTC1 {0} \
   CONFIG.PCW_EN_EMIO_UART0 {0} \
   CONFIG.PCW_EN_EMIO_UART1 {0} \
   CONFIG.PCW_EN_EMIO_WDT {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO1 {0} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_ENET1 {0} \
   CONFIG.PCW_EN_GPIO {1} \
   CONFIG.PCW_EN_I2C0 {1} \
   CONFIG.PCW_EN_I2C1 {0} \
   CONFIG.PCW_EN_MODEM_UART0 {0} \
   CONFIG.PCW_EN_MODEM_UART1 {0} \
   CONFIG.PCW_EN_PJTAG {0} \
   CONFIG.PCW_EN_PTP_ENET0 {0} \
   CONFIG.PCW_EN_PTP_ENET1 {0} \
   CONFIG.PCW_EN_QSPI {1} \
   CONFIG.PCW_EN_RST0_PORT {1} \
   CONFIG.PCW_EN_RST1_PORT {0} \
   CONFIG.PCW_EN_RST2_PORT {0} \
   CONFIG.PCW_EN_RST3_PORT {0} \
   CONFIG.PCW_EN_SDIO0 {1} \
   CONFIG.PCW_EN_SDIO1 {0} \
   CONFIG.PCW_EN_SMC {0} \
   CONFIG.PCW_EN_SPI0 {0} \
   CONFIG.PCW_EN_SPI1 {0} \
   CONFIG.PCW_EN_TRACE {0} \
   CONFIG.PCW_EN_TTC0 {0} \
   CONFIG.PCW_EN_TTC1 {0} \
   CONFIG.PCW_EN_UART0 {0} \
   CONFIG.PCW_EN_UART1 {1} \
   CONFIG.PCW_EN_USB0 {1} \
   CONFIG.PCW_EN_USB1 {0} \
   CONFIG.PCW_EN_WDT {0} \
   CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK1_BUF {FALSE} \
   CONFIG.PCW_FCLK_CLK2_BUF {FALSE} \
   CONFIG.PCW_FCLK_CLK3_BUF {FALSE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {150.000000} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_FTM_CTI_IN0 {<Select>} \
   CONFIG.PCW_FTM_CTI_IN1 {<Select>} \
   CONFIG.PCW_FTM_CTI_IN2 {<Select>} \
   CONFIG.PCW_FTM_CTI_IN3 {<Select>} \
   CONFIG.PCW_FTM_CTI_OUT0 {<Select>} \
   CONFIG.PCW_FTM_CTI_OUT1 {<Select>} \
   CONFIG.PCW_FTM_CTI_OUT2 {<Select>} \
   CONFIG.PCW_FTM_CTI_OUT3 {<Select>} \
   CONFIG.PCW_GP0_EN_MODIFIABLE_TXN {1} \
   CONFIG.PCW_GP0_NUM_READ_THREADS {4} \
   CONFIG.PCW_GP0_NUM_WRITE_THREADS {4} \
   CONFIG.PCW_GP1_EN_MODIFIABLE_TXN {1} \
   CONFIG.PCW_GP1_NUM_READ_THREADS {4} \
   CONFIG.PCW_GP1_NUM_WRITE_THREADS {4} \
   CONFIG.PCW_GPIO_BASEADDR {0xE000A000} \
   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_EMIO_GPIO_IO {2} \
   CONFIG.PCW_GPIO_EMIO_GPIO_WIDTH {2} \
   CONFIG.PCW_GPIO_HIGHADDR {0xE000AFFF} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
   CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C0_BASEADDR {0xE0004000} \
   CONFIG.PCW_I2C0_GRP_INT_ENABLE {1} \
   CONFIG.PCW_I2C0_GRP_INT_IO {EMIO} \
   CONFIG.PCW_I2C0_HIGHADDR {0xE0004FFF} \
   CONFIG.PCW_I2C0_I2C0_IO {EMIO} \
   CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C0_RESET_IO {<Select>} \
   CONFIG.PCW_I2C1_BASEADDR {0xE0005000} \
   CONFIG.PCW_I2C1_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C1_GRP_INT_IO {<Select>} \
   CONFIG.PCW_I2C1_HIGHADDR {0xE0005FFF} \
   CONFIG.PCW_I2C1_I2C1_IO {<Select>} \
   CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_IO {<Select>} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_I2C_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_RESET_POLARITY {Active Low} \
   CONFIG.PCW_I2C_RESET_SELECT {<Select>} \
   CONFIG.PCW_IMPORT_BOARD_PRESET {None} \
   CONFIG.PCW_INCLUDE_ACP_TRANS_CHECK {0} \
   CONFIG.PCW_INCLUDE_TRACE_BUFFER {0} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {30} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_IRQ_F2P_INTR {1} \
   CONFIG.PCW_IRQ_F2P_MODE {DIRECT} \
   CONFIG.PCW_MIO_0_DIRECTION {inout} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_0_PULLUP {disabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {inout} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_10_PULLUP {disabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {inout} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_11_PULLUP {disabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {inout} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_12_PULLUP {disabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {inout} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_13_PULLUP {disabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {inout} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {disabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {inout} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_15_PULLUP {disabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {out} \
   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_16_PULLUP {disabled} \
   CONFIG.PCW_MIO_16_SLEW {fast} \
   CONFIG.PCW_MIO_17_DIRECTION {out} \
   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_17_PULLUP {disabled} \
   CONFIG.PCW_MIO_17_SLEW {fast} \
   CONFIG.PCW_MIO_18_DIRECTION {out} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_18_PULLUP {disabled} \
   CONFIG.PCW_MIO_18_SLEW {fast} \
   CONFIG.PCW_MIO_19_DIRECTION {out} \
   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_19_PULLUP {disabled} \
   CONFIG.PCW_MIO_19_SLEW {fast} \
   CONFIG.PCW_MIO_1_DIRECTION {out} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {disabled} \
   CONFIG.PCW_MIO_1_SLEW {fast} \
   CONFIG.PCW_MIO_20_DIRECTION {out} \
   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_20_PULLUP {disabled} \
   CONFIG.PCW_MIO_20_SLEW {fast} \
   CONFIG.PCW_MIO_21_DIRECTION {out} \
   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_21_PULLUP {disabled} \
   CONFIG.PCW_MIO_21_SLEW {fast} \
   CONFIG.PCW_MIO_22_DIRECTION {in} \
   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_22_PULLUP {disabled} \
   CONFIG.PCW_MIO_22_SLEW {fast} \
   CONFIG.PCW_MIO_23_DIRECTION {in} \
   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_23_PULLUP {disabled} \
   CONFIG.PCW_MIO_23_SLEW {fast} \
   CONFIG.PCW_MIO_24_DIRECTION {in} \
   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_24_PULLUP {disabled} \
   CONFIG.PCW_MIO_24_SLEW {fast} \
   CONFIG.PCW_MIO_25_DIRECTION {in} \
   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_25_PULLUP {disabled} \
   CONFIG.PCW_MIO_25_SLEW {fast} \
   CONFIG.PCW_MIO_26_DIRECTION {in} \
   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_26_PULLUP {disabled} \
   CONFIG.PCW_MIO_26_SLEW {fast} \
   CONFIG.PCW_MIO_27_DIRECTION {in} \
   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_27_PULLUP {disabled} \
   CONFIG.PCW_MIO_27_SLEW {fast} \
   CONFIG.PCW_MIO_28_DIRECTION {inout} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_28_PULLUP {disabled} \
   CONFIG.PCW_MIO_28_SLEW {fast} \
   CONFIG.PCW_MIO_29_DIRECTION {in} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_29_PULLUP {disabled} \
   CONFIG.PCW_MIO_29_SLEW {fast} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {fast} \
   CONFIG.PCW_MIO_30_DIRECTION {out} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_30_PULLUP {disabled} \
   CONFIG.PCW_MIO_30_SLEW {fast} \
   CONFIG.PCW_MIO_31_DIRECTION {in} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_31_PULLUP {disabled} \
   CONFIG.PCW_MIO_31_SLEW {fast} \
   CONFIG.PCW_MIO_32_DIRECTION {inout} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_32_PULLUP {disabled} \
   CONFIG.PCW_MIO_32_SLEW {fast} \
   CONFIG.PCW_MIO_33_DIRECTION {inout} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_33_PULLUP {disabled} \
   CONFIG.PCW_MIO_33_SLEW {fast} \
   CONFIG.PCW_MIO_34_DIRECTION {inout} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_34_PULLUP {disabled} \
   CONFIG.PCW_MIO_34_SLEW {fast} \
   CONFIG.PCW_MIO_35_DIRECTION {inout} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_35_PULLUP {disabled} \
   CONFIG.PCW_MIO_35_SLEW {fast} \
   CONFIG.PCW_MIO_36_DIRECTION {in} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_36_PULLUP {disabled} \
   CONFIG.PCW_MIO_36_SLEW {fast} \
   CONFIG.PCW_MIO_37_DIRECTION {inout} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_37_PULLUP {disabled} \
   CONFIG.PCW_MIO_37_SLEW {fast} \
   CONFIG.PCW_MIO_38_DIRECTION {inout} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_38_PULLUP {disabled} \
   CONFIG.PCW_MIO_38_SLEW {fast} \
   CONFIG.PCW_MIO_39_DIRECTION {inout} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_39_PULLUP {disabled} \
   CONFIG.PCW_MIO_39_SLEW {fast} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {fast} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_40_PULLUP {disabled} \
   CONFIG.PCW_MIO_40_SLEW {fast} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_41_PULLUP {disabled} \
   CONFIG.PCW_MIO_41_SLEW {fast} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_42_PULLUP {disabled} \
   CONFIG.PCW_MIO_42_SLEW {fast} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_43_PULLUP {disabled} \
   CONFIG.PCW_MIO_43_SLEW {fast} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_44_PULLUP {disabled} \
   CONFIG.PCW_MIO_44_SLEW {fast} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_45_PULLUP {disabled} \
   CONFIG.PCW_MIO_45_SLEW {fast} \
   CONFIG.PCW_MIO_46_DIRECTION {in} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_46_PULLUP {disabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {in} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_47_PULLUP {disabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {out} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_48_PULLUP {disabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {in} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_49_PULLUP {disabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {fast} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_50_PULLUP {disabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {inout} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_51_PULLUP {disabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_52_DIRECTION {out} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_52_PULLUP {disabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_53_PULLUP {disabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {fast} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {fast} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {fast} \
   CONFIG.PCW_MIO_9_DIRECTION {inout} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_9_PULLUP {disabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_PRIMITIVE {54} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#UART 1#UART 1#GPIO#GPIO#Enet 0#Enet 0} \
   CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#gpio[7]#gpio[8]#gpio[9]#gpio[10]#gpio[11]#gpio[12]#gpio[13]#gpio[14]#gpio[15]#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#wp#cd#tx#rx#gpio[50]#gpio[51]#mdc#mdio} \
   CONFIG.PCW_M_AXI_GP0_ENABLE_STATIC_REMAP {0} \
   CONFIG.PCW_M_AXI_GP0_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP0_SUPPORT_NARROW_BURST {0} \
   CONFIG.PCW_M_AXI_GP0_THREAD_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP1_ENABLE_STATIC_REMAP {0} \
   CONFIG.PCW_M_AXI_GP1_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP1_SUPPORT_NARROW_BURST {0} \
   CONFIG.PCW_M_AXI_GP1_THREAD_ID_WIDTH {12} \
   CONFIG.PCW_NAND_CYCLES_T_AR {1} \
   CONFIG.PCW_NAND_CYCLES_T_CLR {1} \
   CONFIG.PCW_NAND_CYCLES_T_RC {11} \
   CONFIG.PCW_NAND_CYCLES_T_REA {1} \
   CONFIG.PCW_NAND_CYCLES_T_RR {1} \
   CONFIG.PCW_NAND_CYCLES_T_WC {11} \
   CONFIG.PCW_NAND_CYCLES_T_WP {1} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_GRP_D8_IO {<Select>} \
   CONFIG.PCW_NAND_NAND_IO {<Select>} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_CS0_T_CEOE {1} \
   CONFIG.PCW_NOR_CS0_T_PC {1} \
   CONFIG.PCW_NOR_CS0_T_RC {11} \
   CONFIG.PCW_NOR_CS0_T_TR {1} \
   CONFIG.PCW_NOR_CS0_T_WC {11} \
   CONFIG.PCW_NOR_CS0_T_WP {1} \
   CONFIG.PCW_NOR_CS0_WE_TIME {0} \
   CONFIG.PCW_NOR_CS1_T_CEOE {1} \
   CONFIG.PCW_NOR_CS1_T_PC {1} \
   CONFIG.PCW_NOR_CS1_T_RC {11} \
   CONFIG.PCW_NOR_CS1_T_TR {1} \
   CONFIG.PCW_NOR_CS1_T_WC {11} \
   CONFIG.PCW_NOR_CS1_T_WP {1} \
   CONFIG.PCW_NOR_CS1_WE_TIME {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_A25_IO {<Select>} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_IO {<Select>} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_IO {<Select>} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_IO {<Select>} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_IO {<Select>} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_IO {<Select>} \
   CONFIG.PCW_NOR_NOR_IO {<Select>} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_SRAM_CS0_T_CEOE {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_PC {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_RC {11} \
   CONFIG.PCW_NOR_SRAM_CS0_T_TR {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_WC {11} \
   CONFIG.PCW_NOR_SRAM_CS0_T_WP {1} \
   CONFIG.PCW_NOR_SRAM_CS0_WE_TIME {0} \
   CONFIG.PCW_NOR_SRAM_CS1_T_CEOE {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_PC {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_RC {11} \
   CONFIG.PCW_NOR_SRAM_CS1_T_TR {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_WC {11} \
   CONFIG.PCW_NOR_SRAM_CS1_T_WP {1} \
   CONFIG.PCW_NOR_SRAM_CS1_WE_TIME {0} \
   CONFIG.PCW_OVERRIDE_BASIC_CLOCK {0} \
   CONFIG.PCW_P2F_CAN0_INTR {0} \
   CONFIG.PCW_P2F_CAN1_INTR {0} \
   CONFIG.PCW_P2F_CTI_INTR {0} \
   CONFIG.PCW_P2F_DMAC0_INTR {0} \
   CONFIG.PCW_P2F_DMAC1_INTR {0} \
   CONFIG.PCW_P2F_DMAC2_INTR {0} \
   CONFIG.PCW_P2F_DMAC3_INTR {0} \
   CONFIG.PCW_P2F_DMAC4_INTR {0} \
   CONFIG.PCW_P2F_DMAC5_INTR {0} \
   CONFIG.PCW_P2F_DMAC6_INTR {0} \
   CONFIG.PCW_P2F_DMAC7_INTR {0} \
   CONFIG.PCW_P2F_DMAC_ABORT_INTR {0} \
   CONFIG.PCW_P2F_ENET0_INTR {0} \
   CONFIG.PCW_P2F_ENET1_INTR {0} \
   CONFIG.PCW_P2F_GPIO_INTR {0} \
   CONFIG.PCW_P2F_I2C0_INTR {0} \
   CONFIG.PCW_P2F_I2C1_INTR {0} \
   CONFIG.PCW_P2F_QSPI_INTR {0} \
   CONFIG.PCW_P2F_SDIO0_INTR {0} \
   CONFIG.PCW_P2F_SDIO1_INTR {0} \
   CONFIG.PCW_P2F_SMC_INTR {0} \
   CONFIG.PCW_P2F_SPI0_INTR {0} \
   CONFIG.PCW_P2F_SPI1_INTR {0} \
   CONFIG.PCW_P2F_UART0_INTR {0} \
   CONFIG.PCW_P2F_UART1_INTR {0} \
   CONFIG.PCW_P2F_USB0_INTR {0} \
   CONFIG.PCW_P2F_USB1_INTR {0} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.063} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.062} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.065} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.083} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {-0.007} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {-0.010} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.006} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.048} \
   CONFIG.PCW_PACKAGE_NAME {clg484} \
   CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_PERIPHERAL_BOARD_PRESET {part0} \
   CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PJTAG_PJTAG_IO {<Select>} \
   CONFIG.PCW_PLL_BYPASSMODE_ENABLE {0} \
   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_PS7_SI_REV {PRODUCTION} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_FBCLK_IO {<Select>} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_IO1_IO {<Select>} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SS1_IO {<Select>} \
   CONFIG.PCW_QSPI_INTERNAL_HIGHADDRESS {0xFCFFFFFF} \
   CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_CD_IO {MIO 47} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_POW_IO {<Select>} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_WP_IO {MIO 46} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SD1_GRP_CD_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_CD_IO {<Select>} \
   CONFIG.PCW_SD1_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_POW_IO {<Select>} \
   CONFIG.PCW_SD1_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_WP_IO {<Select>} \
   CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SD1_SD1_IO {<Select>} \
   CONFIG.PCW_SDIO0_BASEADDR {0xE0100000} \
   CONFIG.PCW_SDIO0_HIGHADDR {0xE0100FFF} \
   CONFIG.PCW_SDIO1_BASEADDR {0xE0101000} \
   CONFIG.PCW_SDIO1_HIGHADDR {0xE0101FFF} \
   CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {10} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
   CONFIG.PCW_SMC_CYCLE_T0 {NA} \
   CONFIG.PCW_SMC_CYCLE_T1 {NA} \
   CONFIG.PCW_SMC_CYCLE_T2 {NA} \
   CONFIG.PCW_SMC_CYCLE_T3 {NA} \
   CONFIG.PCW_SMC_CYCLE_T4 {NA} \
   CONFIG.PCW_SMC_CYCLE_T5 {NA} \
   CONFIG.PCW_SMC_CYCLE_T6 {NA} \
   CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SMC_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SMC_PERIPHERAL_VALID {0} \
   CONFIG.PCW_SPI0_BASEADDR {0xE0006000} \
   CONFIG.PCW_SPI0_GRP_SS0_ENABLE {0} \
   CONFIG.PCW_SPI0_GRP_SS0_IO {<Select>} \
   CONFIG.PCW_SPI0_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_SPI0_GRP_SS1_IO {<Select>} \
   CONFIG.PCW_SPI0_GRP_SS2_ENABLE {0} \
   CONFIG.PCW_SPI0_GRP_SS2_IO {<Select>} \
   CONFIG.PCW_SPI0_HIGHADDR {0xE0006FFF} \
   CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SPI0_SPI0_IO {<Select>} \
   CONFIG.PCW_SPI1_BASEADDR {0xE0007000} \
   CONFIG.PCW_SPI1_GRP_SS0_ENABLE {0} \
   CONFIG.PCW_SPI1_GRP_SS0_IO {<Select>} \
   CONFIG.PCW_SPI1_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_SPI1_GRP_SS1_IO {<Select>} \
   CONFIG.PCW_SPI1_GRP_SS2_ENABLE {0} \
   CONFIG.PCW_SPI1_GRP_SS2_IO {<Select>} \
   CONFIG.PCW_SPI1_HIGHADDR {0xE0007FFF} \
   CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SPI1_SPI1_IO {<Select>} \
   CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ {166.666666} \
   CONFIG.PCW_SPI_PERIPHERAL_VALID {0} \
   CONFIG.PCW_S_AXI_ACP_ARUSER_VAL {31} \
   CONFIG.PCW_S_AXI_ACP_AWUSER_VAL {31} \
   CONFIG.PCW_S_AXI_ACP_ID_WIDTH {3} \
   CONFIG.PCW_S_AXI_GP0_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_GP1_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP0_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP1_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP1_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP2_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP2_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP3_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP3_ID_WIDTH {6} \
   CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_TRACE_BUFFER_CLOCK_DELAY {12} \
   CONFIG.PCW_TRACE_BUFFER_FIFO_SIZE {128} \
   CONFIG.PCW_TRACE_GRP_16BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_16BIT_IO {<Select>} \
   CONFIG.PCW_TRACE_GRP_2BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_2BIT_IO {<Select>} \
   CONFIG.PCW_TRACE_GRP_32BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_32BIT_IO {<Select>} \
   CONFIG.PCW_TRACE_GRP_4BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_4BIT_IO {<Select>} \
   CONFIG.PCW_TRACE_GRP_8BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_8BIT_IO {<Select>} \
   CONFIG.PCW_TRACE_INTERNAL_WIDTH {2} \
   CONFIG.PCW_TRACE_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TRACE_PIPELINE_WIDTH {8} \
   CONFIG.PCW_TRACE_TRACE_IO {<Select>} \
   CONFIG.PCW_TTC0_BASEADDR {0xE0104000} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_HIGHADDR {0xE0104fff} \
   CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TTC0_TTC0_IO {<Select>} \
   CONFIG.PCW_TTC1_BASEADDR {0xE0105000} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_HIGHADDR {0xE0105fff} \
   CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TTC1_TTC1_IO {<Select>} \
   CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART0_BASEADDR {0xE0000000} \
   CONFIG.PCW_UART0_BAUD_RATE {115200} \
   CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART0_GRP_FULL_IO {<Select>} \
   CONFIG.PCW_UART0_HIGHADDR {0xE0000FFF} \
   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_UART0_UART0_IO {<Select>} \
   CONFIG.PCW_UART1_BASEADDR {0xE0001000} \
   CONFIG.PCW_UART1_BAUD_RATE {115200} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_GRP_FULL_IO {<Select>} \
   CONFIG.PCW_UART1_HIGHADDR {0xE0001FFF} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
   CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {20} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE {0} \
   CONFIG.PCW_UIPARAM_DDR_AL {0} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BL {8} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.41} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.411} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.341} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.358} \
   CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {61.0905} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {61.0905} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {61.0905} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {61.0905} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {2048 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {68.4725} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {71.086} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {66.794} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {108.7385} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.025} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.028} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.001} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.001} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {64.1705} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {63.686} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {68.46} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {105.4895} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_ECC {Disabled} \
   CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
   CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533.333313} \
   CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} \
   CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J128M16 HA-15E} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {14} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {45.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {36.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {49.5} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} \
   CONFIG.PCW_UIPARAM_GENERATE_SUMMARY {NA} \
   CONFIG.PCW_USB0_BASEADDR {0xE0102000} \
   CONFIG.PCW_USB0_HIGHADDR {0xE0102fff} \
   CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB0_RESET_ENABLE {0} \
   CONFIG.PCW_USB0_RESET_IO {<Select>} \
   CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
   CONFIG.PCW_USB1_BASEADDR {0xE0103000} \
   CONFIG.PCW_USB1_HIGHADDR {0xE0103fff} \
   CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB1_RESET_IO {<Select>} \
   CONFIG.PCW_USB1_USB1_IO {<Select>} \
   CONFIG.PCW_USB_RESET_ENABLE {1} \
   CONFIG.PCW_USB_RESET_POLARITY {Active Low} \
   CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_USE_AXI_FABRIC_IDLE {0} \
   CONFIG.PCW_USE_AXI_NONSECURE {0} \
   CONFIG.PCW_USE_CORESIGHT {0} \
   CONFIG.PCW_USE_CROSS_TRIGGER {0} \
   CONFIG.PCW_USE_CR_FABRIC {1} \
   CONFIG.PCW_USE_DDR_BYPASS {0} \
   CONFIG.PCW_USE_DEBUG {0} \
   CONFIG.PCW_USE_DEFAULT_ACP_USER_VAL {0} \
   CONFIG.PCW_USE_DMA0 {0} \
   CONFIG.PCW_USE_DMA1 {0} \
   CONFIG.PCW_USE_DMA2 {0} \
   CONFIG.PCW_USE_DMA3 {0} \
   CONFIG.PCW_USE_EXPANDED_IOP {0} \
   CONFIG.PCW_USE_EXPANDED_PS_SLCR_REGISTERS {0} \
   CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
   CONFIG.PCW_USE_HIGH_OCM {0} \
   CONFIG.PCW_USE_M_AXI_GP0 {1} \
   CONFIG.PCW_USE_M_AXI_GP1 {0} \
   CONFIG.PCW_USE_PROC_EVENT_BUS {0} \
   CONFIG.PCW_USE_PS_SLCR_REGISTERS {0} \
   CONFIG.PCW_USE_S_AXI_ACP {0} \
   CONFIG.PCW_USE_S_AXI_GP0 {0} \
   CONFIG.PCW_USE_S_AXI_GP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP0 {1} \
   CONFIG.PCW_USE_S_AXI_HP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP2 {1} \
   CONFIG.PCW_USE_S_AXI_HP3 {0} \
   CONFIG.PCW_USE_TRACE {0} \
   CONFIG.PCW_USE_TRACE_DATA_EDGE_DETECTOR {0} \
   CONFIG.PCW_VALUE_SILVERSION {3} \
   CONFIG.PCW_WDT_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_WDT_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_WDT_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_WDT_WDT_IO {<Select>} \
   CONFIG.preset {ZedBoard} \
 ] $processing_system7_0

  # Create instance: ps7_0_axi_periph, and set properties
  set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.M06_HAS_REGSLICE {0} \
   CONFIG.M16_HAS_REGSLICE {0} \
   CONFIG.M17_HAS_REGSLICE {0} \
   CONFIG.M18_HAS_REGSLICE {0} \
   CONFIG.NUM_MI {24} \
   CONFIG.S00_HAS_REGSLICE {4} \
   CONFIG.SYNCHRONIZATION_STAGES {2} \
 ] $ps7_0_axi_periph

  # Create instance: rgb2vga_0, and set properties
  set rgb2vga_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:rgb2vga:1.0 rgb2vga_0 ]
  set_property -dict [ list \
   CONFIG.kBlueDepth {4} \
   CONFIG.kGreenDepth {4} \
   CONFIG.kRedDepth {4} \
 ] $rgb2vga_0

  # Create instance: rst_clk_wiz_0_50M, and set properties
  set rst_clk_wiz_0_50M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_0_50M ]

  # Create instance: rst_system_150M, and set properties
  set rst_system_150M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_system_150M ]

  # Create instance: rst_vid_clk_dyn, and set properties
  set rst_vid_clk_dyn [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_vid_clk_dyn ]

  # Create instance: v_axi4s_vid_out_0, and set properties
  set v_axi4s_vid_out_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:4.0 v_axi4s_vid_out_0 ]
  set_property -dict [ list \
   CONFIG.C_HAS_ASYNC_CLK {1} \
   CONFIG.C_VTG_MASTER_SLAVE {1} \
 ] $v_axi4s_vid_out_0

  # Create instance: video_dynclk, and set properties
  set video_dynclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 video_dynclk ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_DRIVES {No_buffer} \
   CONFIG.CLKOUT1_JITTER {232.529} \
   CONFIG.CLKOUT1_PHASE_ERROR {322.999} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {742.5} \
   CONFIG.CLKOUT2_DRIVES {BUFG} \
   CONFIG.CLKOUT3_DRIVES {BUFG} \
   CONFIG.CLKOUT4_DRIVES {BUFG} \
   CONFIG.CLKOUT5_DRIVES {BUFG} \
   CONFIG.CLKOUT6_DRIVES {BUFG} \
   CONFIG.CLKOUT7_DRIVES {BUFG} \
   CONFIG.CLK_OUT1_PORT {pxl_clk_5x} \
   CONFIG.FEEDBACK_SOURCE {FDBK_ONCHIP} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {37.125} \
   CONFIG.MMCM_CLKIN1_PERIOD {10.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {1.000} \
   CONFIG.MMCM_DIVCLK_DIVIDE {5} \
   CONFIG.PRIM_SOURCE {No_buffer} \
   CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.USE_DYN_RECONFIG {true} \
   CONFIG.USE_FREQ_SYNTH {true} \
   CONFIG.USE_PHASE_ALIGNMENT {false} \
 ] $video_dynclk

  # Create instance: video_scaler_a, and set properties
  set video_scaler_a [ create_bd_cell -type ip -vlnv digilentinc.com:video:video_scaler:1.0 video_scaler_a ]

  # Create instance: video_scaler_b, and set properties
  set video_scaler_b [ create_bd_cell -type ip -vlnv digilentinc.com:video:video_scaler:1.0 video_scaler_b ]

  # Create instance: video_scaler_c, and set properties
  set video_scaler_c [ create_bd_cell -type ip -vlnv digilentinc.com:video:video_scaler:1.0 video_scaler_c ]

  # Create instance: video_scaler_d, and set properties
  set video_scaler_d [ create_bd_cell -type ip -vlnv digilentinc.com:video:video_scaler:1.0 video_scaler_d ]

  # Create instance: vtg, and set properties
  set vtg [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.1 vtg ]
  set_property -dict [ list \
   CONFIG.GEN_F0_VBLANK_HEND {1280} \
   CONFIG.GEN_F0_VBLANK_HSTART {1280} \
   CONFIG.GEN_F0_VFRAME_SIZE {750} \
   CONFIG.GEN_F0_VSYNC_HEND {1280} \
   CONFIG.GEN_F0_VSYNC_HSTART {1280} \
   CONFIG.GEN_F0_VSYNC_VEND {729} \
   CONFIG.GEN_F0_VSYNC_VSTART {724} \
   CONFIG.GEN_F1_VBLANK_HEND {1280} \
   CONFIG.GEN_F1_VBLANK_HSTART {1280} \
   CONFIG.GEN_F1_VFRAME_SIZE {750} \
   CONFIG.GEN_F1_VSYNC_HEND {1280} \
   CONFIG.GEN_F1_VSYNC_HSTART {1280} \
   CONFIG.GEN_F1_VSYNC_VEND {729} \
   CONFIG.GEN_F1_VSYNC_VSTART {724} \
   CONFIG.GEN_HACTIVE_SIZE {1280} \
   CONFIG.GEN_HFRAME_SIZE {1650} \
   CONFIG.GEN_HSYNC_END {1430} \
   CONFIG.GEN_HSYNC_START {1390} \
   CONFIG.GEN_VACTIVE_SIZE {720} \
   CONFIG.VIDEO_MODE {720p} \
   CONFIG.enable_detection {false} \
 ] $vtg

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {6} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_1

  # Create interface connections
  connect_bd_intf_net -intf_net AXI_BayerToRGB_0_AXI_Stream_Master [get_bd_intf_pins AXI_BayerToRGB_B/AXI_Stream_Master] [get_bd_intf_pins AXI_GammaCorrection_B/AXI_Slave_Interface]
  connect_bd_intf_net -intf_net AXI_BayerToRGB_1_AXI_Stream_Master [get_bd_intf_pins AXI_BayerToRGB_A/AXI_Stream_Master] [get_bd_intf_pins AXI_GammaCorrection_A/AXI_Slave_Interface]
  connect_bd_intf_net -intf_net AXI_BayerToRGB_2_AXI_Stream_Master [get_bd_intf_pins AXI_BayerToRGB_C/AXI_Stream_Master] [get_bd_intf_pins AXI_GammaCorrection_C/AXI_Slave_Interface]
  connect_bd_intf_net -intf_net AXI_BayerToRGB_3_AXI_Stream_Master [get_bd_intf_pins AXI_BayerToRGB_D/AXI_Stream_Master] [get_bd_intf_pins AXI_GammaCorrection_D/AXI_Slave_Interface]
  connect_bd_intf_net -intf_net AXI_GammaCorrection_A_AXI_Stream_Master [get_bd_intf_pins AXI_GammaCorrection_A/AXI_Stream_Master] [get_bd_intf_pins video_scaler_a/stream_in]
  connect_bd_intf_net -intf_net AXI_GammaCorrection_B_AXI_Stream_Master [get_bd_intf_pins AXI_GammaCorrection_B/AXI_Stream_Master] [get_bd_intf_pins video_scaler_b/stream_in]
  connect_bd_intf_net -intf_net AXI_GammaCorrection_C_AXI_Stream_Master [get_bd_intf_pins AXI_GammaCorrection_C/AXI_Stream_Master] [get_bd_intf_pins video_scaler_c/stream_in]
  connect_bd_intf_net -intf_net AXI_GammaCorrection_D_AXI_Stream_Master [get_bd_intf_pins AXI_GammaCorrection_D/AXI_Stream_Master] [get_bd_intf_pins video_scaler_d/stream_in]
  connect_bd_intf_net -intf_net MIPI_CSI_2_RX_0_m_axis_video [get_bd_intf_pins AXI_BayerToRGB_A/AXI_Slave_Interface] [get_bd_intf_pins MIPI_CSI_2_RX_A/m_axis_video]
  connect_bd_intf_net -intf_net MIPI_CSI_2_RX_1_m_axis_video [get_bd_intf_pins AXI_BayerToRGB_B/AXI_Slave_Interface] [get_bd_intf_pins MIPI_CSI_2_RX_B/m_axis_video]
  connect_bd_intf_net -intf_net MIPI_CSI_2_RX_2_m_axis_video [get_bd_intf_pins AXI_BayerToRGB_C/AXI_Slave_Interface] [get_bd_intf_pins MIPI_CSI_2_RX_C/m_axis_video]
  connect_bd_intf_net -intf_net MIPI_CSI_2_RX_3_m_axis_video [get_bd_intf_pins AXI_BayerToRGB_D/AXI_Slave_Interface] [get_bd_intf_pins MIPI_CSI_2_RX_D/m_axis_video]
  connect_bd_intf_net -intf_net MIPI_D_PHY_RX_0_D_PHY_PPI [get_bd_intf_pins MIPI_CSI_2_RX_A/rx_mipi_ppi] [get_bd_intf_pins MIPI_D_PHY_RX_A/D_PHY_PPI]
  connect_bd_intf_net -intf_net MIPI_D_PHY_RX_1_D_PHY_PPI [get_bd_intf_pins MIPI_CSI_2_RX_B/rx_mipi_ppi] [get_bd_intf_pins MIPI_D_PHY_RX_B/D_PHY_PPI]
  connect_bd_intf_net -intf_net MIPI_D_PHY_RX_2_D_PHY_PPI [get_bd_intf_pins MIPI_CSI_2_RX_C/rx_mipi_ppi] [get_bd_intf_pins MIPI_D_PHY_RX_C/D_PHY_PPI]
  connect_bd_intf_net -intf_net MIPI_D_PHY_RX_3_D_PHY_PPI [get_bd_intf_pins MIPI_CSI_2_RX_D/rx_mipi_ppi] [get_bd_intf_pins MIPI_D_PHY_RX_D/D_PHY_PPI]
  connect_bd_intf_net -intf_net axi_cama_bta_GPIO [get_bd_intf_ports cama_bta] [get_bd_intf_pins axi_cama_bta/GPIO]
  connect_bd_intf_net -intf_net axi_cama_gpio_GPIO [get_bd_intf_ports cama_gpio] [get_bd_intf_pins axi_cama_gpio/GPIO]
  connect_bd_intf_net -intf_net axi_mem_intercon_1_M00_AXI [get_bd_intf_pins axi_mem_intercon_1/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP2]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_vdma_a/M_AXIS_MM2S] [get_bd_intf_pins v_axi4s_vid_out_0/video_in]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_MM2S [get_bd_intf_pins axi_mem_intercon/S00_AXI] [get_bd_intf_pins axi_vdma_a/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_S2MM [get_bd_intf_pins axi_mem_intercon_1/S00_AXI] [get_bd_intf_pins axi_vdma_a/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_vdma_1_M_AXI_S2MM [get_bd_intf_pins axi_mem_intercon_1/S02_AXI] [get_bd_intf_pins axi_vdma_c/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_vdma_2_M_AXI_S2MM [get_bd_intf_pins axi_mem_intercon_1/S01_AXI] [get_bd_intf_pins axi_vdma_b/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_vdma_3_M_AXI_S2MM [get_bd_intf_pins axi_mem_intercon_1/S03_AXI] [get_bd_intf_pins axi_vdma_d/M_AXI_S2MM]
  connect_bd_intf_net -intf_net dphy_hs_clock_0_1 [get_bd_intf_ports dphy_b_hs_clock] [get_bd_intf_pins MIPI_D_PHY_RX_B/dphy_hs_clock]
  connect_bd_intf_net -intf_net dphy_hs_clock_1 [get_bd_intf_ports dphy_a_hs_clock] [get_bd_intf_pins MIPI_D_PHY_RX_A/dphy_hs_clock]
  connect_bd_intf_net -intf_net dphy_hs_clock_1_1 [get_bd_intf_ports dphy_c_hs_clock] [get_bd_intf_pins MIPI_D_PHY_RX_C/dphy_hs_clock]
  connect_bd_intf_net -intf_net dphy_hs_clock_2_1 [get_bd_intf_ports dphy_d_hs_clock] [get_bd_intf_pins MIPI_D_PHY_RX_D/dphy_hs_clock]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_GPIO_0 [get_bd_intf_ports cam_pwup] [get_bd_intf_pins processing_system7_0/GPIO_0]
  connect_bd_intf_net -intf_net processing_system7_0_IIC_0 [get_bd_intf_ports cam_iic] [get_bd_intf_pins processing_system7_0/IIC_0]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_vdma_a/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M01_AXI [get_bd_intf_pins ps7_0_axi_periph/M01_AXI] [get_bd_intf_pins video_dynclk/s_axi_lite]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M02_AXI [get_bd_intf_pins ps7_0_axi_periph/M02_AXI] [get_bd_intf_pins vtg/ctrl]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M03_AXI [get_bd_intf_pins MIPI_D_PHY_RX_A/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M04_AXI [get_bd_intf_pins MIPI_CSI_2_RX_A/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M05_AXI [get_bd_intf_pins AXI_GammaCorrection_A/AXI_Lite_Reg_Intf] [get_bd_intf_pins ps7_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M06_AXI [get_bd_intf_pins ps7_0_axi_periph/M06_AXI] [get_bd_intf_pins video_scaler_a/s_axi_ctrl]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M07_AXI [get_bd_intf_pins MIPI_D_PHY_RX_B/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M08_AXI [get_bd_intf_pins MIPI_D_PHY_RX_C/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M08_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M09_AXI [get_bd_intf_pins MIPI_D_PHY_RX_D/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M09_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M10_AXI [get_bd_intf_pins MIPI_CSI_2_RX_B/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M10_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M11_AXI [get_bd_intf_pins MIPI_CSI_2_RX_C/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M11_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M12_AXI [get_bd_intf_pins MIPI_CSI_2_RX_D/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M12_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M13_AXI [get_bd_intf_pins AXI_GammaCorrection_B/AXI_Lite_Reg_Intf] [get_bd_intf_pins ps7_0_axi_periph/M13_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M14_AXI [get_bd_intf_pins AXI_GammaCorrection_C/AXI_Lite_Reg_Intf] [get_bd_intf_pins ps7_0_axi_periph/M14_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M15_AXI [get_bd_intf_pins AXI_GammaCorrection_D/AXI_Lite_Reg_Intf] [get_bd_intf_pins ps7_0_axi_periph/M15_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M16_AXI [get_bd_intf_pins ps7_0_axi_periph/M16_AXI] [get_bd_intf_pins video_scaler_b/s_axi_ctrl]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M17_AXI [get_bd_intf_pins ps7_0_axi_periph/M17_AXI] [get_bd_intf_pins video_scaler_d/s_axi_ctrl]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M18_AXI [get_bd_intf_pins ps7_0_axi_periph/M18_AXI] [get_bd_intf_pins video_scaler_c/s_axi_ctrl]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M19_AXI [get_bd_intf_pins axi_vdma_b/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M19_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M20_AXI [get_bd_intf_pins axi_vdma_c/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M20_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M21_AXI [get_bd_intf_pins axi_vdma_d/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M21_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M22_AXI [get_bd_intf_pins axi_cama_gpio/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M22_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M23_AXI [get_bd_intf_pins axi_cama_bta/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M23_AXI]
  connect_bd_intf_net -intf_net v_axi4s_vid_out_0_vid_io_out [get_bd_intf_pins rgb2vga_0/vid_in] [get_bd_intf_pins v_axi4s_vid_out_0/vid_io_out]
  connect_bd_intf_net -intf_net v_tc_0_vtiming_out [get_bd_intf_pins v_axi4s_vid_out_0/vtiming_in] [get_bd_intf_pins vtg/vtiming_out]
  connect_bd_intf_net -intf_net video_scaler_0_stream_out [get_bd_intf_pins axi_vdma_a/S_AXIS_S2MM] [get_bd_intf_pins video_scaler_a/stream_out]
  connect_bd_intf_net -intf_net video_scaler_b_stream_out [get_bd_intf_pins axi_vdma_b/S_AXIS_S2MM] [get_bd_intf_pins video_scaler_b/stream_out]
  connect_bd_intf_net -intf_net video_scaler_c_stream_out [get_bd_intf_pins axi_vdma_c/S_AXIS_S2MM] [get_bd_intf_pins video_scaler_c/stream_out]
  connect_bd_intf_net -intf_net video_scaler_d_stream_out [get_bd_intf_pins axi_vdma_d/S_AXIS_S2MM] [get_bd_intf_pins video_scaler_d/stream_out]

  # Create port connections
  connect_bd_net -net DVIClocking_0_aLockedOut [get_bd_pins DVIClocking_0/aLockedOut] [get_bd_pins rst_vid_clk_dyn/dcm_locked]
  connect_bd_net -net MIPI_D_PHY_RX_0_RxByteClkHS [get_bd_pins MIPI_CSI_2_RX_A/RxByteClkHS] [get_bd_pins MIPI_D_PHY_RX_A/RxByteClkHS]
  connect_bd_net -net MIPI_D_PHY_RX_0_rDlyCtrlLockedOut [get_bd_pins MIPI_D_PHY_RX_A/rDlyCtrlLockedOut] [get_bd_pins MIPI_D_PHY_RX_B/rDlyCtrlLockedIn] [get_bd_pins MIPI_D_PHY_RX_C/rDlyCtrlLockedIn] [get_bd_pins MIPI_D_PHY_RX_D/rDlyCtrlLockedIn]
  connect_bd_net -net MIPI_D_PHY_RX_1_RxByteClkHS [get_bd_pins MIPI_CSI_2_RX_B/RxByteClkHS] [get_bd_pins MIPI_D_PHY_RX_B/RxByteClkHS]
  connect_bd_net -net MIPI_D_PHY_RX_2_RxByteClkHS [get_bd_pins MIPI_CSI_2_RX_C/RxByteClkHS] [get_bd_pins MIPI_D_PHY_RX_C/RxByteClkHS]
  connect_bd_net -net MIPI_D_PHY_RX_3_RxByteClkHS [get_bd_pins MIPI_CSI_2_RX_D/RxByteClkHS] [get_bd_pins MIPI_D_PHY_RX_D/RxByteClkHS]
  connect_bd_net -net PixelClk_Generator_clk_out1 [get_bd_pins DVIClocking_0/PixelClk] [get_bd_pins rgb2vga_0/PixelClk] [get_bd_pins rst_vid_clk_dyn/slowest_sync_clk] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_clk] [get_bd_pins vtg/clk]
  connect_bd_net -net axi_vdma_0_mm2s_introut [get_bd_pins axi_vdma_a/mm2s_introut] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_vdma_0_s2mm_introut [get_bd_pins axi_vdma_a/s2mm_introut] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_vdma_1_s2mm_introut [get_bd_pins axi_vdma_c/s2mm_introut] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net axi_vdma_2_s2mm_introut [get_bd_pins axi_vdma_b/s2mm_introut] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net axi_vdma_3_s2mm_introut [get_bd_pins axi_vdma_d/s2mm_introut] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net axi_vdma_a_s2mm_frame_ptr_out [get_bd_pins axi_vdma_a/s2mm_frame_ptr_out] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net axi_vdma_b_s2mm_frame_ptr_out [get_bd_pins axi_vdma_b/s2mm_frame_ptr_out] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net axi_vdma_c_s2mm_frame_ptr_out [get_bd_pins axi_vdma_c/s2mm_frame_ptr_out] [get_bd_pins xlconcat_1/In2]
  connect_bd_net -net axi_vdma_d_s2mm_frame_ptr_out [get_bd_pins axi_vdma_d/s2mm_frame_ptr_out] [get_bd_pins xlconcat_1/In3]
  connect_bd_net -net cama_gpio_dir_dout [get_bd_ports cam_gpio_dir] [get_bd_pins cama_gpio_dir/dout]
  connect_bd_net -net cama_gpio_oen_dout [get_bd_ports cam_gpio_oen] [get_bd_pins cama_gpio_oen/dout]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins rst_clk_wiz_0_50M/dcm_locked] [get_bd_pins rst_system_150M/dcm_locked]
  connect_bd_net -net clk_wiz_1_locked [get_bd_pins DVIClocking_0/aLockedIn] [get_bd_pins video_dynclk/locked]
  connect_bd_net -net clk_wiz_1_pxl_clk_5x [get_bd_pins DVIClocking_0/PixelClk5X] [get_bd_pins video_dynclk/pxl_clk_5x]
  connect_bd_net -net dphy_clk_lp_n_0_1 [get_bd_ports dphy_b_clk_lp_n] [get_bd_pins MIPI_D_PHY_RX_B/dphy_clk_lp_n]
  connect_bd_net -net dphy_clk_lp_n_1 [get_bd_ports dphy_a_clk_lp_n] [get_bd_pins MIPI_D_PHY_RX_A/dphy_clk_lp_n]
  connect_bd_net -net dphy_clk_lp_n_1_1 [get_bd_ports dphy_c_clk_lp_n] [get_bd_pins MIPI_D_PHY_RX_C/dphy_clk_lp_n]
  connect_bd_net -net dphy_clk_lp_n_2_1 [get_bd_ports dphy_d_clk_lp_n] [get_bd_pins MIPI_D_PHY_RX_D/dphy_clk_lp_n]
  connect_bd_net -net dphy_clk_lp_p_0_1 [get_bd_ports dphy_b_clk_lp_p] [get_bd_pins MIPI_D_PHY_RX_B/dphy_clk_lp_p]
  connect_bd_net -net dphy_clk_lp_p_1 [get_bd_ports dphy_a_clk_lp_p] [get_bd_pins MIPI_D_PHY_RX_A/dphy_clk_lp_p]
  connect_bd_net -net dphy_clk_lp_p_1_1 [get_bd_ports dphy_c_clk_lp_p] [get_bd_pins MIPI_D_PHY_RX_C/dphy_clk_lp_p]
  connect_bd_net -net dphy_clk_lp_p_2_1 [get_bd_ports dphy_d_clk_lp_p] [get_bd_pins MIPI_D_PHY_RX_D/dphy_clk_lp_p]
  connect_bd_net -net dphy_data_hs_n_0_1 [get_bd_ports dphy_b_data_hs_n] [get_bd_pins MIPI_D_PHY_RX_B/dphy_data_hs_n]
  connect_bd_net -net dphy_data_hs_n_1 [get_bd_ports dphy_a_data_hs_n] [get_bd_pins MIPI_D_PHY_RX_A/dphy_data_hs_n]
  connect_bd_net -net dphy_data_hs_n_1_1 [get_bd_ports dphy_c_data_hs_n] [get_bd_pins MIPI_D_PHY_RX_C/dphy_data_hs_n]
  connect_bd_net -net dphy_data_hs_n_2_1 [get_bd_ports dphy_d_data_hs_n] [get_bd_pins MIPI_D_PHY_RX_D/dphy_data_hs_n]
  connect_bd_net -net dphy_data_hs_p_0_1 [get_bd_ports dphy_b_data_hs_p] [get_bd_pins MIPI_D_PHY_RX_B/dphy_data_hs_p]
  connect_bd_net -net dphy_data_hs_p_1 [get_bd_ports dphy_a_data_hs_p] [get_bd_pins MIPI_D_PHY_RX_A/dphy_data_hs_p]
  connect_bd_net -net dphy_data_hs_p_1_1 [get_bd_ports dphy_c_data_hs_p] [get_bd_pins MIPI_D_PHY_RX_C/dphy_data_hs_p]
  connect_bd_net -net dphy_data_hs_p_2_1 [get_bd_ports dphy_d_data_hs_p] [get_bd_pins MIPI_D_PHY_RX_D/dphy_data_hs_p]
  connect_bd_net -net dphy_data_lp_n_0_1 [get_bd_ports dphy_b_data_lp_n] [get_bd_pins MIPI_D_PHY_RX_B/dphy_data_lp_n]
  connect_bd_net -net dphy_data_lp_n_1 [get_bd_ports dphy_a_data_lp_n] [get_bd_pins MIPI_D_PHY_RX_A/dphy_data_lp_n]
  connect_bd_net -net dphy_data_lp_n_1_1 [get_bd_ports dphy_c_data_lp_n] [get_bd_pins MIPI_D_PHY_RX_C/dphy_data_lp_n]
  connect_bd_net -net dphy_data_lp_n_2_1 [get_bd_ports dphy_d_data_lp_n] [get_bd_pins MIPI_D_PHY_RX_D/dphy_data_lp_n]
  connect_bd_net -net dphy_data_lp_p_0_1 [get_bd_ports dphy_b_data_lp_p] [get_bd_pins MIPI_D_PHY_RX_B/dphy_data_lp_p]
  connect_bd_net -net dphy_data_lp_p_1 [get_bd_ports dphy_a_data_lp_p] [get_bd_pins MIPI_D_PHY_RX_A/dphy_data_lp_p]
  connect_bd_net -net dphy_data_lp_p_1_1 [get_bd_ports dphy_c_data_lp_p] [get_bd_pins MIPI_D_PHY_RX_C/dphy_data_lp_p]
  connect_bd_net -net dphy_data_lp_p_2_1 [get_bd_ports dphy_d_data_lp_p] [get_bd_pins MIPI_D_PHY_RX_D/dphy_data_lp_p]
  connect_bd_net -net mm_clk_150 [get_bd_pins AXI_BayerToRGB_A/StreamClk] [get_bd_pins AXI_BayerToRGB_B/StreamClk] [get_bd_pins AXI_BayerToRGB_C/StreamClk] [get_bd_pins AXI_BayerToRGB_D/StreamClk] [get_bd_pins AXI_GammaCorrection_A/StreamClk] [get_bd_pins AXI_GammaCorrection_B/StreamClk] [get_bd_pins AXI_GammaCorrection_C/StreamClk] [get_bd_pins AXI_GammaCorrection_D/StreamClk] [get_bd_pins MIPI_CSI_2_RX_A/video_aclk] [get_bd_pins MIPI_CSI_2_RX_B/video_aclk] [get_bd_pins MIPI_CSI_2_RX_C/video_aclk] [get_bd_pins MIPI_CSI_2_RX_D/video_aclk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon_1/ACLK] [get_bd_pins axi_mem_intercon_1/M00_ACLK] [get_bd_pins axi_mem_intercon_1/S00_ACLK] [get_bd_pins axi_mem_intercon_1/S01_ACLK] [get_bd_pins axi_mem_intercon_1/S02_ACLK] [get_bd_pins axi_mem_intercon_1/S03_ACLK] [get_bd_pins axi_vdma_a/m_axi_mm2s_aclk] [get_bd_pins axi_vdma_a/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_a/m_axis_mm2s_aclk] [get_bd_pins axi_vdma_a/s_axis_s2mm_aclk] [get_bd_pins axi_vdma_b/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_b/s_axis_s2mm_aclk] [get_bd_pins axi_vdma_c/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_c/s_axis_s2mm_aclk] [get_bd_pins axi_vdma_d/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_d/s_axis_s2mm_aclk] [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP2_ACLK] [get_bd_pins ps7_0_axi_periph/M06_ACLK] [get_bd_pins ps7_0_axi_periph/M16_ACLK] [get_bd_pins ps7_0_axi_periph/M17_ACLK] [get_bd_pins ps7_0_axi_periph/M18_ACLK] [get_bd_pins rst_system_150M/slowest_sync_clk] [get_bd_pins v_axi4s_vid_out_0/aclk] [get_bd_pins video_scaler_a/ap_clk] [get_bd_pins video_scaler_b/ap_clk] [get_bd_pins video_scaler_c/ap_clk] [get_bd_pins video_scaler_d/ap_clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins video_dynclk/clk_in1]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_clk_wiz_0_50M/ext_reset_in] [get_bd_pins rst_system_150M/ext_reset_in] [get_bd_pins rst_vid_clk_dyn/ext_reset_in]
  connect_bd_net -net ref_clk_200 [get_bd_pins MIPI_D_PHY_RX_A/RefClk] [get_bd_pins MIPI_D_PHY_RX_B/RefClk] [get_bd_pins MIPI_D_PHY_RX_C/RefClk] [get_bd_pins MIPI_D_PHY_RX_D/RefClk] [get_bd_pins clk_wiz_0/clk_out3]
  connect_bd_net -net rgb2vga_0_vga_pBlue [get_bd_ports vga_pBlue] [get_bd_pins rgb2vga_0/vga_pBlue]
  connect_bd_net -net rgb2vga_0_vga_pGreen [get_bd_ports vga_pGreen] [get_bd_pins rgb2vga_0/vga_pGreen]
  connect_bd_net -net rgb2vga_0_vga_pHSync [get_bd_ports vga_pHSync] [get_bd_pins rgb2vga_0/vga_pHSync]
  connect_bd_net -net rgb2vga_0_vga_pRed [get_bd_ports vga_pRed] [get_bd_pins rgb2vga_0/vga_pRed]
  connect_bd_net -net rgb2vga_0_vga_pVSync [get_bd_ports vga_pVSync] [get_bd_pins rgb2vga_0/vga_pVSync]
  connect_bd_net -net rst_clk_wiz_0_50M_interconnect_aresetn [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins axi_mem_intercon_1/ARESETN] [get_bd_pins ps7_0_axi_periph/ARESETN] [get_bd_pins rst_clk_wiz_0_50M/interconnect_aresetn]
  connect_bd_net -net rst_clk_wiz_0_50M_peripheral_aresetn [get_bd_pins AXI_BayerToRGB_A/sStreamReset_n] [get_bd_pins AXI_BayerToRGB_B/sStreamReset_n] [get_bd_pins AXI_BayerToRGB_C/sStreamReset_n] [get_bd_pins AXI_BayerToRGB_D/sStreamReset_n] [get_bd_pins AXI_GammaCorrection_A/aAxiLiteReset_n] [get_bd_pins AXI_GammaCorrection_A/sStreamReset_n] [get_bd_pins AXI_GammaCorrection_B/aAxiLiteReset_n] [get_bd_pins AXI_GammaCorrection_B/sStreamReset_n] [get_bd_pins AXI_GammaCorrection_C/aAxiLiteReset_n] [get_bd_pins AXI_GammaCorrection_C/sStreamReset_n] [get_bd_pins AXI_GammaCorrection_D/aAxiLiteReset_n] [get_bd_pins AXI_GammaCorrection_D/sStreamReset_n] [get_bd_pins MIPI_CSI_2_RX_A/s_axi_lite_aresetn] [get_bd_pins MIPI_CSI_2_RX_B/s_axi_lite_aresetn] [get_bd_pins MIPI_CSI_2_RX_C/s_axi_lite_aresetn] [get_bd_pins MIPI_CSI_2_RX_D/s_axi_lite_aresetn] [get_bd_pins MIPI_D_PHY_RX_A/s_axi_lite_aresetn] [get_bd_pins MIPI_D_PHY_RX_B/s_axi_lite_aresetn] [get_bd_pins MIPI_D_PHY_RX_C/s_axi_lite_aresetn] [get_bd_pins MIPI_D_PHY_RX_D/s_axi_lite_aresetn] [get_bd_pins axi_cama_bta/s_axi_aresetn] [get_bd_pins axi_cama_gpio/s_axi_aresetn] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon_1/M00_ARESETN] [get_bd_pins axi_mem_intercon_1/S00_ARESETN] [get_bd_pins axi_mem_intercon_1/S01_ARESETN] [get_bd_pins axi_mem_intercon_1/S02_ARESETN] [get_bd_pins axi_mem_intercon_1/S03_ARESETN] [get_bd_pins axi_vdma_a/axi_resetn] [get_bd_pins axi_vdma_b/axi_resetn] [get_bd_pins axi_vdma_c/axi_resetn] [get_bd_pins axi_vdma_d/axi_resetn] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/M03_ARESETN] [get_bd_pins ps7_0_axi_periph/M04_ARESETN] [get_bd_pins ps7_0_axi_periph/M05_ARESETN] [get_bd_pins ps7_0_axi_periph/M07_ARESETN] [get_bd_pins ps7_0_axi_periph/M08_ARESETN] [get_bd_pins ps7_0_axi_periph/M09_ARESETN] [get_bd_pins ps7_0_axi_periph/M10_ARESETN] [get_bd_pins ps7_0_axi_periph/M11_ARESETN] [get_bd_pins ps7_0_axi_periph/M12_ARESETN] [get_bd_pins ps7_0_axi_periph/M13_ARESETN] [get_bd_pins ps7_0_axi_periph/M14_ARESETN] [get_bd_pins ps7_0_axi_periph/M15_ARESETN] [get_bd_pins ps7_0_axi_periph/M19_ARESETN] [get_bd_pins ps7_0_axi_periph/M20_ARESETN] [get_bd_pins ps7_0_axi_periph/M21_ARESETN] [get_bd_pins ps7_0_axi_periph/M22_ARESETN] [get_bd_pins ps7_0_axi_periph/M23_ARESETN] [get_bd_pins ps7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_clk_wiz_0_50M/peripheral_aresetn] [get_bd_pins v_axi4s_vid_out_0/aresetn] [get_bd_pins video_dynclk/s_axi_aresetn] [get_bd_pins video_scaler_a/ap_rst_n] [get_bd_pins video_scaler_b/ap_rst_n] [get_bd_pins video_scaler_c/ap_rst_n] [get_bd_pins video_scaler_d/ap_rst_n] [get_bd_pins vtg/s_axi_aresetn]
  connect_bd_net -net rst_clk_wiz_0_50M_peripheral_reset [get_bd_pins MIPI_D_PHY_RX_A/aRst] [get_bd_pins MIPI_D_PHY_RX_B/aRst] [get_bd_pins MIPI_D_PHY_RX_C/aRst] [get_bd_pins MIPI_D_PHY_RX_D/aRst] [get_bd_pins rst_clk_wiz_0_50M/peripheral_reset]
  connect_bd_net -net rst_system_150M_peripheral_aresetn [get_bd_pins ps7_0_axi_periph/M06_ARESETN] [get_bd_pins ps7_0_axi_periph/M16_ARESETN] [get_bd_pins ps7_0_axi_periph/M17_ARESETN] [get_bd_pins ps7_0_axi_periph/M18_ARESETN] [get_bd_pins rst_system_150M/peripheral_aresetn]
  connect_bd_net -net rst_vid_clk_dyn_peripheral_aresetn [get_bd_pins rst_vid_clk_dyn/peripheral_aresetn] [get_bd_pins vtg/resetn]
  connect_bd_net -net rst_vid_clk_dyn_peripheral_reset [get_bd_pins rst_vid_clk_dyn/peripheral_reset] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_reset]
  connect_bd_net -net s_axil_clk_50 [get_bd_pins AXI_GammaCorrection_A/AxiLiteClk] [get_bd_pins AXI_GammaCorrection_B/AxiLiteClk] [get_bd_pins AXI_GammaCorrection_C/AxiLiteClk] [get_bd_pins AXI_GammaCorrection_D/AxiLiteClk] [get_bd_pins MIPI_CSI_2_RX_A/s_axi_lite_aclk] [get_bd_pins MIPI_CSI_2_RX_B/s_axi_lite_aclk] [get_bd_pins MIPI_CSI_2_RX_C/s_axi_lite_aclk] [get_bd_pins MIPI_CSI_2_RX_D/s_axi_lite_aclk] [get_bd_pins MIPI_D_PHY_RX_A/s_axi_lite_aclk] [get_bd_pins MIPI_D_PHY_RX_B/s_axi_lite_aclk] [get_bd_pins MIPI_D_PHY_RX_C/s_axi_lite_aclk] [get_bd_pins MIPI_D_PHY_RX_D/s_axi_lite_aclk] [get_bd_pins axi_cama_bta/s_axi_aclk] [get_bd_pins axi_cama_gpio/s_axi_aclk] [get_bd_pins axi_vdma_a/s_axi_lite_aclk] [get_bd_pins axi_vdma_b/s_axi_lite_aclk] [get_bd_pins axi_vdma_c/s_axi_lite_aclk] [get_bd_pins axi_vdma_d/s_axi_lite_aclk] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/M03_ACLK] [get_bd_pins ps7_0_axi_periph/M04_ACLK] [get_bd_pins ps7_0_axi_periph/M05_ACLK] [get_bd_pins ps7_0_axi_periph/M07_ACLK] [get_bd_pins ps7_0_axi_periph/M08_ACLK] [get_bd_pins ps7_0_axi_periph/M09_ACLK] [get_bd_pins ps7_0_axi_periph/M10_ACLK] [get_bd_pins ps7_0_axi_periph/M11_ACLK] [get_bd_pins ps7_0_axi_periph/M12_ACLK] [get_bd_pins ps7_0_axi_periph/M13_ACLK] [get_bd_pins ps7_0_axi_periph/M14_ACLK] [get_bd_pins ps7_0_axi_periph/M15_ACLK] [get_bd_pins ps7_0_axi_periph/M19_ACLK] [get_bd_pins ps7_0_axi_periph/M20_ACLK] [get_bd_pins ps7_0_axi_periph/M21_ACLK] [get_bd_pins ps7_0_axi_periph/M22_ACLK] [get_bd_pins ps7_0_axi_periph/M23_ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins rst_clk_wiz_0_50M/slowest_sync_clk] [get_bd_pins video_dynclk/s_axi_aclk] [get_bd_pins vtg/s_axi_aclk]
  connect_bd_net -net v_axi4s_vid_out_0_vtg_ce [get_bd_pins v_axi4s_vid_out_0/vtg_ce] [get_bd_pins vtg/gen_clken]
  connect_bd_net -net v_tc_0_irq [get_bd_pins vtg/irq] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins axi_vdma_a/mm2s_frame_ptr_in] [get_bd_pins xlconcat_1/dout]

  # Create address segments
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_vdma_a/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_vdma_a/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_vdma_b/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_vdma_c/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_vdma_d/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x00010000 -offset 0x43C40000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs AXI_GammaCorrection_A/AXI_Lite_Reg_Intf/Reg] SEG_AXI_GammaCorrection_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C50000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs AXI_GammaCorrection_B/AXI_Lite_Reg_Intf/Reg] SEG_AXI_GammaCorrection_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C60000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs AXI_GammaCorrection_D/AXI_Lite_Reg_Intf/Reg] SEG_AXI_GammaCorrection_2_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C70000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs AXI_GammaCorrection_C/AXI_Lite_Reg_Intf/Reg] SEG_AXI_GammaCorrection_3_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C30000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs MIPI_CSI_2_RX_A/S_AXI_LITE/S_AXI_LITE_reg] SEG_MIPI_CSI_2_RX_0_S_AXI_LITE_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43D80000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs MIPI_CSI_2_RX_B/S_AXI_LITE/S_AXI_LITE_reg] SEG_MIPI_CSI_2_RX_1_S_AXI_LITE_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43D90000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs MIPI_CSI_2_RX_C/S_AXI_LITE/S_AXI_LITE_reg] SEG_MIPI_CSI_2_RX_2_S_AXI_LITE_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43DA0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs MIPI_CSI_2_RX_D/S_AXI_LITE/S_AXI_LITE_reg] SEG_MIPI_CSI_2_RX_3_S_AXI_LITE_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs MIPI_D_PHY_RX_A/S_AXI_LITE/S_AXI_LITE_reg] SEG_MIPI_D_PHY_RX_0_S_AXI_LITE_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43DB0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs MIPI_D_PHY_RX_B/S_AXI_LITE/S_AXI_LITE_reg] SEG_MIPI_D_PHY_RX_1_S_AXI_LITE_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43DC0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs MIPI_D_PHY_RX_C/S_AXI_LITE/S_AXI_LITE_reg] SEG_MIPI_D_PHY_RX_2_S_AXI_LITE_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43DD0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs MIPI_D_PHY_RX_D/S_AXI_LITE/S_AXI_LITE_reg] SEG_MIPI_D_PHY_RX_3_S_AXI_LITE_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41210000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_cama_bta/S_AXI/Reg] SEG_axi_cama_bta_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_cama_gpio/S_AXI/Reg] SEG_axi_cama_gpio_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_vdma_a/S_AXI_LITE/Reg] SEG_axi_vdma_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43010000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_vdma_c/S_AXI_LITE/Reg] SEG_axi_vdma_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43020000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_vdma_b/S_AXI_LITE/Reg] SEG_axi_vdma_2_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43030000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_vdma_d/S_AXI_LITE/Reg] SEG_axi_vdma_3_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs video_dynclk/s_axi_lite/Reg] SEG_video_dynclk_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C80000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs video_scaler_a/s_axi_ctrl/Reg] SEG_video_scaler_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C90000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs video_scaler_b/s_axi_ctrl/Reg] SEG_video_scaler_b_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43CB0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs video_scaler_c/s_axi_ctrl/Reg] SEG_video_scaler_c_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43CA0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs video_scaler_d/s_axi_ctrl/Reg] SEG_video_scaler_d_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs vtg/ctrl/Reg] SEG_vtg_Reg


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


