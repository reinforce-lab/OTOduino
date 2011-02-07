//
//  ClientState.m
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/25.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import "ArduinoModel.h"

@implementation ArduinoModel
#pragma mark Properties
@synthesize analogPinModels = analogPinModels_;
@synthesize digitalPinModels =digitalPinModels_;

#pragma mark Constructor
-(id)init
{
	self = [super init];
	if(self) {
		// analog pin models
		NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:kNumOfAnalogPins];
		for(int i=0; i < kNumOfAnalogPins; i++) {
			AnalogPinModel *pin = [[[AnalogPinModel alloc] init] autorelease];
			pin.pinNumber = i;
			[array addObject:pin];
		}
		analogPinModels_ = array;
		//digital pin models
		array =[[NSMutableArray alloc] initWithCapacity:kNumOfDigitalPins];
		for(int i=0; i < kNumOfDigitalPins; i++) {
			DigitalPinModel *pin = [[[DigitalPinModel alloc] init] autorelease];
			pin.pinNumber = i;
			pin.pinMode   = Input;
			[array addObject:pin];
		}
		digitalPinModels_ = array;
	}
	return self;
}
-(void)dealloc
{
	[analogPinModels_ release];
	[digitalPinModels_ release];
	
	[super dealloc];
}
#pragma mark Public methods
-(bool)isReservedModemDigitalPin:(int) pinnum
{
	return (pinnum == 0) || (pinnum == 1) || (pinnum == kModemDigitalPinNum);
}
-(bool)isReservedModemAnalogPin:(int) pinnum
{
	return (pinnum == kModemAnalogPinNum);
}
@end
