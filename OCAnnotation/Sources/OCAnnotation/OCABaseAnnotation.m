/**
 * Created by OCAnnotation.
 * Copyright (c) 2017, Ant Financial Wealth Mobile Team. All rights reserved.
 *
 * This source code is licensed under the Apache.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import "OCABaseAnnotation.h"
#import "OCAAnnotationDefines.h"

extern OCAAnnotationPosition OCAAnnotationPositionFromString(NSString* positionString)
{
    if (!positionString || [positionString length] == 0) {
        return OCAAnnotationPositionUnknown;
    }
    
    if ([positionString isEqualToString:kOCAAnnotationPositionPropertyString]) {
        return OCAAnnotationPositionProperty;
    }
    
    if ([positionString isEqualToString:kOCAAnnotationPositionMethodString]) {
        return OCAAnnotationPositionMethod;
    }
    
    if ([positionString isEqualToString:kOCAAnnotationPositionClassString]) {
        return OCAAnnotationPositionClass;
    }
    return OCAAnnotationPositionUnknown;
}


@interface OCABaseAnnotation ()

@property(nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation OCABaseAnnotation

- (instancetype)initWithSourceFile:(NSString*)sourceFile
                         className:(NSString*)className
                            params:(NSDictionary*)params
                          position:(OCAAnnotationPosition)position
                              type:(NSString*)type
{
    self = [super init];
    if (self) {
        self.sourceFile = sourceFile;
        self.className = className;
        _parameters = [[NSMutableDictionary alloc] init];
        if (params && [params count] > 0) {
            [_parameters addEntriesFromDictionary:params];
        }
        self.typeString = type;
    }
    return self;
}

#pragma mark - public method

- (BOOL)isAnnotationMatchPosition:(OCAAnnotationPosition)position
                        className:(NSString*)className
                       typeString:(NSString*)typeString
{
    BOOL shouldCheckPosition = (position != OCAAnnotationPositionUnknown);
    BOOL shouldCheckClassName = (className && [className length] > 0);
    BOOL shouldCheckTypeString = (typeString && [typeString length] > 0);
    
    if (shouldCheckPosition && position != self.postion) {
        return NO;
    }
    
    if (shouldCheckClassName && ![self.className isEqualToString:className]) {
        return NO;
    }
    
    if (shouldCheckTypeString && ![self.typeString isEqualToString:typeString]) {
        return NO;
    }
    return YES;
}

- (NSString*)groupKey
{
    NSAssert(NO,@"implement this in subclass");
    return nil;
}
@end
