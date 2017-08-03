//
//  OCABaseAnnotation.h
//  AFWealth
//
//  Created by lianjie.lj on 10/30/15.
//  Copyright © 2015 Alipay. All rights reserved.
//

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
 *    @brief annotation是否符合几个参数条件
 *
 *    @param position   if OCAAnnotationPositionUnknown 则不做限制
 *    @param className  if nil or empty 则不做限制
 *    @param typeString if nil or empty 则不做限制
 *
 *    @return YES or NO
 */
- (BOOL)isAnnotationMatchPosition:(OCAAnnotationPosition)position
                        className:(NSString*)className
                       typeString:(NSString*)typeString;

/**
 *    @brief 同一位置同一type的Annotation允许出现多个，这种场景下会将这样的多个Annotation分为一组，
 *           分组的规则就是这个Key的实现，key相同的会分为一组<br/>
 *           子类实现该方法
 *
 *    @return 
 */
- (NSString*)groupKey;
@end
