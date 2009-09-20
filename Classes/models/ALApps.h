//
//  ALApps.h
//  CroppingCamera
//
//  Created by Kyosuke Takayama on 09/09/05.
//  Copyright 2009 Kyosuke Takayama. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALApps : NSObject {
   NSInteger appid;
   NSString *name;
   UIImage *icon;
}

@property NSInteger appid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) UIImage *icon;

+ (NSArray *) apps;
+ (NSString *) pathOfDataFile;

- (void) openStore;

@end
