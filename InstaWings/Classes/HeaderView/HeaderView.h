//
//  HeaderView.h
//  InstaWings
//
//  Created by Tops on 9/14/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView{
    IBOutlet UILabel *lbl;
}
@property(nonatomic,retain)IBOutlet UIButton *btnRefrsh;
@property(nonatomic,retain)IBOutlet UIButton *btnback;
@property(nonatomic,retain)IBOutlet UIButton *btnCoin;

-(void)hideHeader;
-(void)ShowHeader;
-(void)changeTitle:(NSString *)strTitle;
-(void)updateCoin:(NSString *)coin;

@end
