//
//  GetCoinsVC.m
//  InstaWings
//
//  Created by Tops on 9/11/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import "GetCoinsVC.h"

@interface GetCoinsVC ()

@end

@implementation GetCoinsVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [appDel.objCustomTabBar.headerview changeTitle:@"Get Coins"];
    [appDel.objCustomTabBar.headerview.btnRefrsh setHidden:NO];
    [appDel.objCustomTabBar.headerview.btnback setHidden:YES];
    
    [appDel.objCustomTabBar.headerview.btnRefrsh removeTarget:self  action:@selector(RefreshClick:) forControlEvents:UIControlEventTouchUpInside];
    [appDel.objCustomTabBar.headerview.btnRefrsh addTarget:self action:@selector(RefreshClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self getList];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appDel =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    imgProfileView.layer.cornerRadius = imgProfileView.layer.frame.size.width/2;
    imgProfileView.layer.masksToBounds = YES;
    imgProfileView.layer.borderWidth=3;
    imgProfileView.layer.borderColor = [[[Singleton sharedSingleton] colorFromHexString:@"#952C33"] CGColor];

    imgLike.layer.cornerRadius = 10;
    imgLike.layer.masksToBounds = YES;
    imgLike.layer.borderWidth=3;
    imgLike.layer.borderColor = [[[Singleton sharedSingleton] colorFromHexString:@"#D5D5D5"] CGColor];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getList{
    NSMutableDictionary *param =[[NSMutableDictionary alloc] init];
    [param setObject:[[Singleton sharedSingleton] getUserDefault:USERID] forKey:@"server_user_id"];
    [param setObject:[[Singleton sharedSingleton] getUserDefault:USERINSTAID] forKey:@"insta_user_id"];
    
    [[WebserviceCaller sharedSingleton] BaseWsCallPOST:param :@"user/user_photo_followers_list" success:^(id responseData) {

        aryLike =[[NSMutableArray alloc] init];
        aryLike = [[responseData objectForKey:@"photos_list"] mutableCopy];

        aryFollow =[[NSMutableArray alloc] init];
        aryFollow = [[responseData objectForKey:@"follower_list"] mutableCopy];
        currentIndex=0;
        [self updateLayout];
    } Failure:^(id responseData) {
        
    }];
}

-(void)updateLayout{
    [lblNoMedia setHidden:YES];
    [btnFollow setEnabled:YES];
    [btnLike setEnabled:YES];
    [btnLikeFOllow setEnabled:YES];

    likeDic=[[NSMutableDictionary alloc] init];
    FollowDic=[[NSMutableDictionary alloc] init];
    if ([aryFollow count] >= 1 && [aryLike count]>=1) {
        //show both
        likeDic  = [aryLike objectAtIndex:0];
        FollowDic =[aryFollow objectAtIndex:0];
        [self showLike:likeDic];
        [self showFollow:FollowDic];
        [viewLike setHidden:NO];
        [viewProfile setHidden:NO];
    }else if ([aryLike count]>=1 && [aryFollow count]<1){
        //show like
        likeDic  = [aryLike objectAtIndex:0];
        FollowDic = nil;
        [viewLike setHidden:NO];
        [viewProfile setHidden:YES];
        [self showLike:likeDic];
        [btnFollow setEnabled:NO];
        [btnLikeFOllow setEnabled:NO];
    }else if ([aryFollow count]>=1 && [aryLike count]<1){
        //show follow
        FollowDic =[aryFollow objectAtIndex:0];
        likeDic = nil;
        //[viewLike setHidden:YES];
        [imgLike setImage:[UIImage imageNamed:@"placeholder.png"]];
        [viewProfile setHidden:NO];
        [btnLike setEnabled:NO];
        [btnLikeFOllow setEnabled:NO];
        [self showFollow:FollowDic];
    }else{
        //no data
        likeDic = nil;
        FollowDic = nil;
        [viewLike setHidden:YES];
        [viewProfile setHidden:YES];
        [lblNoMedia setHidden:NO];
    }
}
-(void)showLike:(NSMutableDictionary *)dict{
    NSLog(@"%@",dict);
    __block UIImageView *temp = imgLike;
    [imgLike setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[dict objectForKey:@"instagram_img_url"]]] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        temp.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
}

-(void)showFollow:(NSMutableDictionary *)dict{
    
    lblProfileName.text = [dict objectForKey:@"insta_username"];
    __block UIImageView *temp = imgProfileView;
    [imgProfileView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[dict objectForKey:@"insta_img_url"]]] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        temp.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];
}

