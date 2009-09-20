//
//  CCPrefsCell.m
//  CroppingCamera
//
//  Created by Kyosuke Takayama on 09/09/06.
//  Copyright 2009 Kyosuke Takayama. All rights reserved.
//

#import "CCPrefsCell.h"
#import "ALPreferences.h"

@implementation CCPrefsCell

@synthesize key, title;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      // Initialization code
      self.selectionStyle = UITableViewCellSelectionStyleNone;

      title = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 200, 35)];
      title.font = [UIFont systemFontOfSize:18];
      [self addSubview:title];

      button = [[UISwitch alloc] initWithFrame:CGRectMake(200, 9, 20, 20)];
      [button addTarget:self action:@selector(switchButton) forControlEvents:UIControlEventValueChanged];
      [self addSubview:button];
   }
   return self;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
   [super setSelected:selected animated:animated];
   ALPreferences *pref = [ALPreferences prefForKey:key];
   button.on = pref.data;
}

- (void) switchButton {
   ALPreferences *pref = [ALPreferences prefForKey:key];
   pref.data = button.on;
}

- (void) dealloc {
   [key release];
   [title release];
   [button release];
   [super dealloc];
}

@end
