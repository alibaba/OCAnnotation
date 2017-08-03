/**
 * Created by OCAnnotation.
 * Copyright (c) 2017, Ant Financial Wealth Mobile Team. All rights reserved.
 *
 * This source code is licensed under the Apache.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import "OCABasePropertyAnnotation.h"
#import "OCAAnnotationDefines.h"
#import "OCAAnnotationManager.h"

@implementation OCABasePropertyAnnotation
+ (instancetype)annotationWithInfos:(NSDictionary*)infoDic
                         sourceFile:(NSString*)sourceFile
{
    NSString *type = infoDic[kOCAAnnotationConfigKeyType];
    Class clz = [[OCAAnnotationManager sharedManager]
                 annotationClassForTypeString:type
                 position:OCAAnnotationPositionProperty];
    
    if (!clz || ![clz isSubclassOfClass:[OCABasePropertyAnnotation class]]) {
        NSAssert(NO,@"invalid class info");
        return nil;
    }
    
    OCABasePropertyAnnotation *anno = [[clz alloc]
                                       initWithSourceFile:sourceFile
                                       className:infoDic[kOCAAnnotationConfigKeyClassName]
                                       params:infoDic[kOCAAnnotationConfigKeyParams]
                                       propertyName:infoDic[kOCAAnnotationConfigKeyPropertyName]
                                       type:infoDic[kOCAAnnotationConfigKeyType]];
    return anno;
}

- (instancetype)initWithSourceFile:(NSString*)sourceFile
                         className:(NSString*)className
                            params:(NSDictionary*)params
                      propertyName:(NSString*)propertyName
                              type:(NSString*)type
{
    self = [super initWithSourceFile:sourceFile
                           className:className
                              params:params
                            position:OCAAnnotationPositionProperty
                                type:type];
    if (self) {
        self.propertyName = propertyName;
        self.postion = OCAAnnotationPositionProperty;
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
    if (!self.propertyName || [self.propertyName length] == 0) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@_%@_%@_%@",
            @(OCAAnnotationPositionProperty),
            self.typeString,
            self.className,
            self.propertyName];
}
@end
