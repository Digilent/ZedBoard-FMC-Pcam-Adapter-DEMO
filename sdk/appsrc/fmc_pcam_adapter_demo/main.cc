/*
 * main2.cc
 *
 *  Created on: Apr 12, 2019
 *      Author: ROGyorgE
 */

#include <exception>
#include <memory>

#include "platform/platform.h"
#include "verbose/verbose.h"
#include "intc/ScuGicInterruptController.h"
#include "cam/PS_GPIO.h"
#include "cam/Nop_GPIO.h"
#include "cam/PS_IIC.h"
#include "cam/TCA9546.h"
#include "cam/OV5640.h"
#include "video/VideoOutput.h"
#include "video/AXI_VDMA.h"
#include "video/Scaler.h"
#include "MIPI_D_PHY_RX.h"
#include "MIPI_CSI_2_RX.h"

/* Hardware profile */
#define IRPT_CTL_DEVID 			XPAR_PS7_SCUGIC_0_DEVICE_ID
#define VDMA_A_DEVID			XPAR_AXI_VDMA_A_DEVICE_ID
#define VDMA_A_MM2S_IRPT_ID		XPAR_FABRIC_AXI_VDMA_A_MM2S_INTROUT_INTR
#define VDMA_A_S2MM_IRPT_ID		XPAR_FABRIC_AXI_VDMA_A_S2MM_INTROUT_INTR
#define SCALER_A_DEVID			XPAR_VIDEO_SCALER_A_DEVICE_ID
#define GPIO_DEVID				XPAR_PS7_GPIO_0_DEVICE_ID
#define GPIO_IRPT_ID			XPAR_PS7_GPIO_0_INTR
#define CAM_I2C_DEVID			XPAR_PS7_I2C_0_DEVICE_ID
#define CAM_I2C_IRPT_ID			XPAR_PS7_I2C_0_INTR

#define VTC_DEVID				XPAR_VTC_0_DEVICE_ID
#define DYN_PIXCLK_DEVID		XPAR_VIDEO_DYNCLK_DEVICE_ID

#define VDMA_B_DEVID			XPAR_AXI_VDMA_B_DEVICE_ID
#define VDMA_B_S2MM_IRPT_ID		XPAR_FABRIC_AXI_VDMA_B_S2MM_INTROUT_INTR
#define SCALER_B_DEVID			XPAR_VIDEO_SCALER_B_DEVICE_ID

#define VDMA_C_DEVID			XPAR_AXI_VDMA_C_DEVICE_ID
#define VDMA_C_S2MM_IRPT_ID		XPAR_FABRIC_AXI_VDMA_C_S2MM_INTROUT_INTR
#define SCALER_C_DEVID			XPAR_VIDEO_SCALER_C_DEVICE_ID

#define VDMA_D_DEVID			XPAR_AXI_VDMA_D_DEVICE_ID
#define VDMA_D_S2MM_IRPT_ID		XPAR_FABRIC_AXI_VDMA_D_S2MM_INTROUT_INTR
#define SCALER_D_DEVID			XPAR_VIDEO_SCALER_D_DEVICE_ID

/* *************** */
uintptr_t constexpr frame_baseaddr 	= 0x0A000000U; //Must make sure linker reserves the region above this
uintptr_t const portb_offset 		= 1920/2*3;
uintptr_t const portc_offset 		= 1920*1080/2*3;
uintptr_t const portd_offset 		= (1920*1080/2+1920/2)*3;
/* *************** */

using namespace digilent;


static void input_pipeline_mode_change(AXI_VDMA<ScuGicInterruptController>& vdma_driver, OV5640& cam, Scaler& scaler, Resolution HW_ScaledCaptureRes, Resolution VideoOutputRes, OV5640_cfg::mode_t mode, uintptr_t dphy_baseaddr, uintptr_t csi2_baseaddr, uintptr_t gamma_baseaddr );
static void output_pipeline_mode_change(AXI_VDMA<ScuGicInterruptController>& vdma_driver, VideoOutput& vid, Resolution VideoOutputRes,u8 master_select);



