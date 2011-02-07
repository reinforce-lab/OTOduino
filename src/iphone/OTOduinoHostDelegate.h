//
//  OTOduinoHostDelegate.h
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/23.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import "OTOduinoTypes.h"

// OTOduinoPinModeType socket delegate protocol
@protocol OTOduinoHostDelegate 
@optional
// Lower layer sends bufferEmptyCallback message to the upper layer when it completes sending all byte data.
- (void)sendBufferEmptyNotify;

//receiving pin/port value
- (void)receiveAnalogPinValue:(Byte)pin value:(int)value;
- (void)receiveDigitalPortValue:(Byte)port value:(int)value;
//receiving pin/port status
-(void)receiveAnalogPinEnabled:(Byte)pin  enabled:(BOOL)enabled;
-(void)receiveDigitalPinMode:(Byte)pin   pinMode:(OTOduinoPinModeType)pinMode;
//client status
-(void)receiveClientInitializedMessage;
@end
