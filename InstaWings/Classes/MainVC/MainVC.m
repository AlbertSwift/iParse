//
//  MainVC.m
//  InstaWings
//
//  Created by Tops on 9/11/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // NSLog(@"%@",[InstagramEngine sharedEngine].accessToken);
    if ([InstagramEngine sharedEngine].accessToken) {
        [self.navigationController pushViewController:appDel.objCustomTabBar animated:NO];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     appDel =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.hview hideHeader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)btnLoginClick:(id)sender{
    
    LoginVC *loginobj =[[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
    [self.navigationController pushViewController:loginobj animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
