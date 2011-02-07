//
//  IOViewController.h
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/22.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTOduinoHost.h"
#import "AnalogPinView.h"
#import "DigitalPinView.h"
#import "ConnectionStatusView.h"

@interface IOViewController : UIViewController {
	IBOutlet UIImageView *bakgroundImageView_;

	OTOduinoHost *host_;
//	AnalogPinView *analogPorts_[kNumOfAnalogPorts];
//	DigitalPinView *digitalPorts_[kNumOfDigitalPorts];	
	ConnectionStatusView *connectStatusView_;
}
@end
