/**
 * Created by OCAnnotation.
 * Copyright (c) 2017, Ant Financial Wealth Mobile Team. All rights reserved.
 *
 * This source code is licensed under the Apache.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

@import UIKit;

#pragma annotation(type:"remoteLog",remoteLogId:"12345",extraInfo:"some extra info")
@interface OCAAppDelegate : UIResponder <UIApplicationDelegate>

#pragma annotation(type:"remoteLog",remoteLogId:"22222")
@property (strong, nonatomic) UIWindow *window;

@end
