//
//  HeaderView.m
//  InstaWings
//
//  Created by Tops on 9/14/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView
@synthesize btnCoin;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    btnCoin.layer.cornerRadius =8;
    btnCoin.titleLabel.adjustsFontSizeToFitWidth = YES;
    CGRect frame = self.frame;
    frame.size.width =[UIScreen mainScreen].bounds.size.width;
    self.frame = frame;
    [btnCoin setTitle:[[Singleton sharedSingleton]getUserDefault:USERTOTALCOIN] forState:UIControlStateNormal];
}


-(void)hideHeader{
    [self setHidden:YES];
}

-(void)ShowHeader{
    [self setHidden:NO];
    
}
-(void)changeTitle:(NSString *)strTitle{
    lbl.text = strTitle;
}
-(void)updateCoin:(NSString *)coin{
    [btnCoin setTitle:coin forState:UIControlStateNormal];
}


@end
