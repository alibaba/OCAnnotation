/**
 * Created by OCAnnotation.
 * Copyright (c) 2017, Ant Financial Wealth Mobile Team. All rights reserved.
 *
 * This source code is licensed under the Apache.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

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
