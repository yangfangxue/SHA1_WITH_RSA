//
//  TYENetworking.h
//  NBHD
//
//  Created by  mug1s on 2020/9/2.
//  Copyright © 2020 mug1s. All rights reserved.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TYENetworkStates) {
    TYENetworkStatesNone, // 没有网络
    TYENetworkStates2G, // 2G
    TYENetworkStates3G, // 3G
    TYENetworkStates4G, // 4G
    TYENetworkStatesWIFI // WIFI
};

typedef NS_ENUM(NSUInteger, TYEHttpRequestType) {
    TYEHttpRequestTypeGet = 0,
    TYEHttpRequestTypePost
};

typedef void (^HTTPRequestSuccessBlock)(id responseObject, BOOL codeZero);
typedef void (^HTTPRequestFailedBlock)(NSError *error);

@interface TYENetworking : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (void)requestWithType:(TYEHttpRequestType)type urlString:(NSString *)urlString parameters:(NSDictionary *)parameters showHUD:(BOOL)showHUD successBlock:(HTTPRequestSuccessBlock)successBlock failureBlock:(HTTPRequestFailedBlock)failureBlock;

+ (void)cancelDataTask;

+ (TYENetworkStates)getNetworkStates;

@property (nonatomic, copy) NSString *hostUrl;

@end

NS_ASSUME_NONNULL_END
