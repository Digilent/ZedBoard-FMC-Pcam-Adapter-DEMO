/*
 * GPIOClient.h
 *
 *  Created on: Jun 7, 2016
 *      Author: Elod
 */

#ifndef GPIOCLIENT_H_
#define GPIOCLIENT_H_
#include "xstatus.h"

namespace digilent {

class GPIO_Client {
public:
	using Bits = enum {CAM_GPIO0, FMC_PRSNT_L};
	virtual void setBit(Bits) = 0;
	virtual void clearBit(Bits) = 0;
	virtual uint8_t getBit(Bits) = 0;
	virtual void commit() = 0;
	virtual ~GPIO_Client() = default;
};

} /* namespace digilent */

#endif /* GPIOCLIENT_H_ */
