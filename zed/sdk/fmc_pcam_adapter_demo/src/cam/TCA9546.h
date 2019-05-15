/*
 * TCA9546.h
 *
 *  Created on: Nov 19, 2018
 *      Author: ROGyorgE
 */

#ifndef SRC_CAM_TCA9546_H_
#define SRC_CAM_TCA9546_H_

#include "I2C_Client.h"

namespace digilent {

/**
 * Wrapper class for another I2C_Client adding the additional layer of I2C
 * multiplexer device channel. Using this wrapper abstracts mux control from
 * the I2C_Client user and handles the activation and de-activation of the
 * mux channel transparently.
 */
class TCA9546 : public I2C_Client
{
public:
	using I2C_Client::HardwareError;
	/**
	 *
	 * @param iic is the underlying I2C_Client driver to-be-wrapped
	 * @param a_pin specifies the mux hardware address pins A2-A0 on its 3 LSB
	 * @param channel_mask should have the bit(s) corresponding to the
	 * addressed channel(s) set to 1.
	 */
	TCA9546(I2C_Client& iic, uint8_t a_pin, uint8_t channel_mask) :
		iic_(iic), channel_mask_(channel_mask)
	{
		dev_address_ &= ~0x07;
		dev_address_ |=(a_pin & 0x07);
		reset();
	}

	/**
	 * @throws Exception-safety of the underlying I2C_Client::read and write
	 */
	virtual void read(uint8_t addr, uint8_t* buf, size_t count) override
	{
		enable(channel_mask_);
		iic_.read(addr, buf, count);
		disable(channel_mask_);
	}

	/**
	 * @throws Exception-safety of the underlying I2C_Client::read and write
	 */
	virtual void write(uint8_t addr, uint8_t const* buf, size_t count) override
	{
		enable(channel_mask_);
		iic_.write(addr, buf, count);
		disable(channel_mask_);
	}

	/**
	 * @throws Exception-safety of the underlying I2C_Client::read and write
	 */
	void reset()
	{
		uint8_t ctl_reg = 0;
		iic_.write(dev_address_, &ctl_reg, 1);
	}

	/**
	 * @throws Exception-safety of the underlying I2C_Client::read and write
	 */
	uint8_t get_mux()
	{
		uint8_t ctl_reg = 0;
		iic_.read(dev_address_, &ctl_reg, 1);
		return ctl_reg;
	}

	/**
	 * @throws Exception-safety of the underlying I2C_Client::read and write
	 */
	void enable(uint8_t mask)
	{
		uint8_t ctl_reg = 0;
		iic_.read(dev_address_, &ctl_reg, 1);
		ctl_reg |= mask;
		iic_.write(dev_address_, &ctl_reg, 1);
	}

	/**
	 * @throws Exception-safety of the underlying I2C_Client::read and write
	 */
	void disable(uint8_t mask)
	{
		uint8_t ctl_reg = 0;
		iic_.read(dev_address_, &ctl_reg, 1);
		ctl_reg &= (~mask);
		iic_.write(dev_address_, &ctl_reg, 1);
	}

private:
	I2C_Client& iic_;
	uint8_t dev_address_ = (0xE0 >> 1);
	uint8_t channel_mask_;
};

} //namespace digilent
#endif /* SRC_CAM_TCA9546_H_ */
