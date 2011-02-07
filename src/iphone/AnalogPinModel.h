//
//  AnalogPinModel.h
//  OTOduino
//
//  Created by 上原 昭宏 on 11/01/30.
//  Copyright 2011 REINFORCE Lab. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AnalogPinModel : NSObject {
	int pinNumber_;
	int value_;
	bool enabled_;
}
@property (nonatomic, assign) int pinNumber;
@property (nonatomic, assign) int value;
@property (nonatomic, assign) bool enabled;
@end
