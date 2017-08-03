//
//  AFWBenchmarkAnalysis.h
//  AFWealth
//
//  Created by xinglie on 16/4/15.
//  Copyright © 2016年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBenchmarkAnalysis 1

#if DEBUG && kBenchmarkAnalysis
#define AS_BenchmarkStart(key) \
do{\
    if(!timeDic){\
        timeDic = [NSMutableDictionary dictionary];\
    }\
    if([key length] == 0){\
        AS_E(@"AFWTimeConsumeManager key must not be nil");\
        continue;\
    }\
    NSDate* startTime = [timeDic objectForKey:key];\
    if(startTime){\
        AS_E(@"AFWTimeConsumeManager there is an exist Key");\
        continue;\
    }\
    startTime = [NSDate date];\
    [timeDic setObject:startTime forKey:key];\
}while(0);

#define AS_BenchmarkEnd(key) AS_TagBenchmarkEnd(key,@"")

#define AS_TagBenchmarkEnd(key,logTag) \
do{\
    if([key length] == 0){\
        AS_E(@"key must not be nil");\
        return;\
    }\
    NSDate* startTime = [timeDic objectForKey:key];\
    if(!startTime){\
        AS_E(@"can not find startTime with Key");\
        return;\
    }\
    NSTimeInterval timeSpent = [[NSDate date] timeIntervalSinceDate:startTime]*1000;\
    if([logTag length] > 0){\
        AS_TagD(logTag, @"time spent with %@ is:%@ ms",key, @(timeSpent));\
    }else{\
        AS_D(@"time spent with %@ is:%@ ms",key, @(timeSpent));\
    }\
    [timeDic removeObjectForKey:key];\
}while(0);

#else

#define AS_BenchmarkStart(key) do{}while(0);
#define AS_BenchmarkEnd(key) do{}while(0);
#define AS_TagBenchmarkEnd(key,tag) do{}while(0);

#endif

static NSMutableDictionary *timeDic;

