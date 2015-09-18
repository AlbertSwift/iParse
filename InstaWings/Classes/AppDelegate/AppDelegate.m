//
//  AppDelegate.m
//  InstaWings
//
//  Created by Tops on 9/11/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import "AppDelegate.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "NSData+Conversion.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize navController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MainVC *mainObj =[[MainVC alloc] initWithNibName:@"MainVC" bundle:nil];
    navController = [[UINavigationController alloc] initWithRootViewController:mainObj];
    
    [navController.navigationBar setHidden:YES];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    self.isPopToAllView = 0;
    [self gotoDetailApp:0];
    [self tabbarselectindex:0];
    //[self getheaderData];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
   // [self.window addSubview:self.hview];
    
    if(![IAPShare sharedHelper].iap) {
        NSSet* dataSet = [[NSSet alloc] initWithObjects:@"com.tops.audioapp.audio1",@"com.tops.audioapp.audio2", nil];
        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
        
    }
    
    [IAPShare sharedHelper].iap.production = NO;
    
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
      
     }];
    /*
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
    */
     
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark- custom tab bar
-(void)gotoDetailApp:(int)pintTabId{
    [self setTabBar];
    self.objCustomTabBar.delegate=self;
    //  [self.navController pushViewController:self.objCustomTabBar animated:YES];
    [self.objCustomTabBar setSelectedIndex:pintTabId];
    [self.objCustomTabBar selectTab:pintTabId];
}


-(void)setTabBar
{
    
    //Note: Use this method and respective variables when there is TabBar in the app.
    self.objCustomTabBar=[[UITabBarCustom alloc]init];
    // first
    HomeVC *homeObj =[[HomeVC alloc] initWithNibName:@"HomeVC" bundle:Nil];
    UINavigationController *navHome = [[UINavigationController alloc] initWithRootViewController:homeObj];
    
    GetCoinsVC *getCoinobj = [[GetCoinsVC alloc] initWithNibName:@"GetCoinsVC" bundle:nil];
    UINavigationController *navCoin =[[UINavigationController alloc] initWithRootViewController:getCoinobj];
    [navCoin.navigationBar setHidden:YES];
    GetLikesVC *getlikeobj =[[GetLikesVC alloc] initWithNibName:@"GetLikesVC" bundle:nil];
    UINavigationController *navLike =[[UINavigationController alloc] initWithRootViewController:getlikeobj];
    [navLike.navigationBar setHidden:YES];
    
    GetFollowersVC *getFolloobj =[[GetFollowersVC alloc] initWithNibName:@"GetFollowersVC" bundle:nil];
    UINavigationController *navFollow =[[UINavigationController alloc] initWithRootViewController:getFolloobj];
    [navFollow.navigationBar setHidden:YES];

    self.objCustomTabBar.viewControllers =@[navCoin,navLike,navFollow];
   [navHome setNavigationBarHidden:TRUE];
    
}

-(void)hidetabar{
    [self.objCustomTabBar hideTabBar];
}
-(void)tabbarselectindex:(int)index{
    [self.objCustomTabBar setSelectedIndex:index];
    [self.objCustomTabBar selectTab:index];
}

-(void)Showtabar{
    [self.objCustomTabBar showTabBar];
}

#pragma mark
#pragma mark-Current IP
-(NSString *)signWithKey:(NSString *)key usingData:(NSString *)data
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    return [[HMAC.description stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

-(NSString*)getheaderData
{
    NSString *ipString = [self fetchMyIP];
    NSString *signature = [self signWithKey:@"73205104225642c79df2fcb8f15452c5" usingData:ipString];
    NSLog(@"%@",[NSString stringWithFormat:@"%@|%@",ipString,signature]);
    /*[[Singleton sharedSingleton] setUserDefault:[NSString stringWithFormat:@"%@|%@",ipString,signature] :@"sign"];
    */
    
    return @"";
}

-(NSString *)fetchMyIP{
    
    NSUInteger  an_Integer;
    NSArray * ipItemsArray;
    NSString *externalIP;
    
    NSURL *iPURL = [NSURL URLWithString:@"http://www.dyndns.org/cgi-bin/check_ip.cgi"];
    
    if (iPURL) {
        NSError *error = nil;
        NSString *theIpHtml = [NSString stringWithContentsOfURL:iPURL
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
        if (!error) {
            NSScanner *theScanner;
            NSString *text = nil;
            
            theScanner = [NSScanner scannerWithString:theIpHtml];
            
            while ([theScanner isAtEnd] == NO) {
                
                // find start of tag
                [theScanner scanUpToString:@"<" intoString:NULL] ;
                
                // find end of tag
                [theScanner scanUpToString:@">" intoString:&text] ;
                
                // replace the found tag with a space
                //(you can filter multi-spaces out later if you wish)
                theIpHtml = [theIpHtml stringByReplacingOccurrencesOfString:
                             [ NSString stringWithFormat:@"%@>", text]
                                                                 withString:@" "] ;
                ipItemsArray =[theIpHtml  componentsSeparatedByString:@" "];
                an_Integer=[ipItemsArray indexOfObject:@"Address:"];
                
                externalIP =[ipItemsArray objectAtIndex:  ++an_Integer];
                
            }
            return externalIP;
            
        } else
        {
            NSLog(@"Oops... g %ld, %@",
                  (long)[error code],
                  [error localizedDescription]);
        }
        
    }
    return @"";
    
}


- (id)loadViewNib:(NSString *)nibName {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    if([nibs count] > 0) {
        return [nibs objectAtIndex:0];
    }
    return nil;
}





@end
