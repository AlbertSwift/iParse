//
//  LoginVC.h
//  InstaWings
//
//  Created by Tops on 9/11/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class AppDelegate;
@interface LoginVC : UIViewController<UIWebViewDelegate>{
    AppDelegate *appDel;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
