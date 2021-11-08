//
//  TYESign.m
//  NBHD
//
//  Created by  mug1s on 2020/9/4.
//  Copyright © 2020 mug1s. All rights reserved.
//

#import "TYESign.h"
#import <CommonCrypto/CommonDigest.h>

@implementation TYESign

+ (NSString *)getSignWithParameters:(NSDictionary *)parameters {
    
    NSMutableDictionary *signParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    NSArray *keyArray = [signParameters allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        [valueArray addObject:[signParameters objectForKey:sortString]];
    }
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",sortArray[i],valueArray[i]];
        [signArray addObject:keyValueStr];
    }
    NSString *sign = [signArray componentsJoinedByString:@"&"];
    return sign;
}


@end
