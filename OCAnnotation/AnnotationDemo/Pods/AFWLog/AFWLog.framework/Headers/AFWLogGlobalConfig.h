//
//  AFWLogGlobalConfig.h
//  AliStock
//
//  Created by lianjie.lj on 1/19/15.
//  Copyright (c) 2015 AliPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFWLogDefines.h"

typedef NS_OPTIONS(NSInteger, ASLogOption){
    ASLogOptionNone = 0,
    ASLogOptionEnableLogWithDetail = 1 << 3,
    ASLogOptionEnableLogWithMethod = 1 << 4,
    ASLogOptionDisableAsyncLog = 1 << 5,
    ASLogOptionEnableRPCDetailLog = 1 << 6,
};

@interface AFWLogGlobalConfig : NSObject

@property(nonatomic, assign) ASLogOption config; //default ASLogOptionNone
@property(nonatomic, assign) AFWLogLevel logLevel; //default AFWLogLevelInfo

/**
 *    @brief 数组中的tag不会被输出到tty console中（E和W的除外）<br/>
 *    defaultValue: AFWLogDefaultTTYHiddenTags
 */
@property(nonatomic, strong) NSArray *ttyHiddenTags;

/**
 *    @brief 只有数组中的tag才会被输出单独的本地日志文件<br/>
 *    defaultValue: AFWLogDefaultOutputFileTags
 */
@property(nonatomic, strong) NSArray *outputFileTags;

+ (AFWLogGlobalConfig *)sharedConfig;

- (BOOL)useAsyncLog;

- (BOOL)shouldLogWithDetails;

- (BOOL)shouldLogDetailsWithMethod;

- (BOOL)shouldLogForRPCDetails;

- (void)toggleRPCLog;
@end
