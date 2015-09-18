//
//  WebserviceCaller.m
//  BlockPrograming
//
//  Created by Tops on 1/1/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import "WebserviceCaller.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import<objc/runtime.h>

@implementation WebserviceCaller{
    AppDelegate *appDel;
}

static WebserviceCaller *singletonObj = NULL;
+ (WebserviceCaller *)sharedSingleton {
    @synchronized(self) {
        if (singletonObj == NULL)
            singletonObj = [[self alloc] init];
    }
    return(singletonObj);
}
- (id) init {
    appDel=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    return self;
}

-(void)baseWscalldispatch:(NSMutableDictionary *)params :(NSString *)fileNameURL
                  success:(WebMasterSuccessBlock)successBlock{
    if ([self isconnectedToNetwork]) {
        NSString *url= [NSString stringWithFormat:@"%@%@",g_BaseURL,fileNameURL];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"FLAG"] boolValue]) {
                successBlock(responseObject);
            }else{
              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                //            [self AjNotificationView:[responseObject objectForKey:@"MESSAGE"]:AJNotificationTypeRed];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //        [self AjNotificationView:@"Server Error " :AJNotificationTypeRed];
          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
    }
}

-(void)BaseWsCallGET:(NSMutableDictionary *)params :(NSString *)fileNameURL
          success:(WebMasterSuccessBlock)successBlock
          Failure:(WebMasterSuccessBlock)failureBlock{
    appDel=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([self isconnectedToNetwork]) {

    NSString *url= [NSString stringWithFormat:@"%@%@",g_BaseURL,fileNameURL];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 403)];
        [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
            if ([[responseObject objectForKey:@"success"] boolValue]) {
                successBlock(responseObject);
            }else{
                failureBlock(responseObject);
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
            
            
        }];
   }
}
-(void)BaseWsCallPOST:(NSMutableDictionary *)params :(NSString *)fileNameURL
             success:(WebMasterSuccessBlock)successBlock
             Failure:(WebMasterSuccessBlock)failureBlock{
    appDel=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([self isconnectedToNetwork]) {
        
        NSString *url= [NSString stringWithFormat:@"%@%@",g_BaseURL,fileNameURL];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
         manager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 400)];
        [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
            if ([[responseObject objectForKey:@"FLAG"] boolValue]) {
                successBlock(responseObject);
            }else{
                failureBlock(responseObject);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
         
            
        }];
    }
}


-(void)CustomAlert:(NSString *)title message:(NSString *)message OkButtonTitle:(NSString *)OkButtonTitle CancelButtonTitle:(NSString *)CancelButtonTitle success:(SiAlertSuccessBlock)successBlock Failure:(SiAlertCancelBlock)failure{
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:title andMessage:message];
    [alertView addButtonWithTitle:LocalizedString(OkButtonTitle, nil)
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView)
     {
         successBlock();
     }];
    [alertView addButtonWithTitle:LocalizedString(CancelButtonTitle, nil)
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView)
     {
         failure();
     }];
    alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
    [alertView show];
    
}

-(void)AjNotificationView :(NSString *)title :(int)AJNotificationType{
//    UIView *view=[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    [AJNotificationView showNoticeInView:appDel.window type:AJNotificationType title:title linedBackground:AJLinedBackgroundTypeAnimated hideAfter:1.5 offset:0 delay:0 detailDisclosure:YES response:^{
        NSLog(@"Notification Call");
    }];
}

- (BOOL)isconnectedToNetwork {
    //    if([AFNetworkReachabilityManager sharedManager].reachable)
    //        [[AlertView sharedAlertView] showAlertWithOKButton:LocalizedString(@"keyInternetConnectionError", @"")];
    //
    //    return [AFNetworkReachabilityManager sharedManager].reachable;
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
//    if(networkStatus == NotReachable)
//    {
//        [self CustomAlert:LocalizedString(@"KeyErrorInternetErrorTitle", nil) message:LocalizedString(@"KeyErrorInternetErrorDetail", nil) OkButtonTitle:@"OK" CancelButtonTitle:@"Cancel" success:^{
//            [self isconnectedToNetwork];
//        } Failure:^{
//        }];
//    }
// return NO;
    
   return !(networkStatus == NotReachable);

}


-(id)convertDictonary:(NSMutableDictionary *)dict :(NSString *)aKey{
    Class klass = NSClassFromString(aKey);
    if (klass) {
        // class exists
        id instance = [[klass alloc] init];
        uint count;
        objc_property_t* properties = class_copyPropertyList(klass, &count);
        NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count ; i++)
        {
            const char* propertyName = property_getName(properties[i]);
            [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        }
        
        for( NSString *DataKey in [dict allKeys] )
        {
            if ([DataKey isEqualToString:@"id"]) {
                [instance setValue:[dict valueForKey:@"id"] forKey:[NSString stringWithFormat:@"%@_id",aKey]];
            }else if([[dict valueForKey:DataKey] isKindOfClass:[NSArray class]]){
                id subinstance = [self convertArray:[dict valueForKey:DataKey] :[NSString stringWithFormat:@"%@Share",DataKey]];
                [instance setValue:subinstance forKey:[NSString stringWithFormat:@"ary%@",DataKey]];
            }else{
                if ([propertyArray containsObject:DataKey]) {
                    [instance setValue:[dict valueForKey:DataKey] forKey:DataKey];
                }
            }
            
        }
        return instance;
    } else {
        // class doesn't exist
        return dict;
    }
    return nil;
}

-(NSMutableArray *)convertArray:(NSArray *)ary :(NSString *)aKey{
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    for (NSMutableDictionary *dict in ary) {
        id instance = [self convertDictonary:dict :aKey];
        [returnArray addObject:instance];
    }
    return returnArray;
}

@end
