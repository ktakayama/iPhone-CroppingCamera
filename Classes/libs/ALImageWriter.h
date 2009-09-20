//
//  ALImageWriter.h
//  CroppingCamera
//
//  Created by Kyosuke Takayama on 09/09/08.
//  Copyright 2009 Kyosuke Takayama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#if !TARGET_IPHONE_SIMULATOR
#import "EXF.h"
#import "EXFUtils.h"
#endif

@class ALImageWriter;

@protocol ALImageWriterDelegate
- (void) ALImageWriterDidFail:(ALImageWriter *)sender error:(NSError *)error;
- (void) ALImageWriterDidSucceed:(ALImageWriter *)sender image:(UIImage *)image;
@end

@interface ALImageWriter : NSObject <CLLocationManagerDelegate> {
   NSObject <ALImageWriterDelegate> *delegate;
   BOOL use_gps;
   NSArray *photos;
   CLLocation *location;
   CLLocationManager *locationManager;
}

@property BOOL use_gps;

+ (BOOL) canWriteExif;

- (id) initWithDelegate:(NSObject *)object;
- (void) updateLocation;

- (void) writeToSavedPhotosAlbum:(UIImage *)image;
- (NSArray *) savedPhotos;

#if !TARGET_IPHONE_SIMULATOR
- (NSData *) addExif:(NSData *)image;
- (NSMutableArray*) createLocArray:(double)val;
- (void) populateGPS:(EXFGPSLoc*)gpsLoc array:(NSArray*)locArray;
#endif

@end
