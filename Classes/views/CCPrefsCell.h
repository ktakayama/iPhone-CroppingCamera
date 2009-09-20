//
//  CCPrefsCell.h
//  CroppingCamera
//
//  Created by Kyosuke Takayama on 09/09/06.
//  Copyright 2009 Kyosuke Takayama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCPrefsCell : UITableViewCell {
   NSString *key;
   UILabel *title;
   UISwitch *button;
}

@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) UILabel *title;

@end
