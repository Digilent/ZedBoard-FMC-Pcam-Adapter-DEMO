ZedBoard FMC Pcam Adapter DEMO
------------------------------

Description
------------

This project demonstrates the usage of the FMC Pcam Adapter as an interface from one to four different Pcam cameras and the ZedBoard platform.
The Video Stream from each different camera is getting in through the MIPI/FMC connectors and out through the carrier VGA port. For errors and feed-back messages, an uart interface is present.

First and foremost
------------------

* The Vivado projects are version-specific. Source files are not backward compatible and not automatically forward compatible. Release tags specify the targetted Vivado version. There is only one version targetted per year, as chosen by Digilent. Non-tagged commits on the master branch are either at the last tagged version or the next targeted version. This is not ideal and might be changed in the future adopting a better flow.
* Our projects use submodules to bring in libraries. Use --recursive when cloning or git submodule init, if cloned already non-recursively.

Hardware Requirements
---------------------

* ZedBoard
* FMC Pcam Adapter
* From one to four different Pcam 5C cameras
* Monitor with VGA input 

Software Requirements
---------------------

* Vivado 2018.2 Installation with Xilinx SDK: To set up Vivado, see the Installing Vivado and Digilent Board Files Tutorial.

Demo Setup
----------

1. Download the most recent release ZIP archive ("FMC-Pcam-Adapter-2018.2-*.zip") from the repo's [releases page](https://github.com/Digilent/ZedBoard-FMC-Pcam-Adapter-DEMO/releases).
2. Extract the downloaded ZIP.
3. Open the XPR project file, found at \<archive extracted location\>/vivado_proj/ZedBoard-FMC-Pcam-Adapter-DEMO.xpr, included in the extracted release archive in Vivado 2018.2.
4. In the **Project Manager** window click **Generate Bitsream** and then click **OK**. Now wait for the bitstream to be created. This could take a while, depending on the performance of your computer. When the generation of the bitstream is completed a popup windows should appear. Click **Cancel** in the window.
5. In the toolbar at the top of the Vivado window, select **File -> Export -> Export Hardware**. Select **\<Local to Project\>** as the Exported Location and make sure that the **Include bitstream** box is checked, then click **OK**.
6. In the toolbar at the top of the Vivado window, select **File -> Launch SDK**. Select **\<Local to Project\>** as both the workspace location and exported location, then click **OK**.
7. With Vivado SDK opened, wait for the hardware platform exported by Vivado to be imported.
8. In the toolbar at the top of the SDK window, select **File -> New -> Application Project**.
9. Fill out the fields in the first page of the New Application Project Wizard as in the table below. Most of the listed values will be the wizard's defaults, but are included in the table for completeness.

| Setting                                 | Value                                              |
| --------------------------------------- | -------------------------------------------------- |
| Project Name                            | ZedBoard_FMC_Pcam_Adapter_DEMO                     |
| Use default location                    | Checked box                                        |
| OS Platform                             | standalone                                         |
| Target Hardware: Hardware Platform      | system_wrapper_hw_platform_0                       |
| Target Hardware: Processor              | (default)                                          |
| Target Software: Language               | C++                                                |
| Target Software: Board Support Package  | Create New (ZedBoard_FMC_Pcam_Adapter_DEMO_bsp)    |

10. Click **Next**.
11. From the list of template applications, select "Empty Application", then click **Finish**.
12. In the Project Explorer panel to the left of the SDK window, expand the new application project (named "ZedBoard_FMC_Pcam_Adapter_DEMO").
13. Right click on the "src" subdirectory of the application project and select **Import**.
14. In the "Select an import wizard" pane of the window that pops up, expand **General** and select **File System**. Then click **Next**.
15. Fill out the fields of the "File system" screen as in the table below. Most of the listed values will be the defaults, but are included in the table for completeness.

| Setting                                                | Value                                                                     |
| -                                                      | -                                                                         |
| From directory                                         | \<archive extracted location\>/sdk_appsrc/ZedBoard_FMC_Pcam_Adapter_DEMO  |
| Files to import pane: ZedBoard_FMC_Pcam_Adapter_DEMO   | Checked box                                                               |
| Into folder                                            | ZedBoard_FMC_Pcam_Adapter_DEMO/src                                        |
| Options: Overwrite existing resources without warning  | Checked box                                                               |
| Options: Create top-level folder                       | Unchecked box                                                             |

