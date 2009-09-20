//
//  ALImageWriter.m
//  CroppingCamera
//
//  Created by Kyosuke Takayama on 09/09/08.
//  Copyright 2009 Kyosuke Takayama. All rights reserved.
//

#import "ALImageWriter.h"

#define PHOTO_PATH               @"/var/mobile/Media/DCIM/"
#define VALUE_OF_EXIF_MAKE       @"Apple"
#define VALUE_OF_EXIF_MODEL      @"iPhone"

BOOL gLogging = FALSE;

@implementation ALImageWriter

@synthesize use_gps;

+ (BOOL) canWriteExif {
   return [[NSFileManager defaultManager] isWritableFileAtPath:PHOTO_PATH];
}

- (void) dealloc {
   [delegate release];
   [photos release];
   [location release];
   [locationManager release];
   [super dealloc];
}

- (id) initWithDelegate:(NSObject *)object {
   if(self = [super init]) {
      delegate = [object retain];
      photos = nil;
   }
   return self;
}

- (void) updateLocation {
   if(!use_gps) return;
   [locationManager release];
   locationManager = nil;
   locationManager = [[CLLocationManager alloc] init];
   locationManager.delegate = self;
   [locationManager startUpdatingLocation];
}

- (void) writeToSavedPhotosAlbum:(UIImage *)image {
   if(photos) {
      // do not create multiple instance
      return;
   }
   photos = [[self savedPhotos] retain];

   UIImageWriteToSavedPhotosAlbum(image,
      self, @selector(afterSave:didFinishSavingWithError:contextInfo:), nil);
}

- (void) afterSave:(UIImage *)image
    didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
   NSMutableArray *newPhotos = (NSMutableArray *)[self savedPhotos];
   [newPhotos removeObjectsInArray:photos];
   [photos release];
   photos = nil;

#if !TARGET_IPHONE_SIMULATOR
   if([[self class] canWriteExif]) {
      NSString *path = [PHOTO_PATH stringByAppendingPathComponent:[newPhotos lastObject]];
      NSData *newImage = [self addExif:[NSData dataWithContentsOfFile:path]];
      [newImage writeToFile:path atomically:YES];
   }
#endif

   [delegate ALImageWriterDidSucceed:self image:image];
}

- (NSArray *) savedPhotos {
   NSEnumerator *enu = [[NSFileManager defaultManager] enumeratorAtPath:PHOTO_PATH];
   NSString *file;
   NSMutableArray *results = [NSMutableArray array];
   while(file = [enu nextObject]) {
      if(![file hasSuffix:@".JPG"]) continue;
      [results addObject:file];
   }
   return results;
}

#if !TARGET_IPHONE_SIMULATOR
- (NSData *) addExif:(NSData *)uiJpeg {
   NSString *dateTime = [[[NSDate date] description] stringByReplacingOccurrencesOfString:@"-" withString:@":"];

   EXFJpeg *jpegScanner = [[EXFJpeg alloc] init];
   [jpegScanner scanImageData:uiJpeg];
   [jpegScanner.exifMetaData addTagValue:dateTime forKey:[NSNumber numberWithInt:EXIF_DateTime]];
   [jpegScanner.exifMetaData addTagValue:dateTime forKey:[NSNumber numberWithInt:EXIF_DateTimeOriginal]];
   [jpegScanner.exifMetaData addTagValue:dateTime forKey:[NSNumber numberWithInt:EXIF_DateTimeDigitized]];
   [jpegScanner.exifMetaData addTagValue:VALUE_OF_EXIF_MAKE forKey:[NSNumber numberWithInt:EXIF_Make]];
   [jpegScanner.exifMetaData addTagValue:VALUE_OF_EXIF_MODEL forKey:[NSNumber numberWithInt:EXIF_Model]];

   if(use_gps) {
      // adding GPS data to the Exif object
      NSMutableArray *latiArray = [self createLocArray:location.coordinate.latitude];
      NSMutableArray *longArray = [self createLocArray:location.coordinate.longitude];
      EXFGPSLoc *latiLoc = [[EXFGPSLoc alloc] init];
      EXFGPSLoc *longLoc = [[EXFGPSLoc alloc] init];
      [self populateGPS:latiLoc array:latiArray];
      [self populateGPS:longLoc array:longArray];

      NSString *latiRef = (location.coordinate.latitude < 0.0) ? @"S" : @"N";
      NSString *longRef = (location.coordinate.longitude < 0.0) ? @"W" : @"E";
      [jpegScanner.exifMetaData addTagValue:latiLoc forKey:[NSNumber numberWithInt:EXIF_GPSLatitude]];
      [jpegScanner.exifMetaData addTagValue:latiRef forKey:[NSNumber numberWithInt:EXIF_GPSLatitudeRef]];
      [jpegScanner.exifMetaData addTagValue:longLoc forKey:[NSNumber numberWithInt:EXIF_GPSLongitude]];
      [jpegScanner.exifMetaData addTagValue:longRef forKey:[NSNumber numberWithInt:EXIF_GPSLongitudeRef]];

      // GPS Version
      NSArray *gpsVersion = [NSArray arrayWithObjects: [NSNumber numberWithChar:2], [NSNumber numberWithChar:2],
                             [NSNumber numberWithChar:0], [NSNumber numberWithChar:0], nil];
      [jpegScanner.exifMetaData addTagValue:gpsVersion forKey:[NSNumber numberWithInt:EXIF_GPSVersion]];

      [latiLoc release];
      [latiArray release];
      [longLoc release];
      [longArray release];
   }

   NSMutableData *newData = [[[NSMutableData alloc] init] autorelease];
   [jpegScanner populateImageData:newData];
   [jpegScanner release];

   return newData;
}

- (void)locationManager:(CLLocationManager*)manager
        didUpdateToLocation:(CLLocation*)newLocation
                fromLocation:(CLLocation*)oldLocation {
   [location release];
   location = nil;
   location = [newLocation retain];
}

- (NSMutableArray*) createLocArray:(double)val {
   val = fabs(val);
   NSMutableArray* array = [[NSMutableArray alloc] init];
   double deg = (int)val;
   [array addObject:[NSNumber numberWithDouble:deg]];
   val = val - deg;
   val = val*60;
   double minutes = (int) val;
   [array addObject:[NSNumber numberWithDouble:minutes]];
   val = val - minutes;
   val = val *60;
   double seconds = val;
   [array addObject:[NSNumber numberWithDouble:seconds]];
   return array;
}

- (void) populateGPS:(EXFGPSLoc*)gpsLoc array:(NSArray*)locArray {
   long numDenumArray[2];
   long* arrPtr = numDenumArray;
   [EXFUtils convertRationalToFraction:&arrPtr :[locArray objectAtIndex:0]];
   EXFraction* fract = [[EXFraction alloc] initWith:numDenumArray[0] :numDenumArray[1]];
   gpsLoc.degrees = fract;
   [fract release];
   [EXFUtils convertRationalToFraction:&arrPtr :[locArray objectAtIndex:1]];
   fract = [[EXFraction alloc] initWith:numDenumArray[0] :numDenumArray[1]];
   gpsLoc.minutes = fract;
   [fract release];
   [EXFUtils convertRationalToFraction:&arrPtr :[locArray objectAtIndex:2]];
   fract = [[EXFraction alloc] initWith:numDenumArray[0] :numDenumArray[1]];
   gpsLoc.seconds = fract;
   [fract release];
}

#endif

@end
