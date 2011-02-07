//
//  ColorBarView.m
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/21.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//
#import "ColorBarView.h"
#include "math.h"

@interface ColorBarView(Private)
-(void)initialize;
@end

@implementation ColorBarView
#pragma mark Properties
@synthesize maxValue = maxValue_;
@synthesize minValue = minValue_;
@dynamic value;

-(Float32)getValue
{
	return value_;
}
-(void)setValue:(Float32)value
{
	// update a value and calculate a color bat index
	value_ = value;
	int index = (int)ceilf(10.0f * value / (maxValue_ - minValue_)); // MEMO 0 div exception?

    // update a color bar image
	if(index_ != index) {
		index_ = (index > index_) ? (index_ +1) : (index_ -1);
		self.image = [ImageSource getColorBarImage:index_];
	}
}
#pragma mark Constructor
-(void)awakeFromNib
{
	[self initialize];
}
-(void)initialize
{
	maxValue_ = 255;
	minValue_ = 0;
		
	self.backgroundColor = [UIColor clearColor];	
	self.image = [ImageSource getColorBarImage:5];
}
- (void)dealloc {
    [super dealloc];
}
@end
