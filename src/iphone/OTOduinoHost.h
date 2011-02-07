//
//  OTOduinoPinModeTypeHost.h
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/25.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTOduinoSocket.h"
#import "ArduinoModel.h"

typedef enum OTOduinoConnectionStat {	
	HeadsetIsNotAvailable = 0,
	InSufficientVolume    = 1,
	SoftwarePLLUnLock     = 2,
	NoError = 10
}OTOduinoConnectionErrorType;

@interface OTOduinoHost : NSObject<OTOduinoHostDelegate> {
	OTOduinoSocket *socket_;
	ArduinoModel *client_;	

	BOOL shouldCheckAnalogEnabled_[kNumOfAnalogPins];
//	BOOL shouldCheckDigitalEnabled_[kNumOfDigitalPins];
	BOOL shouldCheckPinMode_[kNumOfDigitalPins];

	int digitalValue_;	
	OTOduinoConnectionErrorType connectionStat_;
	
	BOOL mute_;
}

@property (nonatomic, readonly) OTOduinoSocket *socket;
@property (nonatomic, readonly) ArduinoModel *model;
@property (nonatomic, getter=getMute, setter=setMute:) BOOL mute;

// connection status flags
@property (nonatomic) OTOduinoConnectionErrorType connectionStat;

-(void)setAnalogPinEnabled:(Byte)pin enabled:(BOOL)enabled;
//-(void)setDigitalPortEnabled:(Byte)port enabled:(BOOL)enabled;
-(void)setDigitalPinMode:(Byte)pin pinMode:(OTOduinoPinModeType)pinMode;
-(void)setDigitalPinValue:(Byte)pin value:(int)value;

@end
