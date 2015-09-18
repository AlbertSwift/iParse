//
//  SetLIkeVC.m
//  InstaWings
//
//  Created by Tops on 9/15/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import "SetLIkeVC.h"

@interface SetLIkeVC ()

@end

@implementation SetLIkeVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [appDel.objCustomTabBar.headerview changeTitle:@"Get Likes"];
    [appDel.objCustomTabBar.headerview.btnRefrsh setHidden:YES];
    [appDel.objCustomTabBar.headerview.btnback setHidden:NO];
    
    imgLike.layer.cornerRadius = 10;
    imgLike.layer.masksToBounds = YES;
    imgLike.layer.borderWidth=3;
    imgLike.layer.borderColor = [[[Singleton sharedSingleton] colorFromHexString:@"#D5D5D5"] CGColor];

    btnhes.layer.cornerRadius = 5;
    btnhes.layer.masksToBounds = YES;
    
    btnSet.layer.cornerRadius = 5;
    btnSet.layer.masksToBounds = YES;
    sld.minimumValue =0;
    sld.maximumValue =[[[Singleton sharedSingleton] getUserDefault:USERTOTALCOIN] integerValue];
    
    lblCoin.text=@"0";
    [btnSet setTitle:[NSString stringWithFormat:@"Get 0 Likes"] forState:UIControlStateNormal];
    
    __block UIImageView *img = imgLike;
    [imgLike setImageWithURLRequest:[NSURLRequest requestWithURL:self.mediaInfo.standardResolutionImageURL] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        img.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     appDel =(AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SliderChange:(id)sender {
    
    int current_bal=0;
    if ((int)sld.value %2 == 0) {
        current_bal=(int)sld.value;
    }else{
        current_bal=(int)sld.value-1;
    }
    //lblCountCoin.text=[NSString stringWithFormat:@"%d",(int)sldCoin.value ];
    
    lblCoin.text=[NSString stringWithFormat:@"%d",current_bal ];
    //NSLog(@"%f",sldCoin.value)
    [btnSet setTitle:[NSString stringWithFormat:@"Get %d Likes",(int)sld.value /2] forState:UIControlStateNormal];
    
}



-(IBAction)btnsetClick:(id)sender{

    int requestLike = (int)sld.value /2;
    NSMutableDictionary *param =[[NSMutableDictionary alloc] init];
    [param setValue:[[Singleton sharedSingleton] getUserDefault:USERID] forKey:@"server_user_id"];
    [param setValue:[[Singleton sharedSingleton] getUserDefault:USERINSTAID] forKey:@"insta_user_id"];
    
    [param setValue:self.mediaInfo.Id forKey:@"instagram_img_id"];
    [param setValue:self.mediaInfo.standardResolutionImageURL.absoluteString forKey:@"instagram_img_url"];
    [param setValue:[NSString stringWithFormat:@"%d",requestLike] forKey:@"wanted_likes"];
    
    [[WebserviceCaller sharedSingleton] BaseWsCallPOST:param :@"user/upload_photo_like" success:^(id responseData) {
        NSLog(@"%@",responseData);
        NSMutableDictionary *userInfo =[responseData objectForKey:@"user_details"];
        [[Singleton sharedSingleton] setUserDefault:[userInfo objectForKey:@"total_coin_count"] :USERTOTALCOIN];
        [appDel.objCustomTabBar.headerview updateCoin:[userInfo objectForKey:@"total_coin_count"]];
        sld.value = 0;
        sld.maximumValue =[[[Singleton sharedSingleton] getUserDefault:USERTOTALCOIN] integerValue];
        [self SliderChange:sld];
    } Failure:^(id responseData) {
        [[WebserviceCaller sharedSingleton] AjNotificationView:[responseData objectForKey:@"MESSAGE"] :AJNotificationTypeRed];
    }];
}

-(IBAction)btnHashClixk:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Number of Likes"
                              message:@"Enter the number of likes you would like to receive"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Ok", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *textField = [alertView textFieldAtIndex:0];
    alertView.delegate=self;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [alertView show];
}
#pragma mark- AlertView Delegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    if (sld.maximumValue>[textField.text  intValue])
    {
        sld.value=[textField.text integerValue] * 2;
        //[self sldValueChange:sld];
        [self SliderChange:sld];
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
