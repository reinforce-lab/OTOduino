//
//  AnalogPinView.h
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/21.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTOduinoHost.h"
#import "AnalogPinModel.h"
#import "ColorBarView.h"

/// Digital port meter view
/// This class must not be initialized with a selector intWithRect:.
/// An instance of this class must be initialized calling:
/// [[NSBundle mainBundle] loadNibNamed:@"DigitalPinView" owner:self options:nil] objectAtInde:0]
@interface AnalogPinView : UIView {
	IBOutlet UILabel *titleLabel_;
	IBOutlet UILabel *valueLabel_;
	IBOutlet UILabel *unitLabel_;
	IBOutlet ColorBarView *colorBarView_;

	BOOL enabled_;
	OTOduinoHost *host_;	
	AnalogPinModel *model_;
}

-(void)initialize:(int)pinNumber host:(OTOduinoHost *)host title:(NSString *)title unit:(NSString *)unit maxValue:(Float32)maxValue minValue:(Float32)minValue;
@end
