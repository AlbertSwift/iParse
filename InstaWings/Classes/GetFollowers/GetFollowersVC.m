//
//  GetFollowersVC.m
//  InstaWings
//
//  Created by Tops on 9/11/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import "GetFollowersVC.h"

@interface GetFollowersVC ()

@end

@implementation GetFollowersVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [appDel.objCustomTabBar.headerview changeTitle:@"Get Followers"];
    [appDel.objCustomTabBar.headerview.btnRefrsh setHidden:NO];
    [appDel.objCustomTabBar.headerview.btnback setHidden:YES];
    
//    [appDel.objCustomTabBar.headerview.btnCoin removeTarget:self action:@selector(btnCoinClick:) forControlEvents:UIControlEventTouchUpInside];
//    [appDel.objCustomTabBar.headerview.btnCoin addTarget:self action:@selector(btnCoinClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Do any additional setup after loading the view from its nib.
    appDel =(AppDelegate *)[[UIApplication sharedApplication] delegate];

    aryInApp =[[NSMutableArray alloc] init];
    [aryInApp addObject:@{@"Title":@"Get 100 Followers-",@"price":@"200",@"followCount":@"100"}];
    [aryInApp addObject:@{@"Title":@"Get 200 Followers-",@"price":@"400",@"followCount":@"200"}];
    [aryInApp addObject:@{@"Title":@"Get 500 Followers-",@"price":@"600",@"followCount":@"500"}];
    [aryInApp addObject:@{@"Title":@"Get 1000 Followers-",@"price":@"1500",@"followCount":@"1000"}];
    [aryInApp addObject:@{@"Title":@"Get 2000 Followers-",@"price":@"3000",@"followCount":@"2000"}];
    [aryInApp addObject:@{@"Title":@"Get 5000 Followers-",@"price":@"6000",@"followCount":@"5000"}];
    [tblView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - table view data source & delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [aryInApp count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GetFollowersCustomCell *cell =(GetFollowersCustomCell *)[tblView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        NSArray *aryNib =[[NSBundle mainBundle] loadNibNamed:@"GetFollowersCustomCell" owner:self options:nil];
        cell = [aryNib objectAtIndex:0];
    }
    NSMutableDictionary *dict =[aryInApp objectAtIndex:indexPath.row];
    cell.lblTitle.text =[dict objectForKey:@"Title"];
    [cell.btnPurchase setTitle:[NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]] forState:UIControlStateNormal];
    cell.btnPurchase.tag =indexPath.row;
    [cell.btnPurchase addTarget:self action:@selector(btnFollowClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

-(IBAction)btnFollowClick:(id)sender{
    NSMutableDictionary *dict =[aryInApp objectAtIndex:[sender tag]];
    
    int totalCoint = [[[Singleton sharedSingleton] getUserDefault:USERTOTALCOIN] intValue];
    int requiedCOin = [[dict objectForKey:@"price"] intValue];
    if (totalCoint >= requiedCOin) {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:[[Singleton sharedSingleton] getUserDefault:USERID] forKey:@"server_user_id"];
        [param setValue:[dict objectForKey:@"price"] forKey:@"coins"];
        [param setValue:[dict objectForKey:@"followCount"] forKey:@"wanted_followers"];
        [[WebserviceCaller sharedSingleton] BaseWsCallPOST:param :@"user/get_followers" success:^(id responseData) {
            
            NSMutableDictionary *userInfo =[responseData objectForKey:@"user_details"];
            [[Singleton sharedSingleton] setUserDefault:[userInfo objectForKey:@"total_coin_count"] :USERTOTALCOIN];
            [appDel.objCustomTabBar.headerview updateCoin:[userInfo objectForKey:@"total_coin_count"]];
        } Failure:^(id responseData) {
            
        }];

    }else{
        [[WebserviceCaller sharedSingleton] AjNotificationView:@"Not Enough coin." :AJNotificationTypeRed];
    }

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
