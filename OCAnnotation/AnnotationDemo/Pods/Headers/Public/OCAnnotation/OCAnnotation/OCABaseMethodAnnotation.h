//
//  OCABaseMethodAnnotation.h
//  AFWealth
//
//  Created by lianjie.lj on 10/30/15.
//  Copyright © 2015 Alipay. All rights reserved.
//

#import "OCABaseAnnotation.h"

@interface OCABaseMethodAnnotation : OCABaseAnnotation

@property(nonatomic, strong) NSString *selectorString;

+ (instancetype)annotationWithInfos:(NSDictionary*)infoDic
                         sourceFile:(NSString*)sourceFile;

- (instancetype)initWithSourceFile:(NSString*)sourceFile
                         className:(NSString*)className
                            params:(NSDictionary*)params
                    methodSelector:(NSString*)methodSelector
                              type:(NSString*)type;

@end
