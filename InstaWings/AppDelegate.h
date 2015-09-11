//
//  AppDelegate.h
//  InstaWings
//
//  Created by Tops on 9/11/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITabBarCustom.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, readonly) int networkStatus;
@property (nonatomic) BOOL isPopToAllView;
@property (nonatomic, retain) UITabBarCustom *objCustomTabBar;


#pragma mark-tab bar controller
-(void)gotoDetailApp:(int)pintTabId;
-(void)hidetabar;
-(void)Showtabar;
-(void)tabbarselectindex:(int)index;

@end

