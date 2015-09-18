//
//  GetCoinsVC.h
//  InstaWings
//
//  Created by Tops on 9/11/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HeaderView.h"
@class AppDelegate;
@interface GetCoinsVC : UIViewController{
    AppDelegate *appDel;
   IBOutlet HeaderView *hview;
    IBOutlet UIImageView *imgProfileView;
    IBOutlet UILabel *lblProfileName;
    IBOutlet UIImageView *imgLike;
    NSMutableArray *aryLike;
    NSMutableArray *aryFollow;
    int currentIndex;
    IBOutlet UIView *viewProfile;
    IBOutlet UIView *viewLike;
    IBOutlet UILabel *lblNoMedia;
    IBOutlet UIButton *btnLike;
    IBOutlet UIButton *btnFollow;
    IBOutlet UIButton *btnLikeFOllow;
    NSMutableDictionary *likeDic;
    NSMutableDictionary *FollowDic;
}

@end
