/*
 * iicclient.h
 *
 *  Created on: May 26, 2016
 *      Author: Elod
 */

#ifndef IICCLIENT_H_
#define IICCLIENT_H_

#include <stdint.h>
#include <stdexcept>
#include <vector>
#include "xstatus.h"


namespace digilent {

/**
 * Virtual interface class of I2C master controllers
 */
class I2C_Client {
public:
	/**
	 * Exception representing an error conditions on the I2C bus
	 */
	class HardwareError : public std::runtime_error {
	public:
		using Errc = enum {slave_nack = 1, arb_lost, internal, END_OF_ENUM};
		HardwareError(Errc errc, char const* msg) : std::runtime_error(msg), errc_(errc) {}
		Errc errc() const { return errc_; }
	private:
		Errc errc_;
	};
	virtual void read(uint8_t addr, uint8_t* buf, size_t count) = 0;
	virtual void write(uint8_t addr, uint8_t const* buf, size_t count) = 0;
	virtual ~I2C_Client() = default;
};

} /* namespace digilent */

#endif /* IICCLIENT_H_ */
