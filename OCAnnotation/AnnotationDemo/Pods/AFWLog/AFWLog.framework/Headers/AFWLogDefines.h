//
//  AFWLogDefines.h
//  AFWealth
//
//  Created by lianjie.lj on 1/25/16.
//  Copyright © 2016 Alipay. All rights reserved.
//

#ifndef AFWLogDefines_h
#define AFWLogDefines_h

typedef NS_OPTIONS(NSUInteger, AFWLogFlag) {
    AFWLogFlagError       = (1 << 0), // 0...00001
    AFWLogFlagWarning    = (1 << 1), // 0...00010
    AFWLogFlagInfo       = (1 << 2), // 0...00100
    AFWLogFlagDebug      = (1 << 3), // 0...01000
    AFWLogFlagVerbose    = (1 << 4)  // 0...10000
};

typedef NS_OPTIONS(NSUInteger, AFWLogLevel) {
    AFWLogLevelOff = 0,
    AFWLogLevelError = AFWLogFlagError,
    AFWLogLevelWarning = (AFWLogLevelError | AFWLogFlagWarning),
    AFWLogLevelInfo = (AFWLogLevelWarning | AFWLogFlagInfo),
    AFWLogLevelDebug = (AFWLogLevelInfo | AFWLogFlagDebug),
    AFWLogLevelVerbose= (AFWLogLevelDebug | AFWLogFlagVerbose),
};

#define AFWLogInner_LOG_LEVEL 2

#define AFWLogInnerError(frmt, ...)    do{ if(AFWLogInner_LOG_LEVEL >= 1) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define AFWLogInnerWarn(frmt, ...)     do{ if(AFWLogInner_LOG_LEVEL >= 2) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define AFWLogInnerInfo(frmt, ...)     do{ if(AFWLogInner_LOG_LEVEL >= 3) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define AFWLogInnerDebug(frmt, ...)    do{ if(AFWLogInner_LOG_LEVEL >= 4) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define AFWLogInnerVerbose(frmt, ...)  do{ if(AFWLogInner_LOG_LEVEL >= 5) NSLog((frmt), ##__VA_ARGS__); } while(0)

#define AFWLogTagFormulae @"Formulae"       //数据中间层对应Tag
#define AFWLogTagFMLPreload @"FMLPreload"   //数据中间层-数据预加载对应Tag
#define AFWLogTagLocalData @"LocalData"     //本地存储模块对应Tag
#define AFWLogTagRpc @"Rpc"                 //rpc模块对应Tag
#define AFWLogTagRpcDetail @"RpcDetail"     //rpc模块中rpc详情数据对应Tag
#define AFWLogTagSPDY @"SPDY"               //spdy模块中对应Tag
#define AFWLogTagFundTrade @"FundTrade"     //基金交易
#define AFWLogTagWormHole @"WormHole"       //虫洞
#define AFWLogTagWHNetwork @"WHNetwork"     //虫洞网络模块
#define AFWLogTagAFWNews   @"AFWNews"       //资讯
#define AFWLogTagSync @"AFWSync"            //Sync相关
#define AFWLogTagDiagnose @"Diagnose"       //诊断日志, 可以捞取。

//TTY日志中默认不显示的tag,如果GlobalConfig中未配置ttyHiddenTags,这个值会作为默认值
#define AFWLogDefaultTTYHiddenTags (@[AFWLogTagFormulae,AFWLogTagLocalData,AFWLogTagSPDY,AFWLogTagRpcDetail])

//输出到独立日志文件的tag
#define AFWLogDefaultOutputFileTags (@[AFWLogTagFormulae,AFWLogTagLocalData,AFWLogTagRpc,AFWLogTagRpcDetail,AFWLogTagFMLPreload,AFWLogTagWHNetwork,AFWLogTagWormHole])
#endif /* AFWLogDefines_h */
