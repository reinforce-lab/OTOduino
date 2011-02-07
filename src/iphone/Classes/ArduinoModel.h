//
//  ClientState.h
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/25.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTOduinoTypes.h"
#import "AnalogPinModel.h"
#import "digitalPinModel.h"

#define kNumOfAnalogPins  6
#define kNumOfDigitalPins 14

#define kModemAnalogPinNum  0
#define kModemDigitalPinNum 13

/// Remote client status
@interface ArduinoModel : NSObject {
 @private
	NSArray *analogPinModes_;
	NSArray *digitalPinModes_;
}
@property (nonatomic, readonly) NSArray *analogPinModels;
@property (nonatomic, readonly) NSArray *digitalPinModels;

-(bool)isReservedModemDigitalPin:(int)pinnum;
-(bool)isReservedModemAnalogPin:(int) pinnum;
@end