int main()
{
	//Init CPU, UART, caches etc.
	init_platform();

#ifdef _DEBUG
	SET_VERBOSE_FLAG();
#endif

	VERBOSE("Initializing...");
	try
	{//Constructor of hardware driver classes might throw
		u8 read_master_select;
		//Blank VDMA frame buffers
		memset((u8*)frame_baseaddr, 0x55, (1920*1080*3)*4);
		//Flush D-Cache because this is DMA-accessible memory
		Xil_DCacheFlushRange(frame_baseaddr, (1920*1080*3)*4);

		ScuGicInterruptController irpt_ctl(IRPT_CTL_DEVID);
		//Construct camera control IPs
		PS_GPIO<ScuGicInterruptController> gpio_driver(GPIO_DEVID, irpt_ctl, GPIO_IRPT_ID);
		Nop_GPIO nopgpio;
		PS_IIC<ScuGicInterruptController> iic_driver(CAM_I2C_DEVID, irpt_ctl, CAM_I2C_IRPT_ID, 100000);
		//Dual-channel VDMA for the display and the first camera
		AXI_VDMA<ScuGicInterruptController> vdma_a_driver(VDMA_A_DEVID, frame_baseaddr, irpt_ctl,
							VDMA_A_MM2S_IRPT_ID,
							VDMA_A_S2MM_IRPT_ID);
		//Output pipeline drivers
		VideoOutput vid(VTC_DEVID, DYN_PIXCLK_DEVID);

		//Input pipeline drivers
		Scaler scaler_a(SCALER_A_DEVID);
		std::unique_ptr<TCA9546> muxch_a_ptr;
		std::unique_ptr<OV5640> cam_a_ptr;

		//Initialize input pipelines, depending on how many D-PHY IPs are in hardware
#if XPAR_MIPI_D_PHY_RX_NUM_INSTANCES >= 2
		AXI_VDMA<ScuGicInterruptController> vdma_b_driver(VDMA_B_DEVID, frame_baseaddr+portb_offset, irpt_ctl,
					0,
					VDMA_B_S2MM_IRPT_ID);
		Scaler scaler_b(SCALER_B_DEVID);
		std::unique_ptr<TCA9546> muxch_b_ptr;
		std::unique_ptr<OV5640> cam_b_ptr;
#endif
#if XPAR_MIPI_D_PHY_RX_NUM_INSTANCES >= 3
		AXI_VDMA<ScuGicInterruptController> vdma_c_driver(VDMA_C_DEVID, frame_baseaddr+portc_offset, irpt_ctl,
					0,
					VDMA_C_S2MM_IRPT_ID);
		Scaler scaler_c(SCALER_C_DEVID);
		std::unique_ptr<TCA9546> muxch_c_ptr;
		std::unique_ptr<OV5640> cam_c_ptr;
#endif
#if XPAR_MIPI_D_PHY_RX_NUM_INSTANCES >= 4
		AXI_VDMA<ScuGicInterruptController> vdma_d_driver(VDMA_D_DEVID, frame_baseaddr+portd_offset, irpt_ctl,
					0,
					VDMA_D_S2MM_IRPT_ID);
		Scaler scaler_d(SCALER_D_DEVID);
		std::unique_ptr<TCA9546> muxch_d_ptr;
		std::unique_ptr<OV5640> cam_d_ptr;
#endif

		//Init of system board finished
		VERBOSE("FMC Pcam Adapter Rev.demo \r\n");
		gpio_driver.clearBit(gpio_driver.Bits::CAM_GPIO0);
		::usleep(1000000);
		gpio_driver.setBit(gpio_driver.Bits::CAM_GPIO0);
		::usleep(1000000);

		//Constructing OV5640 objects in dynamic storage vs. automatic makes
		//ignoring cameras with init exceptions possible
		//Since the power enable signals is shared between all FMC Pcam Adapter ports,
		//cam_a will be the only one controlling it through the gpio_driver.
		try
		{
			muxch_a_ptr = std::make_unique<TCA9546>(iic_driver, 0, 1 << 0);
			cam_a_ptr = std::make_unique<OV5640>(*muxch_a_ptr, nopgpio);
		} catch (std::runtime_error const& e)
		{
			VERBOSE("Camera on port A did not initialize correctly: %s", e.what());
		}

		//All other cams will get a dummy GPIO driver, thereby not being able
		//to control power at all. This avoids power cycling and losing inits
		//of all cams whenever an OV5640 instance is constructed.
		try
		{
			muxch_b_ptr = std::make_unique<TCA9546>(iic_driver, 0, 1 << 1);
			cam_b_ptr = std::make_unique<OV5640>(*muxch_b_ptr, nopgpio);
		} catch (std::runtime_error const& e)
		{
			VERBOSE("Camera on port B did not initialize correctly: %s", e.what());
		}
		try
		{
			muxch_c_ptr = std::make_unique<TCA9546>(iic_driver, 0, 1 << 2);
			cam_c_ptr = std::make_unique<OV5640>(*muxch_c_ptr, nopgpio);
		} catch (std::runtime_error const& e)
		{
			VERBOSE("Camera on port C did not initialize correctly: %s", e.what());
		}
		try
		{
			muxch_d_ptr = std::make_unique<TCA9546>(iic_driver, 0, 1 << 3);
			cam_d_ptr = std::make_unique<OV5640>(*muxch_d_ptr, nopgpio);
		} catch (std::runtime_error const& e)
		{
			VERBOSE("Camera on port D did not initialize correctly: %s", e.what());
		}

		if(cam_a_ptr){
			try{


		     	input_pipeline_mode_change(vdma_a_driver, *cam_a_ptr, scaler_a, Resolution::R960_540_60_PP, Resolution::R1920_1080_60_PP, OV5640_cfg::mode_t::MODE_1080P_1920_1080_30fps_336M_MIPI, XPAR_MIPI_D_PHY_RX_A_S_AXI_LITE_BASEADDR, XPAR_MIPI_CSI_2_RX_A_S_AXI_LITE_BASEADDR, XPAR_AXI_GAMMACORRECTION_A_BASEADDR);

			}
			catch(std::exception const& e){
				VERBOSE("An exception occurred in Input pipeline for cam_a: %s", e.what());

			}
		}
		 if(cam_b_ptr){
			try{
		    input_pipeline_mode_change(vdma_b_driver, *cam_b_ptr, scaler_b, Resolution::R960_540_60_PP, Resolution::R1920_1080_60_PP, OV5640_cfg::mode_t::MODE_1080P_1920_1080_30fps_336M_MIPI, XPAR_MIPI_D_PHY_RX_B_S_AXI_LITE_BASEADDR, XPAR_MIPI_CSI_2_RX_B_S_AXI_LITE_BASEADDR, XPAR_AXI_GAMMACORRECTION_B_BASEADDR);
			}
			catch(std::exception const& e){
				VERBOSE("An exception occurred in Input pipeline for cam_b: %s", e.what());
			}
		}
		 if(cam_c_ptr){
			try{
				input_pipeline_mode_change(vdma_c_driver, *cam_c_ptr, scaler_c, Resolution::R960_540_60_PP, Resolution::R1920_1080_60_PP, OV5640_cfg::mode_t::MODE_1080P_1920_1080_30fps_336M_MIPI, XPAR_MIPI_D_PHY_RX_C_S_AXI_LITE_BASEADDR, XPAR_MIPI_CSI_2_RX_C_S_AXI_LITE_BASEADDR, XPAR_AXI_GAMMACORRECTION_C_BASEADDR);

			}
			catch(std::exception const& e){
				VERBOSE("An exception occurred in Input pipeline for cam_c: %s", e.what());
			}
		}
		 if(cam_d_ptr){
			try{
				input_pipeline_mode_change(vdma_d_driver, *cam_d_ptr, scaler_d, Resolution::R960_540_60_PP, Resolution::R1920_1080_60_PP, OV5640_cfg::mode_t::MODE_1080P_1920_1080_30fps_336M_MIPI, XPAR_MIPI_D_PHY_RX_D_S_AXI_LITE_BASEADDR, XPAR_MIPI_CSI_2_RX_D_S_AXI_LITE_BASEADDR, XPAR_AXI_GAMMACORRECTION_D_BASEADDR);

			}
			catch(std::exception const& e){
				VERBOSE("An exception occurred in Input pipeline for cam_d: %s", e.what());
			}
		}

		if(cam_a_ptr){
				read_master_select  = 0x00;
		}
			else if(cam_b_ptr){
				read_master_select  = 0x01;
		}
			else if(cam_c_ptr){
				read_master_select  = 0x02;
		}
			else if(cam_d_ptr){
				read_master_select  = 0x03;
		}

		output_pipeline_mode_change(vdma_a_driver, vid, Resolution::R1920_1080_60_PP,read_master_select);

	}



	catch (std::exception const& e)
	{
		//Exceptions caught here are from hardware inits that are not expected to fail
		//For example FPGA-internal drivers reporting errors during init
		VERBOSE("Exception that could not be handled: %s", e.what());

	}
	cleanup_platform();
}

