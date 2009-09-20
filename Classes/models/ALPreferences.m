//
//  ALPreferences.m
//  CroppingCamera
//
//  Created by Kyosuke Takayama on 09/09/06.
//  Copyright 2009 Kyosuke Takayama. All rights reserved.
//

#import "ALPreferences.h"

@implementation ALPreferences

@synthesize data;
static NSMutableDictionary *_instance;

+ (id) prefForKey:(NSString *)key {
   @synchronized(self) {
      if (_instance == nil) {
         _instance = [[NSMutableDictionary dictionary] retain];
      }

      if([_instance objectForKey:key] == nil) {
         [_instance setObject:[[self alloc] initForKey:key] forKey:key];
      }
   }
   return [_instance objectForKey:key];
}

- (id) initForKey:(NSString *)str {
   if(self = [super init]) {
      data = [[NSUserDefaults standardUserDefaults] boolForKey:str];
      key  = [str retain];
   }

   return self;
}

- (void) setData:(BOOL)newData {
   [[NSUserDefaults standardUserDefaults] setBool:newData forKey:key];
   [[NSUserDefaults standardUserDefaults] synchronize];
   data = newData;
}

- (void) dealloc {
   [key release];
   [super dealloc];
}

@end
