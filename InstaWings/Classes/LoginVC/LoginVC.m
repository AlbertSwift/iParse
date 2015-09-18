//
//  LoginVC.m
//  InstaWings
//
//  Created by Tops on 9/11/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //NSURL *authURL = [[InstagramEngine sharedEngine] authorizarionURL];

    //use this static url because multiple scope not supprt this library so....
    
    NSURL *authURL = [NSURL URLWithString:@"https://api.instagram.com/oauth/authorize/?client_id=a495e8b368e94dcba24b8f5e5023397c&redirect_uri=http://localhost/instapromo/Instagram-PHP-API-master/success.php&response_type=code&scope=relationships+likes"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:authURL]];
    appDel =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.hview hideHeader];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *URLString = [request.URL absoluteString];
    if ([URLString hasPrefix:[[InstagramEngine sharedEngine] appRedirectURL]]) {
        NSString *delimiter = @"code=";
        NSArray *components = [URLString componentsSeparatedByString:delimiter];
        if (components.count > 1) {
            
            NSString *code = [components lastObject];
            [self tokenCall:code];
        }
    }
    return YES;
}

-(void) tokenCall:(NSString *)code
{
    NSString *url=@"https://api.instagram.com/oauth/access_token";
    
    NSDictionary *parameters = @{
                                 @"grant_type":@"authorization_code",
                                 @"client_id":[InstagramEngine sharedEngine].appClientID,
                                 @"client_secret":[InstagramEngine sharedEngine].appSecretKey,
                                 @"redirect_uri":[InstagramEngine sharedEngine].appRedirectURL,
                                 @"code":code,
                                 };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
     //  NSLog(@"%@",responseObject);
        NSMutableDictionary *userData = [responseObject objectForKey:@"user"];
        [InstagramEngine sharedEngine].accessToken =[responseObject objectForKey:@"access_token"];
        [[InstagramEngine sharedEngine] setAccessToken:[responseObject objectForKey:@"access_token"]];
        [self callLoginWs:userData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}


-(void)callLoginWs:(NSMutableDictionary *)UserData{
    
    NSMutableDictionary *param =[[NSMutableDictionary alloc] init];
    [param setObject:[UserData valueForKey:@"id"] forKey:@"insta_user_id"];
    [param setObject:[UserData valueForKey:@"username"] forKey:@"username"];
    [param setObject:[UserData valueForKey:@"full_name"] forKey:@"full_name"];
    [param setObject:[UserData valueForKey:@"profile_picture"] forKey:@"img_url"];
    
    [[WebserviceCaller sharedSingleton] BaseWsCallPOST:param :@"user/user_registration" success:^(id responseData) {
     
        NSMutableDictionary *userInfo =[responseData objectForKey:@"user_details"];

        [[Singleton sharedSingleton] setUserDefault:[userInfo objectForKey:@"id"] :USERID];
        [[Singleton sharedSingleton] setUserDefault:[userInfo objectForKey:@"insta_user_id"] :USERINSTAID];
        [[Singleton sharedSingleton] setUserDefault:[userInfo objectForKey:@"insta_username"] :USERNAME];
        [[Singleton sharedSingleton] setUserDefault:[userInfo objectForKey:@"insta_full_name"] :USERFULLNAME];
        [[Singleton sharedSingleton] setUserDefault:[userInfo objectForKey:@"insta_img_url"] :USERIMAGEURL];
        [[Singleton sharedSingleton] setUserDefault:[userInfo objectForKey:@"total_coin_count"] :USERTOTALCOIN];
        [appDel.objCustomTabBar.headerview updateCoin:[userInfo objectForKey:@"total_coin_count"]];
        [appDel gotoDetailApp:0];

       [self.navigationController pushViewController:appDel.objCustomTabBar animated:YES];

    } Failure:^(id responseData) {
        [[WebserviceCaller sharedSingleton] AjNotificationView:[responseData objectForKey:@"MESSAGE"] :AJNotificationTypeRed];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnBackClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
