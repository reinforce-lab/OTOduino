//
//  OTOduinoPinModeTypeSocket.m
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/23.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import "OTOduinoSocket.h"

@interface OTOduinoSocket(Private)
-(void)decodePacket:(Byte *)buf length:(int)length;
-(void)decodeExPacket:(Byte *)buf length:(int)length;
-(BOOL)readMessage:(Byte *)buf length:(int)length port:(Byte *)port value:(int *)value;
-(BOOL)readVersion:(Byte *)buf length:(int)length version:(int *)version;
@end

@implementation OTOduinoSocket
#pragma mark Properties
@synthesize modem = modem_;
@synthesize audioPHY = audioPHY_;

#pragma mark Construcotr
-(id)initWithDelegate:(NSObject<OTOduinoHostDelegate> *)delegate
{
	self = [super init];
	if(self) {
		modem_ = [[FSKModem alloc] initWithSocketWithoutPHY:self];
		audioPHY_ = [[AudioPHY alloc] initWithSocket:modem_ audioBufferLength:kFSKAudioBufferLength];	
		delegate_ = [delegate retain];
//		[modem_ start];
		[audioPHY_ start];
	}
	return self;
}
#pragma mark Construcotr
-(void)dealloc
{
	[modem_ release];
	[audioPHY_ release];
	[delegate_ release];
	
	[super dealloc];
}
#pragma mark SWMConnecting
- (void)packetReceived:(Byte *)buf length:(int)length
{
	/*
	NSMutableString *sb = [[NSMutableString alloc] initWithCapacity:10];
	for(int i = 0; i < length ; i++) {
		[sb appendFormat:@"0x%02x,", buf[i]];	
	}
	NSLog(@"received packet: length:%d buf:%@", length, sb);
	[sb release];
	*/
	if(length == 0) return;	
	[self decodePacket:buf length:length];
}
-(void)sendBufferEmptyNotify
{
	[delegate_ sendBufferEmptyNotify];
}
#pragma mark Private methods
-(BOOL)readMessage:(Byte *)buf length:(int)length port:(Byte *)port value:(int *)value
{
	if(length != 4) return false;

	*port  = buf[1];
	*value = buf[2] | (buf[3] << 8);

	return true;
}
-(BOOL)readVersion:(Byte *)buf length:(int)length version:(int *)version
{
	// TODO
	return true;
}
-(void)decodePacket:(Byte *)buf length:(int)length
{
	if(length < 1) return;
		
	Byte pin;
	int value;
	switch(buf[0])	{
		case (OTOduinoCommandType)analogIOMessage:
			// update analog pin value
			if( [self readMessage:buf length:length port:&pin value:&value] ) {
				[delegate_ receiveAnalogPinValue:pin value:value];
			}
			break;
		case (OTOduinoCommandType)digitalIOMessage:
			// update digital pin value
			if( [self readMessage:buf length:length port:&pin value:&value] ) {
				[delegate_ receiveDigitalPortValue:pin value:value];
			}
			break;
		case (OTOduinoCommandType)analogPinEnabledMessage:
			[delegate_ receiveAnalogPinEnabled:buf[1] enabled:buf[2]];
			break;			
		case (OTOduinoCommandType)digitalPinModeMessage:
			[delegate_ receiveDigitalPinMode:buf[1] pinMode:buf[2]];
			break;
		case (OTOduinoCommandType)clientInitMessage:
			[delegate_ receiveClientInitializedMessage];
			break;
		default: // TODO
			break;
	}
}
#pragma mark Public methods
// configurate pin/port
-(BOOL)enableAnalogPin:(Byte)pin enabled:(BOOL)enabled
{
//	NSLog(@"sending packet: setAnalogPinEnabled pin:%d enabled:%d", pin, enabled);	
	buf_[0] = (OTOduinoCommandType)setAnalogPinEnabled;
	buf_[1] = pin;
	buf_[2] = enabled ? 0x01 : 0x00;
	return ( [modem_ sendPacket:buf_ length:3] == 3);
}
-(BOOL)setDigitalPinMode:(Byte)pin pinMode:(OTOduinoPinModeType)pinMode
{
//	NSLog(@"sending packet: setDigitalPinMode pin:%d pinMode:%d", pin, pinMode);
	buf_[0] = (OTOduinoCommandType)setDigitalPinMode;
	buf_[1] = pin;
	buf_[2] = pinMode;
	return [modem_ sendPacket:buf_ length:3] == 3;
}
// request pin/port value
-(BOOL)setDigitalOutput:(Byte)port value:(int)value
{	
//	NSLog(@"sending packet: digitalIOMessage port:%d value:%d", port, value);
	buf_[0] = (OTOduinoCommandType)digitalIOMessage;
	buf_[1] = port;
	buf_[2] = (Byte)(value &0x00ff);
	buf_[3] = (Byte)(value >> 8);
	return ([modem_ sendPacket:buf_ length:4] == 4);
}
// pin status readback
-(BOOL)requestAnalogPinEnabled:(Byte)pin
{
//	NSLog(@"sending packet: requestAnalogPinEnabled pin:%d", pin);
	buf_[0] = (OTOduinoCommandType)requestAnalogPinEnabled;
	buf_[1] = pin;
	return [modem_ sendPacket:buf_ length:2] == 2;	
}
-(BOOL)requestDigitalPinMode:(Byte)pin
{
//	NSLog(@"sending packet: requestDigitalPinMode pin:%d", pin);
	buf_[0] = (OTOduinoCommandType)requestDigitalPinMode;
	buf_[1] = pin;	
	return [modem_ sendPacket:buf_ length:2] == 2;	
}
-(BOOL)confirmedClientInitialization
{
//	NSLog(@"sending packet: clientInitConfirmedMessage");
	buf_[0] = (OTOduinoCommandType)clientInitConfirmedMessage;
	return [modem_ sendPacket:buf_ length:1] == 1;	
}
@end
