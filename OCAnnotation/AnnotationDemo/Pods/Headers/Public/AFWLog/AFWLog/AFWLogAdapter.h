//
//  AFWLogAdapter.h
//  AFWLog
//
//  Created by xinpeng.sxp on 16/8/26.
//  Copyright © 2016年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFWLogAdapter <NSObject>

- (void)reportBizError:(NSString *)biz subname:(NSString *)subname reason:(NSString *)reason params:(NSDictionary *)params;
- (void)addLoggers;

@end

@interface AFWLogAdapter : NSObject

+ (id<AFWLogAdapter>)adapter; //实现 AFWLogAdapterImpl<AFWLogAdapter>

@end
