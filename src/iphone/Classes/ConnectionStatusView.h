//
//  ConnectionStatusView.h
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/22.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTOduinoHost.h"

/// ConnectionStatusView
/// This class must not be initialized with a selector intWithRect:.
/// An instance of this class must be initialized calling:
/// [[NSBundle mainBundle] loadNibNamed:@"ConnectionStatusView" owner:self options:nil] objectAtInde:0]
@interface ConnectionStatusView : UIView {
	IBOutlet UIImageView *iconImageView_;
	IBOutlet UILabel *errorTextlabel_;
	
	OTOduinoHost *host_;
}
@property (nonatomic, assign, getter=getHost, setter=setHost:) OTOduinoHost *host;
@end