-(IBAction)btnSkipClick:(id)sender{

    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[Singleton sharedSingleton] getUserDefault:USERID] forKey:@"server_user_id"];
    [param setValue:[[Singleton sharedSingleton] getUserDefault:USERINSTAID] forKey:@"insta_user_id"];
    if (likeDic != nil) {
        [param setValue:[likeDic objectForKey:@"instagram_img_id"] forKey:@"insta_img_id"];
    }
    if (FollowDic != nil) {
        [param setValue:[FollowDic objectForKey:@"insta_user_id"] forKey:@"to_insta_user_id"];
        [param setValue:[FollowDic objectForKey:@"id"] forKey:@"to_server_user_id"];
    }

    [[WebserviceCaller sharedSingleton] BaseWsCallPOST:param :@"user/skip_photo_user" success:^(id responseData) {
    
        if ([aryLike count]>=1) {
            [aryLike removeObjectAtIndex:0];
        }
        if ([aryFollow count]>=1){
            [aryFollow removeObjectAtIndex:0];
        }
        
        [self updateLayout];
    
    } Failure:^(id responseData) {
    
        NSLog(@"error:%@",responseData);
    
    }];
    
}

-(IBAction)btnLikeClick:(id)sender{
    
    
     [[InstagramEngine sharedEngine] likeMedia:[likeDic objectForKey:@"instagram_img_id"] withSuccess:^(NSDictionary *serverResponse) {
         //NSLog(@"%@",serverResponse);
         NSMutableDictionary *data = [serverResponse objectForKey:@"meta"];
         NSString *code;
         if ([[data objectForKey:@"code"] isKindOfClass:[NSNumber class]]) {
             code = [(NSNumber *)[data objectForKey:@"code"] stringValue];
             
         }else{
             code =[data objectForKey:@"code"];
         }

         if ([code isEqualToString:@"200"]) {
             if (likeDic != nil) {
                 
                 NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                 [param setValue:[[Singleton sharedSingleton] getUserDefault:USERID] forKey:@"server_user_id"];
                 [param setValue:[[Singleton sharedSingleton] getUserDefault:USERINSTAID] forKey:@"insta_user_id"];
                 [param setValue:[likeDic objectForKey:@"instagram_img_id"] forKey:@"insta_img_id"];
                 [param setValue:@"5" forKey:@"coins"];
                 
                 [[WebserviceCaller sharedSingleton] BaseWsCallPOST:param :@"user/like_photo" success:^(id responseData) {
                     NSLog(@"Res:%@",responseData);
                     [[Singleton sharedSingleton] setUserDefault:[[responseData objectForKey:@"total_coin_count"] stringValue] :USERTOTALCOIN];
                     [appDel.objCustomTabBar.headerview updateCoin:[[responseData objectForKey:@"total_coin_count"] stringValue]];
                     [aryLike removeObjectAtIndex:0];
                     [self updateLayout];
                 } Failure:^(id responseData) {
                     NSLog(@"Error:%@",responseData);
                 }];
             }
         }
     } failure:^(NSError *error, NSInteger serverStatusCode) {
         NSLog(@"%@",error);
     }];
}

-(IBAction)btnFollowClick:(id)sender{
    
    [[InstagramEngine sharedEngine] followUser:[FollowDic objectForKey:@"insta_user_id"] withSuccess:^(NSDictionary *serverResponse) {
        NSLog(@"%@",serverResponse);
        NSMutableDictionary *data = [serverResponse objectForKey:@"meta"];
        NSString *code;
        if ([[data objectForKey:@"code"] isKindOfClass:[NSNumber class]]) {
            code = [(NSNumber *)[data objectForKey:@"code"] stringValue];
            
        }else{
            code =[data objectForKey:@"code"];
        }
        
        if ([code isEqualToString:@"200"]) {
            if (FollowDic != nil) {
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [param setValue:[[Singleton sharedSingleton] getUserDefault:USERID] forKey:@"from_server_user_id"];
                [param setValue:[[Singleton sharedSingleton] getUserDefault:USERINSTAID] forKey:@"from_insta_user_id"];
                [param setValue:[FollowDic objectForKey:@"insta_user_id"] forKey:@"to_insta_user_id"];
                [param setValue:[FollowDic objectForKey:@"id"] forKey:@"to_server_user_id"];
                
                [param setValue:@"5" forKey:@"coins"];
                
                [[WebserviceCaller sharedSingleton] BaseWsCallPOST:param :@"user/follow_user" success:^(id responseData) {
                    [[Singleton sharedSingleton] setUserDefault:[[responseData objectForKey:@"total_coin_count"] stringValue] :USERTOTALCOIN];
                    [appDel.objCustomTabBar.headerview updateCoin:[[responseData objectForKey:@"total_coin_count"] stringValue]];
                    
                    [aryFollow removeObjectAtIndex:0];
                    [self updateLayout];
                    
                } Failure:^(id responseData) {
                    NSLog(@"Error:%@",responseData);
                }];

            }
        }
        
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        NSLog(@"%@",error);
    }];

    
    
    
}

-(IBAction)btnLikePlusFollow:(id)sender{
    [btnLike sendActionsForControlEvents:UIControlEventTouchUpInside];
    [btnFollow sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}

-(IBAction)RefreshClick:(id)sender{
    [self getList];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [appDel.objCustomTabBar.headerview.btnRefrsh removeTarget:self  action:@selector(RefreshClick:) forControlEvents:UIControlEventTouchUpInside];
    [super viewWillDisappear:animated];
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
