/*
 * AXI_GPIO.h
 *
 *  Created on: Jun 7, 2016
 *      Author: Elod
 */

#ifndef PS_GPIO_H_
#define PS_GPIO_H_

#include <cam/GPIO_Client.h>
#include <stdexcept>

#include "xgpiops.h"
#include "verbose/verbose.h"

namespace digilent {

template <typename IrptCtl>
class PS_GPIO : public GPIO_Client
{
public:
	PS_GPIO(uint16_t dev_id, IrptCtl& irpt_ctl, uint16_t irpt_id) :
		drv_inst_(), irpt_ctl_(irpt_ctl)


	{

		XGpioPs_Config* config = XGpioPs_LookupConfig(dev_id);
		if (config == NULL) {
			throw std::runtime_error(__FILE__ ":" LINE_STRING);
		}

		XStatus Status;
		//Initialize the GPIO driver
		Status = XGpioPs_CfgInitialize(&drv_inst_, config, config->BaseAddr);
		if (Status != XST_SUCCESS)
		{
			throw std::runtime_error(__FILE__ ":" LINE_STRING);
		}

		if (XGpioPs_SelfTest(&drv_inst_) != XST_SUCCESS)
		{
			throw std::runtime_error(__FILE__ ":" LINE_STRING);
		}

		XGpioPs_SetOutputEnablePin(&drv_inst_, CAM_PWUP_PIN, 0);
		XGpioPs_SetDirectionPin(&drv_inst_, CAM_PWUP_PIN, 1); //Output
		XGpioPs_WritePin(&drv_inst_, CAM_PWUP_PIN, 1);
		XGpioPs_SetOutputEnablePin(&drv_inst_, CAM_PWUP_PIN, 1);
	    XGpioPs_SetDirectionPin(&drv_inst_, FMC_PRSNT_L_PIN, 0); //input
	}

	virtual uint8_t getBit(Bits bit)
	{
		switch (bit)
		{
		case Bits::CAM_GPIO0: return static_cast<uint8_t>(XGpioPs_ReadPin(&drv_inst_, CAM_PWUP_PIN)); break;
		case Bits::FMC_PRSNT_L: return static_cast<uint8_t>(XGpioPs_ReadPin(&drv_inst_, FMC_PRSNT_L_PIN)); break;
		}
		throw new std::logic_error("Bit unknown");
	}
	virtual void setBit(Bits bit)
	{
		switch (bit)
		{
		case Bits::CAM_GPIO0: XGpioPs_WritePin(&drv_inst_, CAM_PWUP_PIN, 1); break;
		case Bits::FMC_PRSNT_L: /*do nothing, input pin*/ break;
		}
	}
	virtual void clearBit(Bits bit)
	{
		switch (bit)
		{
		case Bits::CAM_GPIO0: XGpioPs_WritePin(&drv_inst_, CAM_PWUP_PIN, 0); break;
		case Bits::FMC_PRSNT_L: /*do nothing, input pin*/ break;
		}
	}
	virtual void commit()
	{

	}



private:
	XGpioPs drv_inst_;
	IrptCtl irpt_ctl_;
	u32 const CAM_PWUP_PIN = 54;
	u32 const FMC_PRSNT_L_PIN  = 55;
};

}


#endif /* PS_GPIO_H_ */
