//
//  ALApps.m
//  CroppingCamera
//
//  Created by Kyosuke Takayama on 09/09/05.
//  Copyright 2009 Kyosuke Takayama. All rights reserved.
//

#import "ALApps.h"

#define APPFILENAME  @"apps.plist"
#define APPBASEURL   @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%d&mt=8"

@implementation ALApps

@synthesize appid;
@synthesize name;
@synthesize icon;

+ (NSArray *) apps {
   NSArray *ary = [NSArray arrayWithContentsOfFile:[self pathOfDataFile]];
   NSDictionary *dict;

   NSMutableArray *results = [NSMutableArray array];
   for(dict in ary) {
      ALApps *obj = [[self alloc] init];
      obj.appid = [[dict objectForKey:@"appid"] intValue];
      obj.name  = [dict objectForKey:@"name"];
      obj.icon  = [UIImage imageNamed:[dict objectForKey:@"icon"]];
      [results addObject:obj];
      [obj release];
   }

   return results;
}

+ (NSString *) pathOfDataFile {
   return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:APPFILENAME];
}

- (void) openStore {
   NSString *urlString = [NSString stringWithFormat:APPBASEURL, self.appid];
   NSURL *url= [NSURL URLWithString:urlString];
   [[UIApplication sharedApplication] openURL:url];
}

- (void) dealloc {
   [name release];
   [icon release];
   [super dealloc];
}

@end
