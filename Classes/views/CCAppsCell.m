//
//  CCAppsCell.m
//  CroppingCamera
//
//  Created by Kyosuke Takayama on 09/09/05.
//  Copyright 2009 Kyosuke Takayama. All rights reserved.
//

#import "CCAppsCell.h"
#import "ALApps.h"

@implementation CCAppsCell

@synthesize app;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      // Initialization code
      self.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;

      icon = [[UIImageView alloc] initWithFrame:CGRectMake(25, 7, 30, 30)];
      [self addSubview:icon];

      title = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 200, 35)];
      title.font = [UIFont systemFontOfSize:18];
      [self addSubview:title];
   }
   return self;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
   [super setSelected:selected animated:animated];
   icon.image = app.icon;
   title.text = app.name;
}

- (void) dealloc {
   [app release];
   [icon release];
   [title release];
   [super dealloc];
}

@end
