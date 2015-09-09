//
//  HomeVC.m
//  Instagram_parse
//
//  Created by Tops on 9/4/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *authURL = [[InstagramEngine sharedEngine] authorizarionURL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:authURL]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    NSString *URLString = [request.URL absoluteString];
    NSLog(@"%@",URLString);
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
        NSLog(@"%@",responseObject);
        
        [InstagramEngine sharedEngine].accessToken =[responseObject objectForKey:@"access_token"];
        [[InstagramEngine sharedEngine] setAccessToken:[responseObject objectForKey:@"access_token"]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
