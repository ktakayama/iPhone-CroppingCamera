//
//  CCInfoViewController.h
//  CroppingCamera
//
//  Created by Kyosuke Takayama on 09/08/25.
//  Copyright Kyosuke Takayama 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
   UIImage *preview;
   UIImageView *previewView;
   NSArray *apps;
}

- (IBAction) launchCamera;

- (UITableViewCell *) tableView:(UITableView *)aTableView previewCellForRow:(NSInteger)row;
- (UITableViewCell *) tableView:(UITableView *)aTableView prefsCellForRow:(NSInteger)row;
- (UITableViewCell *) tableView:(UITableView *)aTableView appsCellForRow:(NSInteger)row;

@end

