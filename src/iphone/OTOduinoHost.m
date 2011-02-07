//
//  OTOduinoPinModeTypeHost.m
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/25.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import "OTOduinoHost.h"

@interface OTOduinoHost(Private)
-(void)sendRequests;
-(void)setCheckFlags;
-(void)checkAudioSocketStat;
-(void)updateMute;
@end

@implementation OTOduinoHost
#pragma mark Properties
@synthesize model  = client_;
@synthesize socket = socket_;
@synthesize connectionStat = connectionStat_;
@dynamic mute;
-(BOOL)getMute
{
	return mute_;
}
-(void)setMute:(BOOL)value
{
	if(mute_ != value) {
		mute_ = value;
		[self updateMute];
	}
}
#pragma mark Constructor
-(id)init
{
	self = [super init];
	if(self) {
		socket_ =[[OTOduinoSocket alloc] initWithDelegate:self];
		client_ = [[ArduinoModel alloc] init];

		[self setCheckFlags];
		[self checkAudioSocketStat];
		// mute
		mute_ = true;
		socket_.modem.mute = true;
		// add kvo
		[socket_.audioPHY addObserver:self forKeyPath:@"outputVolume" options:NSKeyValueObservingOptionNew context:nil];
		[socket_.audioPHY addObserver:self forKeyPath:@"isHeadsetInOut" options:NSKeyValueObservingOptionNew context:nil];
		[socket_.modem addObserver:self forKeyPath:@"packetReceived" options:NSKeyValueObservingOptionNew context:nil];
	}
	return self;
}
-(void)dealloc
{
	// remove kvo
	[socket_.audioPHY removeObserver:self forKeyPath:@"outputVolume"];
	[socket_.audioPHY removeObserver:self forKeyPath:@"isHeadsetInOut"];
	[socket_.modem removeObserver:self forKeyPath:@"packetReceived"];
	
	[socket_ release];
	[client_ release];
	
	[super dealloc];
}
#pragma mark Private methods
-(void)sendRequests
{
	BOOL check = true;
	// check enabled/disabled value
	for(int i=0; i<kNumOfAnalogPins && check; i++) {		
		if(![client_ isReservedModemAnalogPin:i] && shouldCheckAnalogEnabled_[i]) {
			[socket_ requestAnalogPinEnabled:i];
			check = false;
			break;
		}
	}
	// check piMode value
	for(int i=0; i<kNumOfDigitalPins && check;i++) {
		if(![client_ isReservedModemDigitalPin:i] && shouldCheckPinMode_[i]) {
			[socket_ requestDigitalPinMode:i];
			check = false;
			 break;
		}		
	}
	// send digital values
	[socket_ setDigitalOutput:0 value:digitalValue_];
}
-(void)setCheckFlags
{
	// set shouldCheck flags
	for(int i=0; i<kNumOfAnalogPins; i++) {
		shouldCheckAnalogEnabled_[i] = true;
	}
	for(int i=0; i<kNumOfDigitalPins;i++) {
		shouldCheckPinMode_[i] = true;
	}
}
-(void)checkAudioSocketStat
{
	OTOduinoConnectionErrorType err = NoError;
	// check packet
	if( ! socket_.modem.packetReceived ) {
		err = SoftwarePLLUnLock;
	}
	// check volume
	if( socket_.audioPHY.outputVolume < 1.0 ) {
		err = InSufficientVolume;
	}
	// check headset
	if( ! socket_.audioPHY.isHeadsetInOut ) {
		err = HeadsetIsNotAvailable;
	}
	
	// set check flags
	if(err != NoError) {		
		[self setCheckFlags];
	}
	
	// update property (KVO)
	if(err != connectionStat_) {
		self.connectionStat = err;
	}

	// update mute status
	[self updateMute];
}
-(void)updateMute
{
	bool shouldMute = false;
	if(mute_) {
		shouldMute = true;
	} else {
		if(connectionStat_ == HeadsetIsNotAvailable) {
			shouldMute = true;
		}
	}
	socket_.modem.mute = shouldMute;
}
#pragma mark OTOduinoPinModeType delegate
- (void)sendBufferEmptyNotify
{
	[self sendRequests];
}
//receiving pin/port value
- (void)receiveAnalogPinValue:(Byte)pin value:(int)value
{
	if(pin >= kNumOfAnalogPins) return;
//	NSLog(@"%s receiveAnalogPinValue:%d value:%d",__func__, pin, value);
	AnalogPinModel *model = [client_.analogPinModels objectAtIndex:pin];
	model.value = value;
}
- (void)receiveDigitalPortValue:(Byte)port value:(int)value
{
//	NSLog(@"%s port:%d value:0x%x", __func__, port, value);
	int mask = 0x01;
	for(int i=0; i <kNumOfDigitalPins; i++) {
		// is pin mode input/output?
		DigitalPinModel *model = [client_.digitalPinModels objectAtIndex:i];		
		if(model.pinMode == (OTOduinoPinModeType)Input || model.pinMode == (OTOduinoPinModeType)Output) {
			int val = ((mask & value) == 0) ? 0 : 1;
			if(model.value != val) {
			   model.value = val;
			}
		}
		mask <<= 1; // shift mask
	}
}
//receiving pin/port status
-(void)receiveAnalogPinEnabled:(Byte)pin  enabled:(BOOL)enabled
{
	if(pin >= kNumOfAnalogPins) return;
	
	shouldCheckAnalogEnabled_[pin] = false;
	AnalogPinModel *model = [client_.analogPinModels objectAtIndex:pin];
	model.enabled = enabled;
}
-(void)receiveDigitalPinMode:(Byte)pin pinMode:(OTOduinoPinModeType)pinMode
{
	if(pin >= kNumOfDigitalPins) return;
//	NSLog(@"%s receiveDigitalPinMode:%d pinMode:%d",__func__, pin, pinMode);
	shouldCheckPinMode_[pin] = false;
	DigitalPinModel *model = [client_.digitalPinModels objectAtIndex:pin];
	model.pinMode = pinMode;
}
#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	[self checkAudioSocketStat];
}
#pragma mark Public methdos
-(void)setAnalogPinEnabled:(Byte)pin enabled:(BOOL)enabled
{
	if(pin <= 0 || pin >= kNumOfAnalogPins) return;
	
	shouldCheckAnalogEnabled_[pin] = true;
	[socket_ enableAnalogPin:pin enabled:enabled];
}
-(void)setDigitalPinMode:(Byte)pin pinMode:(OTOduinoPinModeType)pinMode
{
	shouldCheckPinMode_[pin] = true;
	[socket_ setDigitalPinMode:pin pinMode:pinMode];
}
-(void)setDigitalPinValue:(Byte)pin value:(int)value
{
	uint mask = (0x01 << pin);
	if(value == 0) {
		digitalValue_ &= ~mask; // false
	} else {
		digitalValue_ |= mask; //true
	}
	[socket_ setDigitalOutput:0 value:digitalValue_];
}
-(void)receiveClientInitializedMessage
{
	[self setCheckFlags];
	[socket_ confirmedClientInitialization];
}
@end
