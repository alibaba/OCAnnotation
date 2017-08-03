//
//  AFWTTYLoggerColorProfile.h
//  AFWealth
//
//  Created by lianjie.lj on 1/27/16.
//  Copyright © 2016 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>
#import "AFWLogManager.h"

@interface AFWTTYLoggerColorProfile : NSObject {
@public
    AFWLogFlag mask;
    
    uint8_t fg_r;
    uint8_t fg_g;
    uint8_t fg_b;
    
    uint8_t bg_r;
    uint8_t bg_g;
    uint8_t bg_b;
    
    NSUInteger fgCodeIndex;
    NSString *fgCodeRaw;
    
    NSUInteger bgCodeIndex;
    NSString *bgCodeRaw;
    
    char fgCode[24];
    size_t fgCodeLen;
    
    char bgCode[24];
    size_t bgCodeLen;
    
    char resetCode[8];
    size_t resetCodeLen;
}

- (instancetype)initWithForegroundColor:(UIColor *)fgColor backgroundColor:(UIColor *)bgColor flag:(AFWLogFlag)mask;

@end