// Global function that sets the camera sensor to live image


void input_pipeline_mode_change(AXI_VDMA<ScuGicInterruptController>& vdma_driver, OV5640& cam, Scaler& scaler, Resolution HW_ScaledCaptureRes, Resolution VideoOutputRes, OV5640_cfg::mode_t mode, uintptr_t dphy_baseaddr, uintptr_t csi2_baseaddr, uintptr_t gamma_baseaddr )
{
	//Bring up input pipeline back-to-front
	{
		vdma_driver.resetWrite();
		MIPI_CSI_2_RX_mWriteReg(csi2_baseaddr, CR_OFFSET, (CR_RESET_MASK & ~CR_ENABLE_MASK));
		MIPI_D_PHY_RX_mWriteReg(dphy_baseaddr, CR_OFFSET, (CR_RESET_MASK & ~CR_ENABLE_MASK));
		//cam.reset(); //TODO cams sharing same power enable
	}

	{
		vdma_driver.configureWrite(timing[static_cast<int>(HW_ScaledCaptureRes)].h_active, timing[static_cast<int>(HW_ScaledCaptureRes)].v_active, timing[static_cast<int>(VideoOutputRes)].h_active, timing[static_cast<int>(VideoOutputRes)].v_active);
		Xil_Out32(gamma_baseaddr, 3); // Set Gamma correction factor to 1/1.8
		scaler.setStreams(1920, 1080, 960, 540);
		//TODO CSI-2, D-PHY config here
		cam.init();
	}

	{
		vdma_driver.enableWrite();
		scaler.enable();
		MIPI_CSI_2_RX_mWriteReg(csi2_baseaddr, CR_OFFSET, CR_ENABLE_MASK);
		MIPI_D_PHY_RX_mWriteReg(dphy_baseaddr, CR_OFFSET, CR_ENABLE_MASK);
		cam.set_mode(mode);
		cam.set_awb(OV5640_cfg::awb_t::AWB_ADVANCED);
	}
}

void output_pipeline_mode_change(AXI_VDMA<ScuGicInterruptController>& vdma_driver, VideoOutput& vid, Resolution VideoOutputRes, u8 master_select)
{

	//Bring up output pipeline back-to-front
	{
		vid.reset();
		vdma_driver.resetRead();
	}

	{
		vid.configure(VideoOutputRes);
		vdma_driver.configureRead(timing[static_cast<int>(VideoOutputRes)].h_active, timing[static_cast<int>(VideoOutputRes)].v_active,master_select);
	}

	{
		vid.enable();
		vdma_driver.enableRead();
	}
}



