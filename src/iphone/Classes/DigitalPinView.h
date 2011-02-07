//
//  DigitalPinView.h
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/21.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "OTOduinoHost.h"
#import "DigitalPinModel.h"

/// Digital port meter view
/// This class must not be initialized with a selector intWithRect:.
/// An instance of this class must be initialized calling:
/// [[NSBundle mainBundle] loadNibNamed:@"DigitalPinView" owner:self options:nil] objectAtInde:0]
@interface DigitalPinView : UIView {
	IBOutlet UILabel  *titleLabel_;
	IBOutlet UIButton *pinDirectionButton_;
	IBOutlet UIButton *button_;

	OTOduinoHost *host_;
	DigitalPinModel *model_;
}

-(void)initialize:(int)pinNumber host:(OTOduinoHost *)host;
-(IBAction)pinDirectionButtonTouched:(id)sender;
-(IBAction)buttonTouched:(id)sender;
@end
