//
//  OCABaseClassAnnotation.h
//  AFWealth
//
//  Created by lianjie.lj on 10/30/15.
//  Copyright © 2015 Alipay. All rights reserved.
//

#import "OCABaseAnnotation.h"

@interface OCABaseClassAnnotation : OCABaseAnnotation

+ (instancetype)annotationWithInfos:(NSDictionary*)infoDic
                         sourceFile:(NSString*)sourceFile;

- (instancetype)initWithSourceFile:(NSString*)sourceFile
                         className:(NSString*)className
                            params:(NSDictionary*)params
                              type:(NSString*)type;

@end
