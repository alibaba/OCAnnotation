/**
 * Created by OCAnnotation.
 * Copyright (c) 2017, Ant Financial Wealth Mobile Team. All rights reserved.
 *
 * This source code is licensed under the Apache.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import "OCABaseMethodAnnotation.h"
#import "OCAAnnotationDefines.h"
#import "OCAAnnotationManager.h"

@implementation OCABaseMethodAnnotation

+ (instancetype)annotationWithInfos:(NSDictionary*)infoDic
                         sourceFile:(NSString*)sourceFile
{
    NSString *type = infoDic[kOCAAnnotationConfigKeyType];
    Class clz = [[OCAAnnotationManager sharedManager]
                 annotationClassForTypeString:type
                 position:OCAAnnotationPositionMethod];
    if (!clz || ![clz isSubclassOfClass:[OCABaseMethodAnnotation class]]) {
        NSAssert(NO,@"invalid class info");
        return nil;
    }
    
    OCABaseMethodAnnotation *anno = [[clz alloc]
                                     initWithSourceFile:sourceFile
                                     className:infoDic[kOCAAnnotationConfigKeyClassName]
                                     params:infoDic[kOCAAnnotationConfigKeyParams]
                                     methodSelector:infoDic[kOCAAnnotationConfigKeyMethodSelector]
                                     type:infoDic[kOCAAnnotationConfigKeyType]];
    return anno;
}

- (instancetype)initWithSourceFile:(NSString*)sourceFile
                         className:(NSString*)className
                            params:(NSDictionary*)params
                    methodSelector:(NSString*)methodSelector
                              type:(NSString*)type
{
    self = [super initWithSourceFile:sourceFile
                           className:className
                              params:params
                            position:OCAAnnotationPositionMethod
                                type:type];
    if (self) {
        self.selectorString = methodSelector;
        self.postion = OCAAnnotationPositionMethod;
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
    if (!self.selectorString || [self.selectorString length] == 0) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@_%@_%@_%@",
            @(OCAAnnotationPositionMethod),
            self.typeString,
            self.className,
            self.selectorString];
}
@end
