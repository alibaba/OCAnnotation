//
//  AFWLogUtils.h
//
//
//  Created by xinpeng.sxp on 14-7-22.
//  Copyright (c) 2014年 AliPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFWLogManager.h"

#define AS_V(format,...) [AFWLogUtils log:AFWLogFlagVerbose filename:__FILE__ lineNumber:__LINE__ method:(char *)__FUNCTION__ tag:nil message:(format), ##__VA_ARGS__]

#define AS_TagV(tagString,format,...) [AFWLogUtils log:AFWLogFlagVerbose filename:__FILE__ lineNumber:__LINE__ method:(char *)__FUNCTION__ tag:(tagString) message:(format), ##__VA_ARGS__]

#ifdef DEBUG

#define AS_D(format,...) [AFWLogUtils log:AFWLogFlagDebug filename:__FILE__ lineNumber:__LINE__ method:(char *)__FUNCTION__ tag:nil message:(format), ##__VA_ARGS__]

#define AS_TagD(tagString,format,...) [AFWLogUtils log:AFWLogFlagDebug filename:__FILE__ lineNumber:__LINE__ method:(char *)__FUNCTION__ tag:(tagString) message:(format), ##__VA_ARGS__]

#else

#define AS_D(format,...) do{}while(0);
#define AS_TagD(tagString,format,...) do{}while(0);

#endif

#define AS_I(format,...) [AFWLogUtils log:AFWLogFlagInfo filename:__FILE__ lineNumber:__LINE__ method:(char *)__FUNCTION__ tag:nil message:(format), ##__VA_ARGS__]

#define AS_TagI(tagString,format,...) [AFWLogUtils log:AFWLogFlagInfo filename:__FILE__ lineNumber:__LINE__ method:(char *)__FUNCTION__ tag:(tagString) message:(format), ##__VA_ARGS__]

#define AS_W(format,...) [AFWLogUtils log:AFWLogFlagWarning filename:__FILE__ lineNumber:__LINE__ method:(char *)__FUNCTION__ tag:nil message:(format), ##__VA_ARGS__]

#define AS_TagW(tagString,format,...) [AFWLogUtils log:AFWLogFlagWarning filename:__FILE__ lineNumber:__LINE__ method:(char *)__FUNCTION__ tag:(tagString) message:(format), ##__VA_ARGS__]

#define AS_E(format,...) [AFWLogUtils log:AFWLogFlagError  filename:__FILE__ lineNumber:__LINE__ method:(char *)__FUNCTION__ tag:nil message:(format), ##__VA_ARGS__]

#define AS_TagE(tagString,format,...) [AFWLogUtils log:AFWLogFlagError  filename:__FILE__ lineNumber:__LINE__ method:(char *)__FUNCTION__ tag:(tagString) message:(format), ##__VA_ARGS__]

@interface AFWLogUtils : NSObject

+ (void)log:(AFWLogFlag)flag
   filename:(const char *)fn
 lineNumber:(int)ln
     method:(const char *)method
        tag:(NSString *)tag
    message:(NSString *)message, ... NS_FORMAT_FUNCTION(6,7);
@end
