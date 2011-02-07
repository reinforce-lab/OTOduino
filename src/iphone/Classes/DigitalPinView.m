//
//  DigitalPinView.m
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/21.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import "DigitalPinView.h"

@interface DigitalPinView (Private)
@end

@implementation DigitalPinView
#pragma mark Constructor
-(void)awakeFromNib
{
}
-(void)dealloc
{
	[model_ removeObserver:self forKeyPath:@"value"];
	[model_ removeObserver:self forKeyPath:@"pinMode"];
	[host_ release];
}
#pragma mark Event handler
-(IBAction)pinDirectionButtonTouched:(id)sender
{
	OTOduinoPinModeType mode = (model_.pinMode == Input) ? Output : Input;
	[host_ setDigitalPinMode:model_.pinNumber pinMode:mode];
}
-(IBAction)buttonTouched:(id)sender
{
	if(model_.pinMode == Output) {
		NSLog(@"%s", __func__);
		int val = (model_.value == 0) ? 1 : 0;
		[host_ setDigitalPinValue:model_.pinNumber value:val];
	}
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//	NSLog(@"%s keypath:%@ ofObject:%@ change:%@ context:%@", __func__,keyPath, object, change, context );
	if([keyPath isEqualToString:@"pinMode"]) {
		pinDirectionButton_.selected = (model_.pinMode == Output);
	} else if([keyPath isEqualToString:@"value"] ){
		button_.selected = (model_.value == 0) ? false : true;
	}
}
#pragma mark Public methods
-(void)initialize:(int)pinNumber host:(OTOduinoHost *)host
{
	host_  = [host retain];
	model_ = [host_.model.digitalPinModels objectAtIndex:pinNumber];

	// add observer
	[model_ addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
	[model_ addObserver:self forKeyPath:@"pinMode" options:NSKeyValueObservingOptionNew context:nil];
	
	// set default values
	titleLabel_.text    = [NSString stringWithFormat:@"D%02d", pinNumber];
	pinDirectionButton_.selected = (model_.pinMode == Output);
	button_.selected = (model_.value == 0) ? false : true;
}
@end