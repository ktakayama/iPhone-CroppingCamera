//
//  CCCameraViewController.m
//  CroppingCamera
//
//  Created by Kyosuke Takayama on 09/08/25.
//  Copyright 2009 Kyosuke Takayama. All rights reserved.
//

#import "CCCameraViewController.h"
#import "ALPreferences.h"

#define  RECT_OF_TOOLBAR CGRectMake(  0,   0, 320,  50)

@implementation CCCameraViewController

- (void) dealloc {
   [writer release];
   [super dealloc];
}

- (void) viewDidLoad {
   [super viewDidLoad];

   if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
      self.sourceType = UIImagePickerControllerSourceTypeCamera;
#if TARGET_IPHONE_SIMULATOR
   else self.view = [[[UIView alloc] init] autorelease];
   [[UIApplication sharedApplication] setStatusBarHidden:YES];
   UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
   btn.frame = CGRectMake(0,420,100,60);
   btn.backgroundColor = [UIColor blackColor];
   [btn setTitle:@"close" forState:UIControlStateNormal];
   [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
   [self.view addSubview:btn];
#endif
   self.delegate = self;
   self.allowsImageEditing = YES;

   ALPreferences *pref;
   pref = [ALPreferences prefForKey:ALPFKeyGPS];
   writer = [[ALImageWriter alloc] initWithDelegate:self];
   writer.use_gps = pref.data;
   [writer updateLocation];
}

- (void) imagePickerController:(UIImagePickerController *)picker
      didFinishPickingMediaWithInfo:(NSDictionary *)info {

   UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
   [self.view addSubview:act];
   act.center = CGPointMake(160, 240);
   [act startAnimating];
   [act release];

   UILabel *save = [[UILabel alloc] initWithFrame:CGRectMake(130, 270, 80, 20)];
   save.text = @"saving...";
   save.textColor = [UIColor grayColor];
   save.backgroundColor = [UIColor clearColor];
   [self.view addSubview:save];
   [save release];

   UIImage *image = [self filter:[info objectForKey:UIImagePickerControllerEditedImage]];
   [writer writeToSavedPhotosAlbum:image];
}

- (UIImage *) filter:(UIImage *)image {
   ALPreferences *pref = [ALPreferences prefForKey:ALPFKeyGrayScale];
   if(!pref.data) return image;

   UIGraphicsBeginImageContext(image.size);

   CGRect frame = CGRectMake(0,0,image.size.width,image.size.height);
   [[UIImage imageNamed:@"black.png"] drawInRect:frame blendMode:kCGBlendModeNormal alpha:1.0f];
   [image drawAtPoint:CGPointZero blendMode:kCGBlendModeLuminosity alpha:1.0f];

   UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();

   return result;
}

- (void) close {
#if TARGET_IPHONE_SIMULATOR
   int i = rand()%3;
   UIImage *update;
   switch(i) {
      case 0:
         update = [UIImage imageNamed:@"Icon.png"];
         break;
      case 1:
         update = [UIImage imageNamed:@"EasyCamera.png"];
         break;
      case 2:
         update = [UIImage imageNamed:@"ShadowCamera.png"];
         break;
   }
   [self.parentViewController updatePreview:[self filter:update]];
#endif
   [self dismissModalViewControllerAnimated:YES];
}

- (void) ALImageWriterDidFail:(ALImageWriter *)sender error:(NSError *)error {
   [self dismissModalViewControllerAnimated:YES];
}

- (void) ALImageWriterDidSucceed:(ALImageWriter *)sender image:(UIImage *)image {
   [self.parentViewController updatePreview:image];
   [self dismissModalViewControllerAnimated:YES];
}

@end
