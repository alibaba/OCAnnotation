//
//  AFWLogMessage.h
//  AFWealth
//
//  Created by lianjie.lj on 1/25/16.
//  Copyright © 2016 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFWLogManager.h"

@interface AFWLogMessage : NSObject <NSCopying>
{
    // Direct accessors to be used only for performance
@public
    NSString *_message;
    AFWLogFlag _flag;
    NSString *_file;
    NSString *_fileName;
    NSString *_function;
    NSUInteger _line;
    NSString *_tag;
    NSDate *_timestamp;
    NSString *_threadID;
    NSString *_threadName;
    NSString *_queueLabel;
}

/**
 * Read-only properties
 **/
@property (readonly, nonatomic) NSString *message;
@property (readonly, nonatomic) AFWLogFlag flag;
@property (readonly, nonatomic) NSString *file;
@property (readonly, nonatomic) NSString *fileName;
@property (readonly, nonatomic) NSString *function;
@property (readonly, nonatomic) NSUInteger line;
@property (readonly, nonatomic) NSString *tag;
@property (readonly, nonatomic) NSDate *timestamp;
@property (readonly, nonatomic) NSString *threadID; // ID as it appears in NSLog calculated from the machThreadID
@property (readonly, nonatomic) NSString *threadName;
@property (readonly, nonatomic) NSString *queueLabel;

/**
 * Standard init method for a log message object.
 * Used by the logging primitives. (And the macros use the logging primitives.)
 *
 * If you find need to manually create logMessage objects, there is one thing you should be aware of:
 *
 * If no flags are passed, the method expects the file and function parameters to be string literals.
 * That is, it expects the given strings to exist for the duration of the object's lifetime,
 * and it expects the given strings to be immutable.
 * In other words, it does not copy these strings, it simply points to them.
 * This is due to the fact that __FILE__ and __FUNCTION__ are usually used to specify these parameters,
 * so it makes sense to optimize and skip the unnecessary allocations.
 **/
- (instancetype)initWithMessage:(NSString *)message
                           flag:(AFWLogFlag)flag
                           file:(NSString *)file
                       function:(NSString *)function
                           line:(NSUInteger)line
                            tag:(NSString*)tag;


@end
