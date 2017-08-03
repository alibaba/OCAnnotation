/**
 * Created by OCAnnotation.
 * Copyright (c) 2017, Ant Financial Wealth Mobile Team. All rights reserved.
 *
 * This source code is licensed under the Apache.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import <OCAnnotation/OCAAnnotation.h>

@interface DemoAnnotation : OCABaseMethodAnnotation

- (instancetype)initWithSourceFile:(NSString *)sourceFile
                         className:(NSString *)className
                            params:(NSDictionary *)params
                    methodSelector:(NSString *)methodSelector
                              type:(NSString *)type;

@end
