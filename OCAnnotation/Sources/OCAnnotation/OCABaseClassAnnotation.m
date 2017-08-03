/**
 * Created by OCAnnotation.
 * Copyright (c) 2017, Ant Financial Wealth Mobile Team. All rights reserved.
 *
 * This source code is licensed under the Apache.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import "OCABaseClassAnnotation.h"
#import "OCAAnnotationDefines.h"
#import "OCAAnnotationManager.h"

@implementation OCABaseClassAnnotation

+ (instancetype)annotationWithInfos:(NSDictionary*)infoDic
                         sourceFile:(NSString*)sourceFile
{
    NSString *type = infoDic[kOCAAnnotationConfigKeyType];
    Class clz = [[OCAAnnotationManager sharedManager]
                           annotationClassForTypeString:type
                           position:OCAAnnotationPositionClass];
    if (!clz || ![clz isSubclassOfClass:[OCABaseClassAnnotation class]]) {
        NSAssert(NO,@"invalid class info");
        return nil;
    }
    
    OCABaseClassAnnotation *anno = [[clz alloc]
                                    initWithSourceFile:sourceFile
                                    className:infoDic[kOCAAnnotationConfigKeyClassName]
                                    params:infoDic[kOCAAnnotationConfigKeyParams]
                                    type:infoDic[kOCAAnnotationConfigKeyType]];
    return anno;
}

- (instancetype)initWithSourceFile:(NSString*)sourceFile
                         className:(NSString*)className
                            params:(NSDictionary*)params
                              type:(NSString*)type
{
    self = [super initWithSourceFile:sourceFile
                           className:className
                              params:params
                            position:OCAAnnotationPositionClass
                                type:type];
    if (self) {
        self.postion = OCAAnnotationPositionClass;
    }
    return self;
}

- (NSString *)groupKey
{
    if (!self.typeString || [self.typeString length] == 0) {
        return nil;
    }
    if (!self.className || [self.className length] == 0) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@_%@_%@",
            @(OCAAnnotationPositionClass),
            self.typeString,
            self.className];
}

@end
