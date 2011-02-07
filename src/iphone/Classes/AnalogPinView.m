//
//  AnalogPinView.m
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/21.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import "AnalogPinView.h"

@interface AnalogPinView (Private)
@end

#define kGrayOutAlpha 0.5

@implementation AnalogPinView
#pragma mark Properties

#pragma mark Constructor
-(void)awakeFromNib
{		
}
-(void)initialize:(int)pinNumber host:(OTOduinoHost *)host title:(NSString *)title unit:(NSString *)unit maxValue:(Float32)maxValue minValue:(Float32)minValue
{
	// set values
	host_  = [host retain];
	model_ = [host_.model.analogPinModels objectAtIndex:pinNumber];

	// add observer
	[model_ addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
	[model_ addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];

	// set default values
	titleLabel_.text = title;
	unitLabel_.text  = unit;
	colorBarView_.maxValue = maxValue;
	colorBarView_.minValue = minValue;

	// diable view
	enabled_   = false;
	self.alpha = kGrayOutAlpha;
	valueLabel_.text = @"-";
	colorBarView_.value = minValue;
}
-(void)dealloc
{
	[model_ removeObserver:self forKeyPath:@"value"];
	[model_ removeObserver:self forKeyPath:@"enabled"];
		
	[host_ release];
}
#pragma mark Event handler
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[host_ setAnalogPinEnabled:model_.pinNumber enabled: !enabled_ ];
}
#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	// check value
	//	NSLog(@"%s keypath:%@ ofObject:%@ change:%@ context:%@", __func__,keyPath, object, change, context );
	// enabled?
	if(enabled_ != model_.enabled) {
		enabled_ = model_.enabled;
		self.alpha = enabled_ ? 1.0 : kGrayOutAlpha;
		// if disabled, update view
		if(! enabled_ ) {
			valueLabel_.text = @"-";
			colorBarView_.value = colorBarView_.minValue;
		} 
	}
	// update value
	if(enabled_) {
		float adc_value = (float)model_.value / 1023.0f;
		float voltage = (colorBarView_.maxValue - colorBarView_.minValue) * adc_value + colorBarView_.minValue;
		colorBarView_.value = voltage;
		valueLabel_.text = [NSString stringWithFormat:@"%1.2f", voltage];		
		//NSLog(@"%s adc_value:%f voltage:%f", __func__, adc_value, voltage);
	}
}
#pragma mark Public methods

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	// how terrible code this is ...
	if( point.x > 0 && 131 > point.x && point.y > 0 && 63 > point.y )
		return self;
	else
		return nil;
	/*
	NSLog(@"%s (%f, %f) bounds(%f, %f, %f, %f) contains: %d", __func__, point.x, point.y, 
		  self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height,
		  CGRectContainsPoint( self.bounds, point));
	return [super hitTest:point withEvent:event];*/
}
@end