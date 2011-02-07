//
//  VoltageView.h
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/21.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorBarView.h"

/// Digital port meter view
/// This class must not be initialized with a selector intWithRect:.
/// An instance of this class must be initialized calling:
/// [[NSBundle mainBundle] loadNibNamed:@"VoltageView" owner:self options:nil] objectAtInde:0]
@interface VoltageView : UIView {
	IBOutlet UILabel *valueLabel_;
	IBOutlet UILabel *titleLabel_;

	IBOutlet ColorBarView *colorBarView_;
}
@property (nonatomic, assign, getter=getValue, setter=setValue:) Float32 value;
@property (nonatomic, assign, getter=getMaxValue, setter = setMaxValue:) Float32 maxValue;
@property (nonatomic, assign, getter=getMinValue, setter = setMinValue:) Float32 minValue;

@end
