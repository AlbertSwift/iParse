//
//  GetLikesVC.h
//  InstaWings
//
//  Created by Tops on 9/11/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetLikesCustomCell.h"
#import "AppDelegate.h"
#import "HeaderView.h"
#import "SetLIkeVC.h"
@class AppDelegate;

@interface GetLikesVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>{

    IBOutlet UICollectionView *clnView;
    NSMutableArray *mediaArray;
    AppDelegate *appDel;
    IBOutlet HeaderView *hview;
    IBOutlet UIButton *btnAll;
    IBOutlet UIButton *btnAccomplished;
    IBOutlet UILabel *lblNoMedia;

}
@property (nonatomic, strong) InstagramPaginationInfo *currentPaginationInfo;
@end
