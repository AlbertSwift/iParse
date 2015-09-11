//
//  WebserviceCaller.h
//  BlockPrograming
//
//  Created by Tops on 1/1/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppDelegate;
typedef void(^WebMasterSuccessBlock)(id responseData);
typedef void(^WebMasterFailureBlock)(id responseData);
typedef void(^WebMasterProgressBlock)(float responseData);

typedef void(^SiAlertSuccessBlock)();
typedef void(^SiAlertCancelBlock)();
typedef void(^DBSuccessBlock)();
typedef void(^DBFailurBlock)();


@interface WebserviceCaller : NSObject{
    //AFHTTPRequestOperation *fileoperation;
}

+ (WebserviceCaller *)sharedSingleton;
-(void)baseWscalldispatch:(NSMutableDictionary *)params :(NSString *)fileNameURL
                  success:(WebMasterSuccessBlock)successBlock;
-(void)BaseWsCallGET:(NSMutableDictionary *)params :(NSString *)fileNameURL
          success:(WebMasterSuccessBlock)successBlock
          Failure:(WebMasterSuccessBlock)failureBlock;
-(void)BaseWsCallPOST:(NSMutableDictionary *)params :(NSString *)fileNameURL
             success:(WebMasterSuccessBlock)successBlock
             Failure:(WebMasterSuccessBlock)failureBlock;


-(void)CustomAlert :(NSString *)title message:(NSString *)message OkButtonTitle:(NSString *)OkButtonTitle CancelButtonTitle:(NSString *)CancelButtonTitle
             success:(SiAlertSuccessBlock)successBlock
             Failure:(SiAlertCancelBlock)failure;

-(void)AjNotificationView :(NSString *)title :(int)AJNotificationType;
- (BOOL)isconnectedToNetwork ;
-(id)convertDictonary:(NSMutableDictionary *)dict :(NSString *)aKey;
-(NSMutableArray *)convertArray:(NSArray *)ary :(NSString *)aKey;

@end
