//
//  AFWBizReport.h
//  AFWealth
//
//  Created by xinpeng.sxp on 16/8/25.
//  Copyright © 2016年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFWBizErrorReport : NSObject

+ (void)reportBiz:(NSString *)biz subname:(NSString *)subname code:(NSInteger)code params:(NSDictionary *)params;
+ (void)reportBiz:(NSString *)biz subname:(NSString *)subname reason:(NSString *)reason params:(NSDictionary *)params;

@end
