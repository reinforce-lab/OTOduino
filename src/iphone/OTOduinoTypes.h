/*
 *  OTOduinoTypes.h
 *
 *  Created by UEHARA AKIHIRO on 10/12/23.
 *  Copyright 2010 REINFORCE Lab. All rights reserved.
 *
 */

/// OTOduinoPinModeType 2.1 protocol header
/// Details of the protocol is desribed in : http://firmata.org/wiki/Protocol 
#ifndef _OTODUINO_TYPES_H_
#define _OTODUINO_TYPES_H_

// Protocol version which this library supports
#define kOTOduinoPinModeTypeProtocolVersion 2.1

// OTOduinoPinModeType command type
typedef enum OTOduinoCommand {
	//** Analog pin commands **
	// client reports analog pin value 
	analogIOMessage = 0x11, //(analogIOMessage, pin#, lsb<7:0>, msb<15:8>)
							// host sets an analog pin enable/disable
	setAnalogPinEnabled   = 0x12, // <setAnalogPiEnabled, pin#, disable/enable(0/1)>
								  // host requests the client to report analog pin enable/disable flag
	requestAnalogPinEnabled   = 0x13, // <requestAnalogPinEnabled, pin#>
									  // client rports its analog pin enable/disable flag
	analogPinEnabledMessage   = 0x14, // <analogPinEnabledMessage,   pin#,   enable(1)/disable(0)>  
	
	//** Digital pin commands **
	// client reports digital port value 
	digitalIOMessage   = 0x21, //<digitalIOMessage, port#, lsb<7:0>, msb<15:8>>
	setDigitalPinMode  = 0x22, //<setDigitalPinMode, pin#, pinmode>
	requestDigitalPinMode = 0x23, //<requestDigitalPinMode, pin#>
	digitalPinModeMessage = 0x24, //<digitalPinModeMessage, pin#, pinmode>
	
	//** Board status commands **
	clientInitMessage          = 0x31, // <clientInitMessage>
	clientInitConfirmedMessage = 0x32, // <clientInitConfirmedMessage>
									   // firmware version and name
									   // 
} OTOduinoCommandType;

// Pin mode type
typedef enum OTOduinoPinModeType {
	Disabled = 0,
	Input  = 1,
	Output = 2,
	Analog = 3,
	PWM    = 4,
	Servo  = 5
} OTOduinoPinModeType;

#endif
