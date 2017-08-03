//
//  AFWAbstractLogger.h
//  AFWealth
//
//  Created by lianjie.lj on 1/25/16.
//  Copyright © 2016 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFWLogManager.h"

/**
 * The AFWLogger protocol specifies that an optional formatter can be added to a logger.
 * Most (but not all) loggers will want to support formatters.
 *
 * However, writting getters and setters in a thread safe manner,
 * while still maintaining maximum speed for the logging process, is a difficult task.
 *
 * To do it right, the implementation of the getter/setter has strict requiremenets:
 * - Must NOT require the logMessage method to acquire a lock.
 * - Must NOT require the logMessage method to access an atomic property (also a lock of sorts).
 *
 * To simplify things, an abstract logger is provided that implements the getter and setter.
 *
 * Logger implementations may simply extend this class,
 * and they can ACCESS THE FORMATTER VARIABLE DIRECTLY from within their logMessage method!
 **/

@interface AFWAbstractLogger : NSObject <AFWLoggerProtocol>
{
    // Direct accessors to be used only for performance
@public
    id <AFWLogFormatterProtocol> _logFormatter;
    dispatch_queue_t _loggerQueue;
}

@property (nonatomic, strong) id <AFWLogFormatterProtocol> logFormatter;
@property (nonatomic, strong) dispatch_queue_t loggerQueue;

// For thread-safety assertions
@property (nonatomic, readonly, getter=isOnGlobalLoggingQueue)  BOOL onGlobalLoggingQueue;
@property (nonatomic, readonly, getter=isOnInternalLoggerQueue) BOOL onInternalLoggerQueue;

@end


