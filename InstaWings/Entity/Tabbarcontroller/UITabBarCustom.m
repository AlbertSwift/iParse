//
//  UITabBarCustom.m
//  iOSCodeStructure
//
//  Created by Nishant
//  Copyright (c) 2013 Nishant. All rights reserved.
//

#import "UITabBarCustom.h"
#import "AppDelegate.h"
@class AppDelegate;
@interface UITabBarCustom ()
{
    UINavigationController * navController;
}
@end

@implementation UITabBarCustom
@synthesize btnTab1, btnTab2, btnTab3, btnTab4,btnTab5;
@synthesize imgTabBg;
#pragma mark - This is the main Tabbar in the Application
#pragma mark - View Life Cycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    HeightTabbar=44;
    noOfTab=3;
    appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self addCustomElements];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideOriginalTabBar];
}
#pragma mark - Hide Original TabBar - Add Custom TabBar
- (void)hideOriginalTabBar
{
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            view.hidden = YES;
            break;
        }
    }
}
-(void)addCustomElements
{
    //Add Bg Image
    if(imgTabBg != nil)
    {
        [imgTabBg removeFromSuperview];
    }
    
    self.headerview = [self loadViewNib:@"HeaderView"];
    [self.headerview.btnback addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerview.btnCoin addTarget:self action:@selector(btnCoinClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.headerview];
    
    float y = [UIScreen mainScreen].bounds.size.height-HeightTabbar;
    float w = [UIScreen mainScreen].bounds.size.width;
    bottom_view=[[UIView alloc] initWithFrame:CGRectMake(0,y,w,HeightTabbar)];
    imgTabBg = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,w,HeightTabbar)];
    imgTabBg.backgroundColor=[[Singleton sharedSingleton] colorFromHexString:@"#CD2228"];
    
    [self.view addSubview:bottom_view];

    [bottom_view addSubview:imgTabBg];
    y_position=0;
    btn_y_position=00;
    btn_x_position=0;
    btn_width=w/noOfTab;
    btn_height=HeightTabbar;
    [self addAllElements];
}
-(void)addAllElements
{
    //Add Tab Buttons
    if(btnTab1 != nil)
        [btnTab1 removeFromSuperview];
    if (btnTab2 != nil)
        [btnTab2 removeFromSuperview];
    if(btnTab3 != nil)
        [btnTab3 removeFromSuperview];
    if (btnTab4 != nil)
        [btnTab4 removeFromSuperview];
    if (btnTab5 != nil)
        [btnTab5 removeFromSuperview];
    
    btnTab1 = [self getGeneralTabButton:0 isSelected:true];
    btnTab2 = [self getGeneralTabButton:1 isSelected:false];
    btnTab3 = [self getGeneralTabButton:2 isSelected:false];
    btnTab4 = [self getGeneralTabButton:3 isSelected:false];
    btnTab5 = [self getGeneralTabButton:4 isSelected:false];
    
    [bottom_view addSubview:btnTab1];
    [bottom_view addSubview:btnTab2];
    [bottom_view addSubview:btnTab3];
    [bottom_view addSubview:btnTab4];
    [bottom_view addSubview:btnTab5];
    
    // Setup event handlers so that the buttonClicked method will respond to the touch up inside event.
    [btnTab1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    [btnTab2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    [btnTab3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    [btnTab4 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    [btnTab5 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
}

-(UIButton *)getGeneralTabButton:(int)pintTag isSelected:(BOOL)pbolIsSelected
{
    UIImage *btnImage;
    UIImage *btnImageSelected;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTag:pintTag];
    [btn setSelected:pbolIsSelected];
    switch (pintTag) {
        case 0:	//Tab-1
            btnImage = [UIImage imageNamed:@"tab1.png"];
            btnImageSelected = [UIImage imageNamed:@"home_selected.png"];
            btn.frame = CGRectMake(btn_x_position,btn_y_position, btn_width, btn_height);
            [btn setTitle:@"GET COINS" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = CustomFontBoldWithSize(10);
            btn.imageEdgeInsets = UIEdgeInsetsMake(-15, (btn.frame.size.width/2)- 5, 0, 0);
            btn.titleEdgeInsets =UIEdgeInsetsMake(20, 0, 0, 0);
            break;
        case 1:	//Tab-2
            btnImage = [UIImage imageNamed:@"tab2.png"];
            btnImageSelected = [UIImage imageNamed:@"search_selected.png"];
            btn.frame = CGRectMake(btn_x_position+btn_width, btn_y_position, btn_width, btn_height);
            [btn setTitle:@"GET LIKES" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = CustomFontBoldWithSize(10);
            btn.imageEdgeInsets = UIEdgeInsetsMake(-15, (btn.frame.size.width/2)- 5, 0, 0);
            btn.titleEdgeInsets =UIEdgeInsetsMake(20, 0, 0, 0);
            
            break;
        case 2:	//Tab-3
            btnImage = [UIImage imageNamed:@"tab3.png"];
            btnImageSelected = [UIImage imageNamed:@"add_selected.png"];
            btn.frame = CGRectMake(btn_x_position+(btn_width*2), btn_y_position, btn_width+10, btn_height);
            [btn setTitle:@"GET FOLLOWERS" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = CustomFontBoldWithSize(10);
            btn.imageEdgeInsets = UIEdgeInsetsMake(-15, (btn.frame.size.width/2)- 10, 0, 0);
            btn.titleEdgeInsets =UIEdgeInsetsMake(20, -25, 0, 0);
            break;
        case 3:	//Tab-4
            btnImage = [UIImage imageNamed:@"chain.png"];
            btnImageSelected = [UIImage imageNamed:@"chain_selected.png"];
            btn.frame = CGRectMake(btn_x_position+(btn_width*3), btn_y_position, btn_width, btn_height);
            break;
        default://Tab-1
            btnImage = [UIImage imageNamed:@"man.png"];
            btnImageSelected = [UIImage imageNamed:@"man_selected.png"];
            btn.frame = CGRectMake(btn_x_position+(btn_width*4), btn_y_position, btn_width, btn_height);
            break;
    }
    
    [btn setImage:btnImage forState:UIControlStateNormal];
    [btn setImage:btnImageSelected forState:UIControlStateSelected];
    return btn;
}

#pragma mark - Select Tab
- (void)buttonClicked:(id)sender
{
    int tagNum =(int)[sender tag];
    [self selectTab:tagNum];
}
- (void)selectTab:(int)tabID
{
    switch(tabID)
    {
        case 0:
            [btnTab1 setSelected:true];
            [btnTab2 setSelected:false];
            [btnTab3 setSelected:false];
            [btnTab4 setSelected:false];
            [btnTab5 setSelected:false];
            break;
        case 1:
            [btnTab1 setSelected:false];
            [btnTab2 setSelected:true];
            [btnTab3 setSelected:false];
            [btnTab4 setSelected:false];
            [btnTab5 setSelected:false];
            break;
        case 2:
            [btnTab1 setSelected:false];
            [btnTab2 setSelected:false];
            [btnTab3 setSelected:true];
            [btnTab4 setSelected:false];
            [btnTab5 setSelected:false];
            break;
        case 3:
            [btnTab1 setSelected:false];
            [btnTab2 setSelected:false];
            [btnTab3 setSelected:false];
            [btnTab4 setSelected:true];
            [btnTab5 setSelected:false];
            break;
        case 4:
            [btnTab1 setSelected:false];
            [btnTab2 setSelected:false];
            [btnTab3 setSelected:false];
            [btnTab4 setSelected:false];
            [btnTab5 setSelected:true];
            break;
            
    }
    
    self.selectedIndex = tabID;
    if (self.selectedIndex == tabID)
    {
        if (appDelegate.isPopToAllView==FALSE){
            navController = (UINavigationController *)[self selectedViewController];
            [navController popToRootViewControllerAnimated:YES];
        }
        else{
            navController = (UINavigationController *)[self selectedViewController];
            [navController popToRootViewControllerAnimated:YES];
        }
    }else{
        self.selectedIndex = tabID;
    }
}
#pragma mark - Show/Hide TabBar
- (void)showTabBar
{
    self.imgTabBg.hidden = NO;
    self.btnTab1.hidden = NO;
    self.btnTab2.hidden = NO;
    self.btnTab3.hidden = NO;
    self.btnTab4.hidden = NO;
    self.btnTab5.hidden = NO;
    self.btnTab1.userInteractionEnabled=YES;
    self.btnTab2.userInteractionEnabled=YES;
    self.btnTab3.userInteractionEnabled=YES;
    self.btnTab4.userInteractionEnabled=YES;
    self.btnTab5.userInteractionEnabled=YES;
}
- (void)hideTabBar
{
    self.imgTabBg.hidden = YES;
    self.btnTab1.hidden = YES;
    self.btnTab2.hidden = YES;
    self.btnTab3.hidden = YES;
    self.btnTab4.hidden = YES;
    self.btnTab5.hidden = YES;
    self.btnTab1.userInteractionEnabled=NO;
    self.btnTab2.userInteractionEnabled=NO;
    self.btnTab3.userInteractionEnabled=NO;
    self.btnTab4.userInteractionEnabled=NO;
    self.btnTab5.userInteractionEnabled=NO;
}
#pragma mark -Load Nib
- (id)loadViewNib:(NSString *)nibName {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    if([nibs count] > 0) {
        return [nibs objectAtIndex:0];
    }
    return nil;
}
#pragma mark- player delegate method
-(void)pushSettingView
{
//test
}
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"outputVolume"]) {
        NSLog(@"volume changed!");

    }
}

-(IBAction)btnBackClick:(id)sender{
    [navController popViewControllerAnimated:YES];
}

-(IBAction)btnCoinClick:(id)sender{
    
    
    if(![navController.topViewController isKindOfClass:[InAPPVC class]]) {
        NSArray *ary=navController.viewControllers;
        int i=0;
        BOOL isFound=NO;
        for (UIViewController *vc in ary) {
            if (vc.class == [InAPPVC class]) {
                isFound=YES;
                break;
            }
            i++;
        }
        if (!isFound) {
            InAPPVC *inappObj =[[InAPPVC alloc] initWithNibName:@"InAPPVC" bundle:nil];
            [navController pushViewController:inappObj animated:YES];
        }
    }

    
    
}
@end
