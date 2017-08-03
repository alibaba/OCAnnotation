//
//  AFWLoggerNode.h
//  AFWealth
//
//  Created by lianjie.lj on 1/26/16.
//  Copyright © 2016 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFWLogManager.h"

@interface AFWLoggerNode : NSObject
{
    // Direct accessors to be used only for performance
@public
    id <AFWLoggerProtocol> _logger;
    dispatch_queue_t _loggerQueue;
}

@property (nonatomic, readonly) id <AFWLoggerProtocol> logger;
@property (nonatomic, readonly) dispatch_queue_t loggerQueue;

+ (AFWLoggerNode *)nodeWithLogger:(id <AFWLoggerProtocol>)logger
                      loggerQueue:(dispatch_queue_t)loggerQueue;

@end
