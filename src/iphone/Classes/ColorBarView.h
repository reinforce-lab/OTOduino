//
//  ColorBarView.h
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/21.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ImageSource.h"

/// Analog color bar meter.
/// Color bar is shown when |highlighted property is TRUE. When highlighted is FALSE
/// Default frame width and height is 109 and 19, previously.
///
@interface ColorBarView : UIImageView {
	int index_;
	Float32 value_, maxValue_, minValue_;
}
@property (nonatomic, assign, getter=getValue, setter=setValue:) Float32 value;
@property (nonatomic, assign) Float32 maxValue;
@property (nonatomic, assign) Float32 minValue;

-(Float32)getValue;
-(void)setValue:(Float32)value;
@end
