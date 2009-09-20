//
//  CCCameraViewController.h
//  CroppingCamera
//
//  Created by Kyosuke Takayama on 09/08/25.
//  Copyright 2009 Kyosuke Takayama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALImageWriter.h"

@interface CCCameraViewController : UIImagePickerController
            <UINavigationControllerDelegate, UIImagePickerControllerDelegate, ALImageWriterDelegate> {
   ALImageWriter *writer;
}

- (UIImage *) filter:(UIImage *)image;

- (void) close;

@end
