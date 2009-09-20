//
//  CroppingCameraAppDelegate.m
//  CroppingCamera
//
//  Created by Kyosuke Takayama on 09/08/25.
//  Copyright Kyosuke Takayama 2009. All rights reserved.
//

#import "CroppingCameraAppDelegate.h"
#import "CCInfoViewController.h"

@implementation CroppingCameraAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

    [viewController launchCamera];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
