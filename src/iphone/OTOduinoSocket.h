//
//  OTOduinoPinModeTypeSocket.h
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/23.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWMSocket.h"
#import "FSKModem.h"
#import "AudioPHY.h"

#import "OTOduinoTypes.h"
#import "OTOduinoHostDelegate.h"

#define kBufferSize 127

@interface OTOduinoSocket : NSObject<SWMSocket> {
	FSKModem *modem_;
	AudioPHY *audioPHY_;
	NSObject<OTOduinoHostDelegate> *delegate_;	
	Byte buf_[kBufferSize];
}
@property (nonatomic, readonly) FSKModem *modem;
@property (nonatomic, readonly) AudioPHY *audioPHY;

-(id)initWithDelegate:(NSObject<OTOduinoHostDelegate> *)delegate;

// configurate pin/port
-(BOOL)enableAnalogPin:(Byte)pin enabled:(BOOL)enabled;
//-(BOOL)enableDigitalPort:(Byte)port enabled:(BOOL)enabled;
-(BOOL)setDigitalPinMode:(Byte)pin pinMode:(OTOduinoPinModeType)pinMode;

// request pin/port value
-(BOOL)setDigitalOutput:(Byte)port value:(int)value;

// pin status readback 
-(BOOL)requestAnalogPinEnabled:(Byte)pin;
//-(BOOL)requestDigitalPortEnabled:(Byte)port;
-(BOOL)requestDigitalPinMode:(Byte)pin;

// client status commands
-(BOOL)confirmedClientInitialization;
//-(BOOL)requestVersionReport;
// TODO I2C, sampling interval, Servos
@end
