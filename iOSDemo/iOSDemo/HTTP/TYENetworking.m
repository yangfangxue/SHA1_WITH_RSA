//
//  TYENetworking.m
//  NBHD
//
//  Created by  mug1s on 2020/9/2.
//  Copyright © 2020 mug1s. All rights reserved.
//

#import "TYENetworking.h"
#import "TYESign.h"
#import "RSA+SHA1WithRSA.h"
#import <SVProgressHUD/SVProgressHUD.h>

// HOST URL
//#define HOST_URL @"http://192.168.0.110:8080/"
// 生成字符串长度
#define kRandomLength 32
// 随机字符表
static const NSString *kRandomAlphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
 
@implementation TYENetworking

static TYENetworking *_manager;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [TYENetworking manager];
        
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = 20.f;
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", @"multipart/form-data", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/plain", nil];
    });
    return _manager;
}

- (void)requestWithType:(TYEHttpRequestType)type urlString:(NSString *)urlString parameters:(NSDictionary *)parameters showHUD:(BOOL)showHUD successBlock:(HTTPRequestSuccessBlock)successBlock failureBlock:(HTTPRequestFailedBlock)failureBlock {
    
    if (urlString == nil || parameters == nil) {
        return;
    }
    if (_manager.hostUrl.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先设置HOST_URL"];
        [SVProgressHUD dismissWithDelay:2.0f];
        return;
    }
    if(![_manager.hostUrl containsString:@"http://"] && ![_manager.hostUrl containsString:@"https://"]){
        _manager.hostUrl = [NSString stringWithFormat:@"%@%@%@", @"http://", _manager.hostUrl,@":8080/"];
    }
    NSMutableDictionary *signParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [signParameters setValue:[TYENetworking getDateString] forKey:@"timestamp"];
    [signParameters setValue:[TYENetworking getRandStr] forKey:@"msgId"];
    //待签名字符串
    NSString *encryptStr = [TYESign getSignWithParameters:signParameters];
    NSString *prikey = @"MIIBVgIBADANBgkqhkiG9w0BAQEFAASCAUAwggE8AgEAAkEAsp98g4/YTo2nQvBYhYx1nDhPxwMf4MTnKFhzxfKV0NXj6EsCB0jyosun+ORJqKPuwOJXZJgcyb1+NikR8DDMpwIDAQABAkBLkARQc22B7ZKwUpRgCodGStwUyFGX+DQBcUmol3KhIOWRZm2xDyItI3IbFTagzYTUAv0EyiRDKP9O2D8oQ4DBAiEA2ZX6qG7coE1TE0M6Z4ACGBgM/rnKRZXMyesC34vEwvkCIQDSKIozChpeaMX3v09gKf9YGrUOIiaDWOasBX4yF5JUnwIhAIjVFqLhxQFSX1IXzxzTlX2Ncm6mbBvCjtzUXCQ1A3IRAiEAyxF9KIBUpnEbCZ+ENWmfYCS+Wl/JUxWuHv5XyFNahAUCIQCyb0W+4yYZgXVoOyvfNfZt2pRXK89s8UJZ4Y5po4AmeQ==";
    NSString *pubkey = @"MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBALiUBdmHOuOW3/499CdfXO25MkBkSrtMRMHm3IdA5T+LoNvWyZgeU6kjPG6W2FLtmK5EeI1hWPIpXJdg3WiTEkECAwEAAQ==";
    NSString *sign = [RSA signSHA1WithRSA:encryptStr privateKey:prikey];
    NSLog(@"%@",sign);
    [signParameters setValue:sign forKey:@"sign"];
    
    if (type == TYEHttpRequestTypeGet) {
        [self GET:[NSString stringWithFormat:@"%@%@", _manager.hostUrl, urlString] parameters:signParameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@",jsonString);
            NSArray *json = [jsonString componentsSeparatedByString:@"&"];
            NSDictionary *dictionary = json.firstObject;
            NSLog(@"\n\nAPI：%@\n参数：%@\n返回：%@\n", [NSString stringWithFormat:@"%@%@", _manager.hostUrl, urlString], signParameters, dictionary);
            if (successBlock) {
                successBlock(dictionary, 0);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"\n\nAPI：%@\n参数：%@\n错误：%@\n", [NSString stringWithFormat:@"%@%@", _manager.hostUrl, urlString], signParameters, error);
            if (failureBlock) {
                failureBlock(error);
            }
        }];
        
    } else if (type == TYEHttpRequestTypePost) {
        [self POST:[NSString stringWithFormat:@"%@%@", _manager.hostUrl, urlString] parameters:signParameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@",jsonString);
            NSArray *json = [jsonString componentsSeparatedByString:@"&"];
            NSDictionary *dictionary = [TYENetworking dictionaryWithJsonString:json.firstObject];
            NSLog(@"\n\nAPI：%@\n参数：%@\n返回：%@\n", [NSString stringWithFormat:@"%@%@", _manager.hostUrl, urlString], signParameters, dictionary);
            if (successBlock) {
                successBlock(dictionary, 0);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"\n\nAPI：%@\n参数：%@\n错误：%@\n", [NSString stringWithFormat:@"%@%@", _manager.hostUrl, urlString], signParameters, error);
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    }
}

+ (void)cancelDataTask {
    NSMutableArray *dataTasks = [NSMutableArray arrayWithArray:_manager.dataTasks];
    for (NSURLSessionDataTask *task in dataTasks) {
        [task cancel];
    }
}

#pragma mark - 判断网络状态

+ (TYENetworkStates)getNetworkStates {
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    // 保存网络状态
    TYENetworkStates states = TYENetworkStatesNone;
    for (id child in subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏码
            int networkType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            switch (networkType) {
                case 0:
                    states = TYENetworkStatesNone;
                    break;
                case 1:
                    states = TYENetworkStates2G;
                    break;
                case 2:
                    states = TYENetworkStates3G;
                    break;
                case 3:
                    states = TYENetworkStates4G;
                    break;
                case 5: {
                    states = TYENetworkStatesWIFI;
                }
                    break;
                default:
                    break;
            }
        }
    }
    return states;
}

#pragma mark

//获取当前时间字符串
+ (NSString *)getDateString{
    NSTimeInterval time=[[TYENetworking currentTimeStr] doubleValue];
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}
//获取当前时间戳
+ (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}
//获取32位随机UUID字符串
+ (NSString *)getRandStr {
    NSMutableString *randomString = [NSMutableString stringWithCapacity:kRandomLength];
    for (int i = 0; i < kRandomLength; i++) {
        [randomString appendFormat: @"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
    }
    NSLog(@"randomString = %@", randomString);
    return randomString.copy;
}

// 将JSON串转化为字典或者数组
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