16. Click **Finish**.

**Note**: Users have reported some custom IP drivers missing from the hardware platform. Check the system_wrapper_hw_platform_0 project's drivers folder to ensure that the <code>MIPI_CSI_2_RX_v1_0</code>, <code>MIPI_D_PHY_RX_v1_0</code>, and <code>video_scaler_v1_0</code> drivers are present. If any of them are missing, they must be manually added to the workspace's software repositories. Click **Xilinx -> Repositories** in the menu bar at the top of the SDK window. For each missing driver, add a **New** local repository to the workspace, selecting "\<archive extracted location\>/vivado_proj/\<project name\>.ipdefs/vivado-library/ip/\<missing IP name\>/driver" as the repository directory. For more information, see [this thread](https://forums.xilinx.com/t5/Embedded-Development-Tools/Custom-IP-driver-not-present-on-BSP/td-p/902331) on the Xilinx Forums.

17. Right click on **Project Explorer->ZedBoard_FMC_Pcam_Adapter_DEMO_bsp** and click on **Board Support Package Settings**. There you should select drivers and make sure that the components lsited below have the needed drivers selected:

| Component                               | Component Type                  | Driver                 |
| --------------------------------------- | --------------------------------|----------------------- |
| MIPI_CSI_RX_A                           | MIPI_CSI_2_RX                   | MIPI_CSI_2_RX          |
| MIPI_CSI_RX_B                           | MIPI_CSI_2_RX                   | MIPI_CSI_2_RX          |
| MIPI_CSI_RX_C                           | MIPI_CSI_2_RX                   | MIPI_CSI_2_RX          |
| MIPI_CSI_RX_D                           | MIPI_CSI_2_RX                   | MIPI_CSI_2_RX          |
| MIPI_D_PHY_RX_A                         | MIPI_D_PHY_RX                   | MIPI_D_PHY_RX          |
| MIPI_D_PHY_RX_B                         | MIPI_D_PHY_RX                   | MIPI_D_PHY_RX          |
| MIPI_D_PHY_RX_C                         | MIPI_D_PHY_RX                   | MIPI_D_PHY_RX          |
| MIPI_D_PHY_RX_D                         | MIPI_D_PHY_RX                   | MIPI_D_PHY_RX          |
| video_scaler_a                          | video_scaler                    | video_scaler           |
| video_scaler_b                          | video_scaler                    | video_scaler           |
| video_scaler_c                          | video_scaler                    | video_scaler           |
| video_scaler_d                          | video_scaler                    | video_scaler           |

18. Right click on **Project Explorer -> ZedBoard_FMC_Pcam_Adapter_DEMO** and click on **Properties**. There, you should select **C/C++ General -> Paths and Symbols**. Click on **Includes->Add** and write "/${ProjName}/src", select the **Is a workspace path** box, then click **OK**. After that, click **Apply** and wait for the program to build. 
19. Open a serial terminal application (such as TeraTerm) and connect it to the ZedBoard serial port, using a baud rate of 115200.
20. In the toolbar at the top of the SDK window, select **Xilinx -> Program FPGA**. Leave all fields as their defaults and click "Program".
21. In the Project Explorer pane, right click on the "ZedBoard_FMC_Pcam_Adapter_DEMO" application project and select "Run As -> Launch on Hardware (System Debugger)".
22. The application will now be running on the ZedBoard. If there are any unconnected cameras, the serial interface should print a message which signals the improper initialization. 
23. If needed, create a first-stage bootloader (FSBL) using **File -> New -> Application Project** and choosing template **Zynq FSBL**.


Next Steps
----------
This demo can be used as a basis for other projects by modifying the hardware platform in the Vivado project's block design or by modifying the SDK application project.
Check out the wiki page of the demo [here](https://reference.digilentinc.com/learn/programmable-logic/tutorials/zedboard-fmc-pcam-adapter-demo/start#download_and_launch_the_zedboard_fmc-pcam-adapter_demo).

For technical support or questions, please post on the [Digilent Forum](https://forum.digilentinc.com/).

Additional Notes
----------------
For more information on how this project is version controlled, refer to the [digilent-vivado-scripts repo](https://github.com/digilent/digilent-vivado-scripts).

