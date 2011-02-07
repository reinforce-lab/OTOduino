//
//  OTOduinoAppDelegate.h
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/21.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTOduinoHost.h"

@interface OTOduinoAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;

	OTOduinoHost *host_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, readonly) OTOduinoHost *host;
@end
