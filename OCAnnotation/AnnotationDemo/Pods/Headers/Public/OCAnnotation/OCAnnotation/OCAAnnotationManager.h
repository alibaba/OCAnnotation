//
//  AFWAnnotationManager.h
//  AFWealth
//
//  Created by lianjie.lj on 10/30/15.
//  Copyright © 2015 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCABaseAnnotation.h"

@interface OCAAnnotationManager : NSObject

+ (instancetype)sharedManager;

/**
 *    @brief 通用Annotation查询接口
 *
 *    @param position   if OCAAnnotationPositionUnknown 则不做限制
 *    @param className  if nil or empty 则不做限制
 *    @param typeString if nil or empty 则不做限制
 *
 *    @return array of annotation infos(subclass of OCABaseAnnotation)
 */
- (NSArray*)annotationInfosWithPosition:(OCAAnnotationPosition)position
                              className:(NSString*)className
                             typeString:(NSString*)typeString;

- (BOOL)registerAnnotationType:(NSString*)typeString
                      position:(OCAAnnotationPosition)position
                         class:(Class)annoClass;

- (void)addConfigsWithConfigDic:(NSDictionary*)configDic;

- (Class)annotationClassForTypeString:(NSString*)typeString
                             position:(OCAAnnotationPosition)position;
@end
