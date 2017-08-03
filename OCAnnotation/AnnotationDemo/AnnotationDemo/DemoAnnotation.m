/**
 * Created by OCAnnotation.
 * Copyright (c) 2017, Ant Financial Wealth Mobile Team. All rights reserved.
 *
 * This source code is licensed under the Apache.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import "DemoAnnotation.h"

@interface DemoAnnotation ()

@property(nonatomic, strong) NSString *remoteLogId;

@end

@implementation DemoAnnotation

- (instancetype)initWithSourceFile:(NSString *)sourceFile
                         className:(NSString *)className
                            params:(NSDictionary *)params
                    methodSelector:(NSString *)methodSelector
                              type:(NSString *)type
{
    self = [super initWithSourceFile:sourceFile
                           className:className
                              params:params
                      methodSelector:methodSelector
                                type:type];
    if (self) {
        self.remoteLogId = self.parameters[@"remoteLogId"];
        
        __weak typeof(self) weakSelf = self;
        self.onAnnotationCreated = ^(OCABaseAnnotation *anno){
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf registerRemoteLogAOP];
        };
    }
    return self;
}

- (void)registerRemoteLogAOP
{
    if (_remoteLogId && [_remoteLogId length] > 0) {
        //  register remote log AOP
        
        return;
    }
}

@end
