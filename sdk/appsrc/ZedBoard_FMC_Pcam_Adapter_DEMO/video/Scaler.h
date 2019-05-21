/*
 * Scaler2.h
 *
 *  Created on: Dec 12, 2018
 *      Author: ROGyorgE
 */

#ifndef SRC_CAM_SCALER_H_
#define SRC_CAM_SCALER_H_

#include "xvideo_scaler.h"

class Scaler
{
public:
	Scaler(uint16_t dev_id) :
		drv_inst_()  // Must initialize with 0, otherwise driver craps itself
	{
		XVideo_scaler_Config * ConfigPtr = XVideo_scaler_LookupConfig(dev_id);
		if(ConfigPtr == NULL)
		{
			throw std::runtime_error(__FILE__ ":" LINE_STRING);
		}
		XStatus status = XVideo_scaler_CfgInitialize(&drv_inst_,
										  ConfigPtr);

		if(status != XST_SUCCESS)
		{
			throw std::runtime_error(__FILE__ ":" LINE_STRING);
		}
	}

	void setStreams(u32 WidthIn, u32 HeightIn, u32 WidthOut, u32 HeightOut)
	{
		{
			XVideo_scaler_Set_in_width(&drv_inst_, WidthIn);
			XVideo_scaler_Set_in_height(&drv_inst_, HeightIn);
		}
		{
			XVideo_scaler_Set_out_width(&drv_inst_, WidthOut);
			XVideo_scaler_Set_out_height(&drv_inst_, HeightOut);		}
	}
	void enable()
	{
		XVideo_scaler_EnableAutoRestart(&drv_inst_);
		XVideo_scaler_Start(&drv_inst_);
	}
	~Scaler() = default;
private:
	XVideo_scaler drv_inst_;
};



#endif /* SRC_CAM_SCALER_H_ */
