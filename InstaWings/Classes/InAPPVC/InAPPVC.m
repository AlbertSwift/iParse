//
//  InAPPVC.m
//  InstaWings
//
//  Created by Tops on 9/11/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import "InAPPVC.h"

@interface InAPPVC ()

@end

@implementation InAPPVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [appDel.objCustomTabBar.headerview changeTitle:@"Earn Coins"];
    [appDel.objCustomTabBar.headerview.btnRefrsh setHidden:YES];
    [appDel.objCustomTabBar.headerview.btnback setHidden:NO];
    
    aryInApp =[[NSMutableArray alloc] init];
    [aryInApp addObject:@{@"Title":@"Get 150 Coins-",@"price":@"$0.99",@"inAppid":@""}];
    [aryInApp addObject:@{@"Title":@"Get 350 Coins-",@"price":@"$1.99",@"inAppid":@""}];
    [aryInApp addObject:@{@"Title":@"Get 700 Coins-",@"price":@"$3.99",@"inAppid":@""}];
    [aryInApp addObject:@{@"Title":@"Get 1150 Coins-",@"price":@"$5.99",@"inAppid":@""}];
    [aryInApp addObject:@{@"Title":@"Get 4000 Coins-",@"price":@"$9.99",@"inAppid":@""}];
    [aryInApp addObject:@{@"Title":@"Get 15000 Coins-",@"price":@"$28.99",@"inAppid":@""}];
    [tblView reloadData];

    #ifdef DEBUG
        [btnLogout setHidden:NO];
    #else
        [btnLogout setHidden:YES];
    #endif
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

-(IBAction)btnBackClick:(id)sender{
   // [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark - table view data source & delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [aryInApp count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InAPPCustomCell *cell =(InAPPCustomCell *)[tblView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        NSArray *aryNib =[[NSBundle mainBundle] loadNibNamed:@"InAPPCustomCell" owner:self options:nil];
        cell = [aryNib objectAtIndex:0];
    }
    NSMutableDictionary *dict =[aryInApp objectAtIndex:indexPath.row];
    cell.lblTitle.text =[dict objectForKey:@"Title"];
    [cell.btnPurchase setTitle:[NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]] forState:UIControlStateNormal];
    cell.btnPurchase.tag =indexPath.row;
    [cell.btnPurchase addTarget:self action:@selector(btnBuyClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(IBAction)btnBuyClick:(id)sender{
    NSMutableDictionary *dict =[aryInApp objectAtIndex:[sender tag]];
    NSLog(@"%@",dict);
    
    SKProduct* product =[[IAPShare sharedHelper].iap.products objectAtIndex:0];
             [[IAPShare sharedHelper].iap buyProduct:product
                                        onCompletion:^(SKPaymentTransaction* trans){
                                            
                                            if(trans.error)
                                            {
                                                NSLog(@"Fail %@",[trans.error localizedDescription]);
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                                
                                                [[IAPShare sharedHelper].iap checkReceipt:trans.transactionReceipt AndSharedSecret:@"your sharesecret" onCompletion:^(NSString *response, NSError *error) {
                                                    
                                                    //Convert JSON String to NSDictionary
                                                    NSDictionary* rec = [IAPShare toJSON:response];
                                                    
                                                    if([rec[@"status"] integerValue]==0)
                                                    {
                                                        NSString *productIdentifier = trans.payment.productIdentifier;
                                                        [[IAPShare sharedHelper].iap provideContent:productIdentifier];
                                                        NSLog(@"SUCCESS %@",response);
                                                        NSLog(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
                                                    }
                                                    else {
                                                        NSLog(@"Fail");
                                                    }
                                                }];
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                                NSLog(@"Fail");
                                            }
                                        }];//end of buy product

 
    
}

-(IBAction)btnlogout:(id)sender{
    
    [InstagramEngine sharedEngine].accessToken = nil;
    [[InstagramEngine sharedEngine] logout];
    [appDel.navController popToRootViewControllerAnimated:YES];

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
