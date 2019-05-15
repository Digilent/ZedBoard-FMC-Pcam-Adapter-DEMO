/*
 * Nop_GPIO.h
 *
 *  Created on: Apr 18, 2019
 *      Author: ROGyorgE
 */

#ifndef SRC_CAM_NOP_GPIO_H_
#define SRC_CAM_NOP_GPIO_H_

#include "GPIO_Client.h"

namespace digilent {

/**
 * The purpose of this class is to ignore GPIO control requests by the caller.
 * For example denying power control to the OV5640 class.
 */
class Nop_GPIO : public GPIO_Client
{
	virtual void setBit(Bits) {}
	virtual void clearBit(Bits) {}
	virtual uint8_t getBit(Bits) { return 0; }
	virtual void commit() {}
};

};

#endif /* SRC_CAM_NOP_GPIO_H_ */
