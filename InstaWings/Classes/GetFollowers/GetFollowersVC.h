//
//  GetFollowersVC.h
//  InstaWings
//
//  Created by Tops on 9/11/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "HeaderView.h"
#import "GetFollowersCustomCell.h"
@class AppDelegate;
@interface GetFollowersVC : UIViewController{
    AppDelegate *appDel;
    IBOutlet HeaderView *hview;
    IBOutlet UITableView *tblView;
    NSMutableArray *aryInApp;
}


@end
