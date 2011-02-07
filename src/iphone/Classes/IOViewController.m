//
//  IOViewController.m
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/22.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import "IOViewController.h"
#import "OTOduinoAppDelegate.h"

@interface IOViewController(Private)
-(void)timerUpdated:(NSTimer *)aTimer;
-(void)setInitialIOValue;
@end

@implementation IOViewController
#pragma mark UIViewController override methods
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	// get host instance
	OTOduinoAppDelegate *dlg =(OTOduinoAppDelegate *)[UIApplication sharedApplication].delegate;
	host_ = [dlg.host retain];
	
	[self setInitialIOValue];
	// setup digital port views
	CGFloat ptx = 155;
	CGFloat pty = 16 + 20;
	CGFloat width = 154;
	CGFloat height = 31;
	CGFloat dy  = 35;
	int pinNum = 11;
	UINib *digitalPinViewNib = [UINib nibWithNibName:@"DigitalPinView" bundle:[NSBundle mainBundle]];
	for(int i=0; i < 4; i++) {
		DigitalPinView *port_view = [[digitalPinViewNib instantiateWithOwner:self options:nil] objectAtIndex:0];
		// setup instance
		port_view.frame = CGRectMake(ptx, pty, width, height);
		[port_view initialize:pinNum host:host_];
		// add instance
		[self.view addSubview:port_view];
		// get next y point and port number
		pty += dy;
		pinNum--;
	}
	pty     = 174 + 20 - 3;
	pinNum = 7;
	for(int i=0; i < 6; i++) {	
		// instantiate
		DigitalPinView *port_view = [[digitalPinViewNib instantiateWithOwner:self options:nil] objectAtIndex:0];
		// setup instance
		port_view.frame = CGRectMake(ptx, pty, width, height);
		[port_view initialize:pinNum host:host_];
		// add instance
		[self.view addSubview:port_view];
		// get next y point and port number
		pty += dy;
		pinNum--;
	}
	// setup analog port views
	ptx = 9;
	pty = 11;
	dy  = 63 + 5;
	width  = 131;
	height = 63;
	UINib *analogPinViewNib = [UINib nibWithNibName:@"AnalogPinView" bundle:[NSBundle mainBundle]];
	for(int i=0; i < kNumOfAnalogPins; i++) { // analog pin0 is reserved for the software modem
		if([host_.model isReservedModemAnalogPin:i]) continue;
		// instantiate
		AnalogPinView *port_view = [[analogPinViewNib instantiateWithOwner:self options:nil] objectAtIndex: 0];
		// setup instance
		port_view.frame = CGRectMake(ptx, pty, width, height);
		[port_view initialize:i host:host_ title:[NSString stringWithFormat:@"A%02d", i] unit:@"V" maxValue:5.0 minValue:0.0];
		// add view		
		[self.view addSubview:port_view];
		// get next y point and port number
		pty += dy;
	}	
	// connection status view
	connectStatusView_ = [[[NSBundle mainBundle] loadNibNamed:@"ConnectionStatusView" owner:self options:nil] objectAtIndex:0];
	connectStatusView_.frame = CGRectMake(13, 353, 64, 54);
	connectStatusView_.host = host_;
	[self.view addSubview:connectStatusView_];
}
- (void)viewDidUnload 
{
	[host_ removeObserver:self forKeyPath:@"connectionStat"];

	[connectStatusView_ release];
	[host_ release];
	
	[super viewDidUnload];	
}
-(void)viewWillAppear:(BOOL)animated
{
	host_.mute = false;
	
	[super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
	host_.mute = true;
	
	[super viewWillDisappear:animated];
}
#pragma mark Private methods
// set firmata host initial state
-(void)setInitialIOValue
{
	for(int i=0; i < kNumOfAnalogPins; i++) {
		[host_ setAnalogPinEnabled:i enabled:false];
	}
	for(int i=0; i < kNumOfDigitalPins; i++) {
		[host_ setDigitalPinMode:i pinMode:(OTOduinoPinModeType)Input];
		[host_ setDigitalPinValue:i value:0];
	}
}

@end
