//
//  AFWCommonLogFormatter.h
//  AliStock
//
//  Created by lianjie.lj on 1/19/15.
//  Copyright (c) 2015 AliPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFWLogManager.h"

@interface AFWCommonLogFormatter : NSObject <AFWLogFormatterProtocol>{
    NSDateFormatter * _dateFormatter;
}

@end
