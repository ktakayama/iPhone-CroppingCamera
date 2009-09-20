//
//  CCImagePreviewCell.m
//  CroppingCamera
//
//  Created by Kyosuke Takayama on 09/09/01.
//  Copyright 2009 Kyosuke Takayama. All rights reserved.
//

#import "CCImagePreviewCell.h"

@implementation CCImagePreviewCell

@synthesize preview;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       // Initialization code
       preview = [[UIImageView alloc] init];
       preview.contentMode = UIViewContentModeScaleAspectFit;
       [self addSubview:preview];
       self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void) layoutSubviews {
   [super layoutSubviews];
   preview.frame = CGRectInset(self.bounds, 20.0f, 10.0f);
}

- (void) dealloc {
   [preview release];
   [super dealloc];
}

@end
