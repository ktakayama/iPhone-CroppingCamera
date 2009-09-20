//
//  CCInfoViewController.m
//  CroppingCamera
//
//  Created by Kyosuke Takayama on 09/08/25.
//  Copyright Kyosuke Takayama 2009. All rights reserved.
//

#import "CCInfoViewController.h"
#import "CCCameraViewController.h"
#import "CCImagePreviewCell.h"
#import "CCPrefsCell.h"
#import "CCAppsCell.h"
#import "ALApps.h"
#import "ALPreferences.h"
#import "ALImageWriter.h"

@implementation CCInfoViewController

- (void) dealloc {
   [preview release];
   [apps release];
   [super dealloc];
}

- (void) viewDidLoad {
   [super viewDidLoad];

   apps = [[ALApps apps] retain];
}

- (void) viewWillAppear:(BOOL)animated {
   [super viewWillAppear:animated];
   previewView.image = preview;
}

- (void) updatePreview:(UIImage *)image {
   [preview release];
   preview = [image retain];
}

- (IBAction) launchCamera {
   CCCameraViewController *camera = [[CCCameraViewController alloc] init];
   [self presentModalViewController:camera animated:NO];
   [camera release];
}

/* テーブル表示 */
- (NSInteger) numberOfSectionsInTableView:(UITableView *)aTableView {
   return 3;
}

- (NSInteger) tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
   switch(section) {
      case 0:
         return 1;
      case 1:
         return ([ALImageWriter canWriteExif]) ? 2 : 1;
      case 2:
         return [apps count];
   }
   return 0;
}

- (NSString *) tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
   switch(section) {
      case 0:
         return @"Preview";
      case 1:
         return @"Preferences";
      case 2:
         return @"My Apps";
   }
   return 0;
}

- (CGFloat) tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return (indexPath.section == 0) ? 280 : 44;
}

- (UITableViewCell *) tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   switch(indexPath.section) {
      case 0:
         return [self tableView:aTableView previewCellForRow:indexPath.row];
      case 1:
         return [self tableView:aTableView prefsCellForRow:indexPath.row];
      case 2:
         return [self tableView:aTableView appsCellForRow:indexPath.row];
   }
   return nil;
}

- (UITableViewCell *) tableView:(UITableView *)aTableView previewCellForRow:(NSInteger)row {
   static NSString *CellIdentifier = @"previewCell";
   CCImagePreviewCell *cell = (CCImagePreviewCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
   if (cell == nil) {
      cell = [[[CCImagePreviewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
   }
   previewView = cell.preview;
   previewView.image = preview;
   return cell;
}

- (UITableViewCell *) tableView:(UITableView *)aTableView prefsCellForRow:(NSInteger)row {
   static NSString *CellIdentifier = @"prefsCell";
   CCPrefsCell *cell = (CCPrefsCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
   if (cell == nil) {
      cell = [[[CCPrefsCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
   }

   switch(row) {
      case 0:
         cell.key = ALPFKeyGrayScale;
         cell.title.text = @"Gray Scale";
         break;
      case 1:
         cell.key = ALPFKeyGPS;
         cell.title.text = @"Enable GPS";
         break;
   }

   return cell;
}

- (UITableViewCell *) tableView:(UITableView *)aTableView appsCellForRow:(NSInteger)row {
   static NSString *CellIdentifier = @"appsCell";
   CCAppsCell *cell = (CCAppsCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
   if (cell == nil) {
      cell = [[[CCAppsCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
   }
   cell.app = [apps objectAtIndex:row];
   return cell;
}

- (void) tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   [aTableView deselectRowAtIndexPath:indexPath animated:YES];
   if(indexPath.section != 2) return;

   ALApps *app = [apps objectAtIndex:indexPath.row];
   [app openStore];
}

@end
