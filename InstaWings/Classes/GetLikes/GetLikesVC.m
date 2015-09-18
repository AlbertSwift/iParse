//
//  GetLikesVC.m
//  InstaWings
//
//  Created by Tops on 9/11/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import "GetLikesVC.h"

@interface GetLikesVC ()

@end

@implementation GetLikesVC


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [appDel.objCustomTabBar.headerview changeTitle:@"Get Likes"];
    [appDel.objCustomTabBar.headerview.btnRefrsh setHidden:NO];
    [appDel.objCustomTabBar.headerview.btnback setHidden:YES];
    
    [appDel.objCustomTabBar.headerview.btnRefrsh removeTarget:self  action:@selector(RefreshClick:) forControlEvents:UIControlEventTouchUpInside];
    [appDel.objCustomTabBar.headerview.btnRefrsh addTarget:self action:@selector(RefreshClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    btnAll.selected = YES;
    btnAccomplished.selected =NO;
    // Do any additional setup after loading the view from its nib.
    appDel =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [clnView registerNib:[UINib nibWithNibName:@"GetLikesCustomCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    
    [btnAll sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}


-(IBAction)btnAllClick:(id)sender{
    
    btnAccomplished.selected =NO;
    btnAll.selected = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mediaArray =[[NSMutableArray alloc] init];
    [[InstagramEngine sharedEngine] getMediaForUser:[[Singleton sharedSingleton] getUserDefault:USERINSTAID] count:5000 maxId:self.currentPaginationInfo.nextMaxId withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (paginationInfo) {
            //self.currentPaginationInfo = paginationInfo;
        }
        [mediaArray removeAllObjects];
        [mediaArray addObjectsFromArray:media];
        [clnView reloadData];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        NSLog(@"Loading User media failed");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}
-(IBAction)btnAccoplishedClick:(id)sender{
    
    btnAccomplished.selected =YES;
    btnAll.selected = NO;
    NSMutableDictionary *param =[[NSMutableDictionary alloc] init];
    [param setValue:[[Singleton sharedSingleton] getUserDefault:USERID] forKey:@"server_user_id"];
    [[WebserviceCaller sharedSingleton] BaseWsCallPOST:param :@"user/accomplish_photo_list" success:^(id responseData) {
        
        [mediaArray removeAllObjects];
        mediaArray =[[NSMutableArray alloc] init];
        mediaArray = [[responseData objectForKey:@"accomplish_photo_list"] mutableCopy];
        [clnView reloadData];
        
    } Failure:^(id responseData) {
        
    }];
    
}

-(IBAction)RefreshClick:(id)sender{
    if (btnAccomplished.selected) {
      [btnAccomplished sendActionsForControlEvents:UIControlEventTouchUpInside];
    }else if (btnAll.selected){
        [btnAll sendActionsForControlEvents:UIControlEventTouchUpInside];
        
    }
}
#pragma mark
#pragma mark - collection view data source & delegate.

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([mediaArray count]>= 1) {
        [lblNoMedia setHidden:YES];
    }else{
        [lblNoMedia setHidden:NO];
    }
    return [mediaArray count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (g_IS_IPHONE_6P_SCREEN) {
        return CGSizeMake(140, 140);
    }else if (g_IS_IPHONE_6_SCREEN) {
        return CGSizeMake(125, 125);
    }
    return CGSizeMake(100, 100);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     GetLikesCustomCell *cell = [clnView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    if (btnAll.selected) {
        InstagramMedia *media = [mediaArray objectAtIndex:indexPath.row];
        cell.lblTotalLike.text =[NSString stringWithFormat:@"%ld",(long)media.likesCount];
        __block UIImageView *temp=cell.imgImage;
        [cell.imgImage setImageWithURLRequest:[NSURLRequest requestWithURL:media.standardResolutionImageURL] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            temp.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        }];
    }else if (btnAccomplished.selected){
        NSMutableDictionary *media = [mediaArray objectAtIndex:indexPath.row];
        cell.lblTotalLike.text =[NSString stringWithFormat:@"%@/%@",[media objectForKey:@"likes_count"],[media objectForKey:@"wanted_likes"]];
        __block UIImageView *temp=cell.imgImage;
        [cell.imgImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[media objectForKey:@"instagram_img_url"]]] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            temp.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        }];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SetLIkeVC *setlikeobj =[[SetLIkeVC alloc] initWithNibName:@"SetLIkeVC" bundle:nil];
    setlikeobj.mediaInfo = [mediaArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:setlikeobj animated:YES];
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
