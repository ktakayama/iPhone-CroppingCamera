//
//  CroppingCameraAppDelegate.h
//  CroppingCamera
//
//  Created by Kyosuke Takayama on 09/08/25.
//  Copyright Kyosuke Takayama 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCInfoViewController;

@interface CroppingCameraAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CCInfoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CCInfoViewController *viewController;

@end

