/******************************************************************************
 * @file uart.c
 *
 * This file contains the functions needed to test and initialize the Uart
 * controller.
 *
 * @authors Elod Gyorgy, Mihaita Nagy
 *
 * @date 2015-Jan-15
 *
 * @copyright
 * (c) 2015 Copyright Digilent Incorporated
 * All Rights Reserved
 *
 * This program is free software; distributed under the terms of BSD 3-clause
 * license ("Revised BSD License", "New BSD License", or "Modified BSD License")
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name(s) of the above-listed copyright holder(s) nor the names
 *    of its contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 * @desciption
 *
 * @note
 *
 * <pre>
 * MODIFICATION HISTORY:
 *
 * Ver   Who          Date        Changes
 * ----- ------------ ----------- --------------------------------------------
 * 1.00  Mihaita Nagy 2014-Sep-25 First release
 * 1.01  Mihaita Nagy 2015-Jan-15 Modified it for Atlys 2
 * 1.02  Elod Gyorgy  2015-Jun-8  Added command processing functions
 * 1.03  Elod Gyorgy  2015-Nov-19 Separated command processing from transport
 *
 * </pre>
 *
 *****************************************************************************/

/***************************** Include Files *********************************/
#include <stdarg.h>
#include "../../src/uart/uart.h"

/************************** Variable Definitions *****************************/
extern unsigned char u8Verbose;

/************************** Constant Definitions *****************************/
#define UART_DEVICE_ID	XPAR_XUARTPS_0_DEVICE_ID
#define UART_CLK_FREQ	XPAR_XUARTPS_0_UART_CLK_FREQ_HZ

/************************** Function Definitions *****************************/

/******************************************************************************
 * Initializes the UART-PS controller.
 *
 * @param	DeviceId is the controller's ID (from xparameters_ps.h)
 *
 * @return	none.
 *****************************************************************************/
XStatus UartInit(XUartPs *UartInst, u32 dwBaudRate) {

	XUartPs_Config *Config;
	XStatus Status;

	/*
	 * Initialize the UART driver so that it's ready to use.
	 * Look up the configuration in the config. table then initialize it.
	 */
	Config = XUartPs_LookupConfig(UART_DEVICE_ID);
	if(NULL == Config) {
		return XST_FAILURE;
	}

	// This will initialize to 19,200 bps, 8 data bits, 1 stop bit, no parity
	Status = XUartPs_CfgInitialize(UartInst, Config, Config->BaseAddress);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	//Reconfigure default baud rate to the requested one
	Status = XUartPs_SetBaudRate(UartInst, dwBaudRate);
	if (Status != XST_SUCCESS) {
		//XST_UART_BAUD_ERROR if baud rate cannot be synthesized with acceptable error
		return Status;
	}

	Status = XUartPs_SelfTest(UartInst);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

/*!
 * UartRcv attempts to receive the requested number of bytes in the buffer and returns
 * the actual number of bytes read. This function does not block, it will only receive
 * the bytes already in the controller FIFO. Will return zero, if not bytes are available
 * for reading.
 * @param UartInst - driver instance
 * @param rbgBuffer - pointer to caller allocated buffer
 * @param cbRequested - number of bytes to attempt to read
 * @return the number of actual bytes read
 */
u32 UartRcv(XUartPs *UartInst, char* rgbBuffer, u32 cbRequested)
{
	return XUartPs_Recv(UartInst, (u8*)rgbBuffer, cbRequested);
}

/*!
 * UartSendBlock sends some data to over Uart. Calling the functions will block until
 * all the data can be sent to the Uart controller's FIFO
 * @param UartInst - driver instance
 * @param rbgBuffer - pointer to caller allocated buffer
 * @param cbRequested - number of bytes to attempt to send
 */
void UartSendBlock(XUartPs* UartInst, char const* rgbBuffer, u32 cbRequested)
{
	u32 cbSent;
	do {
		cbSent = XUartPs_Send(UartInst, (u8*)rgbBuffer, cbRequested);
		cbRequested -= cbSent;
		rgbBuffer += cbSent;
	} while (cbRequested > 0);
}
