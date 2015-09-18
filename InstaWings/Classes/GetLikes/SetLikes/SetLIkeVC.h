//
//  SetLIkeVC.h
//  InstaWings
//
//  Created by Tops on 9/15/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class AppDelegate;

@interface SetLIkeVC : UIViewController{
    AppDelegate *appDel;
    IBOutlet UIImageView *imgLike;
    IBOutlet UIButton *btnhes;
    IBOutlet UIButton *btnSet;
    IBOutlet UISlider *sld;
    IBOutlet UILabel *lblCoin;
}
@property(nonatomic,retain)InstagramMedia *mediaInfo;

@end
