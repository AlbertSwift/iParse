//
//  Singleton.h
//  InstagramApp
//
//  Created by ;; on 15/02/13.
//  Copyright (c) 2013 WebPlanex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppDelegate;
@interface Singleton : NSObject {
    int currentSelectedTab;
    AppDelegate *appDel;
    NSMutableArray *aryAdFullScreen;
    NSMutableArray *aryAdSidebar;
}

@property (nonatomic, assign) int currentSelectedTab;
@property (nonatomic,assign) int isHomeRefresh;
@property (nonatomic,assign) int isCurrentSliderTouch;
@property (nonatomic,retain) NSMutableArray *myPlaylist;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic,assign) int currentViebMoreClick;
@property (nonatomic,assign) int currentTrackMoreClick;


+ (Singleton *)sharedSingleton;

-(void)setcurrentSelectedTab:(int)myString;
-(int)getcurrentSelectedTab;
-(NSString *)getUserDefault:(NSString *)pref;
-(void)setUserDefault:(NSString *)myString :(NSString *)pref;
-(void)AjNotificationView :(NSString *)title :(int)AJNotificationType;
-(NSMutableAttributedString *)CreateAttributeStringStartEnd :(int)FontSize :(NSString *)text :(int)startString :(int)endString :(UIColor *)color anothercolor:(UIColor *)othercolor;

- (CGSize)getSizeFromString :(NSString *)message width:(float)width fontName:(UIFont *)fontName;
- (NSString *)removeNull:(NSString *)str;
- (UIColor *) colorFromHexString:(NSString *)hexString;


@end
