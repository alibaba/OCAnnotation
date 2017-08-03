//
//  OCABasePropertyAnnotation.h
//  AFWealth
//
//  Created by lianjie.lj on 10/30/15.
//  Copyright © 2015 Alipay. All rights reserved.
//

#import "OCABaseAnnotation.h"

@interface OCABasePropertyAnnotation : OCABaseAnnotation

@property(nonatomic, strong) NSString* propertyName;

+ (instancetype)annotationWithInfos:(NSDictionary*)infoDic
                         sourceFile:(NSString*)sourceFile;

- (instancetype)initWithSourceFile:(NSString*)sourceFile
                         className:(NSString*)className
                            params:(NSDictionary*)params
                      propertyName:(NSString*)propertyName
                              type:(NSString*)type;

@end
