//
//  CCAppsCell.h
//  CroppingCamera
//
//  Created by Kyosuke Takayama on 09/09/05.
//  Copyright 2009 Kyosuke Takayama. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALApps;

@interface CCAppsCell : UITableViewCell {
   ALApps *app;
   UIImageView *icon;
   UILabel *title;
}

@property (nonatomic, retain) ALApps *app;

@end
