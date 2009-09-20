//
//  ALPreferences.h
//  CroppingCamera
//
//  Created by Kyosuke Takayama on 09/09/06.
//  Copyright 2009 Kyosuke Takayama. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALPFKeyGrayScale   @"pf_grayscale"
#define ALPFKeyGPS         @"pf_gps"

@interface ALPreferences : NSObject {
   BOOL data;
   NSString *key;
}

@property BOOL data;

+ (id) prefForKey:(NSString *)key;
- (id) initForKey:(NSString *)str;

@end
