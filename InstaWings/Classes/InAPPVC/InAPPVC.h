//
//  InAPPVC.h
//  InstaWings
//
//  Created by Tops on 9/11/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAPPCustomCell.h"
#import "AppDelegate.h"
@class AppDelegate;
@interface InAPPVC : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    AppDelegate *appDel;
    IBOutlet UITableView *tblView;
    NSMutableArray *aryInApp;
    IBOutlet UIButton *btnLogout;
}

@end
