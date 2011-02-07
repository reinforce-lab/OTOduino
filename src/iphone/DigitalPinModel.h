//
//  digitalPinModel.h
//  OTOduino
//
//  Created by 上原 昭宏 on 11/01/30.
//  Copyright 2011 REINFORCE Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTOduinoTypes.h"

@interface DigitalPinModel : NSObject {
	int  portNumber_;
	int  pinNumber_;
	OTOduinoPinModeType pinMode_;
	int  value;
}
@property (nonatomic, assign) int portNumber;
@property (nonatomic, assign) int pinNumber;
@property (nonatomic, assign) OTOduinoPinModeType pinMode;
@property (nonatomic, assign) int value;
@end
