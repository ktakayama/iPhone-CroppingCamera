//
//  CCImagePreviewCell.h
//  CroppingCamera
//
//  Created by Kyosuke Takayama on 09/09/01.
//  Copyright 2009 Kyosuke Takayama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCImagePreviewCell : UITableViewCell {
   UIImageView *preview;
}

@property (nonatomic, retain) UIImageView *preview;

@end
