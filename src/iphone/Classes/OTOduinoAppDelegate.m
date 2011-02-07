//
//  OTOduinoAppDelegate.m
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/21.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import "OTOduinoAppDelegate.h"

@implementation OTOduinoAppDelegate
#pragma mark Properties
@synthesize window;
@synthesize tabBarController;
@synthesize host = host_;

#pragma mark Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	// prepare firmata host
	host_ = [[OTOduinoHost alloc] init];
	
	// prepare view controller
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];

    return YES;
}			 
- (void)applicationWillTerminate:(UIApplication *)application {
	[host_ release];
}
			 
- (void)applicationWillResignActive:(UIApplication *)application {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
}

#pragma mark UITabBarControllerDelegate methods
/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/
/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/
#pragma mark Memory management
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}
@end

