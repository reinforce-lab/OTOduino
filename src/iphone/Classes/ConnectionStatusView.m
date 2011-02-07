//
//  ConnectionStatusView.m
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/22.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import "ConnectionStatusView.h"
@interface ConnectionStatusView(Private)
-(void)updateView;
@end

@implementation ConnectionStatusView
#pragma mark Properties
@dynamic host;
-(OTOduinoHost *)getHost
{
	return host_;
}
-(void)setHost:(OTOduinoHost *)host
{
	if(host == host_) return;

	[host_ removeObserver:self forKeyPath:@"connectionStat"];
	[host_ release];
	
	host_ = host;	
	[host_ addObserver:self forKeyPath:@"connectionStat" options:NSKeyValueObservingOptionNew context:nil];
	
	[self updateView];
}
#pragma mark Constructor
-(void)dealloc
{
	self.host = nil;

	[super dealloc];
}
-(void)updateView
{
	iconImageView_.highlighted = (host_.connectionStat == NoError);
	switch (host_.connectionStat) {
		case HeadsetIsNotAvailable:
			errorTextlabel_.text = @"No earphone jack.";
			break;
		case InSufficientVolume:
			errorTextlabel_.text = @"Output volume is small.";
			break;
		case SoftwarePLLUnLock:
			errorTextlabel_.text = @"Cannot receive packets.";
			break;
		default:
			errorTextlabel_.text = @"";
			break;
	}
}
#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//	NSLog(@"%s %@ (connection error) %d",__func__, keyPath, host_.connectionStat);
	[self updateView];
}
@end
