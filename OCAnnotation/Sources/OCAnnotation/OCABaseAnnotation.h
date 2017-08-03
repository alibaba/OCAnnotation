/**
 * Created by OCAnnotation.
 * Copyright (c) 2017, Ant Financial Wealth Mobile Team. All rights reserved.
 *
 * This source code is licensed under the Apache.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OCAAnnotationPosition) {
    OCAAnnotationPositionUnknown = 0,
    OCAAnnotationPositionClass,
    OCAAnnotationPositionProperty,
    OCAAnnotationPositionMethod
};

extern OCAAnnotationPosition OCAAnnotationPositionFromString(NSString* positionString);

@interface OCABaseAnnotation : NSObject

@property(nonatomic, strong) NSString *sourceFile;
@property(nonatomic, strong) NSString *className;
@property(nonatomic, assign) OCAAnnotationPosition postion;
@property(nonatomic, strong) NSString *typeString;
@property(nonatomic, copy) void (^onAnnotationCreated)(OCABaseAnnotation *anno);

- (instancetype)initWithSourceFile:(NSString*)sourceFile
                         className:(NSString*)className
                            params:(NSDictionary*)params
                          position:(OCAAnnotationPosition)position
                              type:(NSString*)type;

- (NSDictionary*)parameters;


/**
 Check if annotation matches the given parameters

 @param position    annotation position
 @param className   related class
 @param typeString  annotation type
 @return            checking result
 */
- (BOOL)isAnnotationMatchPosition:(OCAAnnotationPosition)position
                        className:(NSString*)className
                       typeString:(NSString*)typeString;

/**
 Multiple annotations of the same type at the same position are suppoted. In this situation, we group these annotations together, and use this key to index the group. You could overwrite this method to define your own group key.

 @return   group key
 */
- (NSString*)groupKey;
@end
