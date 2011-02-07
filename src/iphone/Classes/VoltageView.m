//
//  VoltageView.m
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/21.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import "VoltageView.h"

@interface VoltageView (Private)
-(Float32)getValue;
-(void)setValue:(Float32)value;
-(Float32)getMaxValue;
-(void)setMaxValue:(Float32)value;
-(Float32)getMinValue;
-(void)setMinValue:(Float32)value;
@end

@implementation VoltageView
#pragma mark Properties
@dynamic value;
@dynamic maxValue;
@dynamic minValue;
-(Float32)getValue
{
	return colorBarView_.value;
}
-(void)setValue:(Float32)value
{
	colorBarView_.value = value;
	valueLabel_.text = [NSString stringWithFormat:@"%1.2f V", colorBarView_.value];
}
-(void)setMaxValue:(Float32)value
{
	colorBarView_.maxValue = value;
}
-(Float32)getMaxValue
{
	return colorBarView_.maxValue;
}
-(void)setMinValue:(Float32)value
{
	colorBarView_.minValue = value;
}
-(Float32)getMinValue
{
	return colorBarView_.minValue;
}
@end
