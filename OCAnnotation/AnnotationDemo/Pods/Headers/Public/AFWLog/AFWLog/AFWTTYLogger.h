// Software License Agreement (BSD License)
//
// Copyright (c) 2010-2014, Deusty, LLC
// All rights reserved.
//
// Redistribution and use of this software in source and binary forms,
// with or without modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// * Neither the name of Deusty nor the names of its contributors may be used
//   to endorse or promote products derived from this software without specific
//   prior written permission of Deusty, LLC.

/**
 * This class provides a logger for Terminal output or Xcode console output,
 * depending on where you are running your code.
 *
 * As described in the "Getting Started" page,
 * the traditional NSLog() function directs it's output to two places:
 *
 * - Apple System Log (so it shows up in Console.app)
 * - StdErr (if stderr is a TTY, so log statements show up in Xcode console)
 *
 * To duplicate NSLog() functionality you can simply add this logger and an asl logger.
 * However, if you instead choose to use file logging (for faster performance),
 * you may choose to use only a file logger and a tty logger.
 **/

#import "AFWLogManager.h"
#import "AFWAbstractLogger.h"
#import <UIKit/UIColor.h>
#define AFWLogMakeColor(r, g, b) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f]


@interface AFWTTYLogger : AFWAbstractLogger <AFWLoggerProtocol>

+ (instancetype)sharedInstance;

/* Inherited from the AFWLogger protocol:
 *
 * Formatters may optionally be added to any logger.
 *
 * If no formatter is set, the logger simply logs the message as it is given in logMessage,
 * or it may use its own built in formatting style.
 *
 * More information about formatters can be found here:
 * Documentation/CustomFormatters.md
 *
 * The actual implementation of these methods is inherited from AFWAbstractLogger.

   - (id <AFWLogFormatterProtocol>)logFormatter;
   - (void)setLogFormatter:(id <AFWLogFormatterProtocol>)formatter;

 */

/**
 * Want to use different colors for different log levels?
 * Enable this property.
 *
 * If you run the application via the Terminal (not Xcode),
 * the logger will map colors to xterm-256color or xterm-color (if available).
 *
 * Xcode does NOT natively support colors in the Xcode debugging console.
 * You'll need to install the XcodeColors plugin to see colors in the Xcode console.
 * https://github.com/robbiehanson/XcodeColors
 *
 * The default value is NO.
 **/
@property (readwrite, assign) BOOL colorsEnabled;

/**
 * When using a custom formatter you can set the logMessage method not to append
 * '\n' character after each output. This allows for some greater flexibility with
 * custom formatters. Default value is YES.
 **/

@property(readwrite, assign) BOOL automaticallyAppendNewlineForCustomFormatters;
/**
 *    @brief 指定隐藏的tag，未包含的tag默认不隐藏
 */
@property(nonatomic, strong) NSArray *hiddenTags;

+ (void)getRed:(CGFloat *)rPtr green:(CGFloat *)gPtr blue:(CGFloat *)bPtr fromColor:(UIColor *)color;
/**
 * The default color set (foregroundColor, backgroundColor) is:
 *
 * - AFWLogFlagError    = (red, nil)
 * - AFWLogFlagWarning = (orange, nil)
 *
 * If you run the application within Xcode, then the XcodeColors plugin is required.
 *
 **/
- (void)setForegroundColor:(UIColor *)txtColor backgroundColor:(UIColor *)bgColor forFlag:(AFWLogFlag)mask;

/**
 * Similar to the methods above, but allows you to map AFWLogMessage->tag to a particular color profile.
 * For example, you could do something like this:
 *
 * static NSString *const PurpleTag = @"PurpleTag";
 *
 * #define DDLogPurple(frmt, ...) LOG_OBJC_TAG_MACRO(NO, 0, 0, 0, PurpleTag, frmt, ##__VA_ARGS__)
 * 
 * And then where you configure CocoaLumberjack:
 *
 * purple = AFWLogMakeColor((64/255.0), (0/255.0), (128/255.0));
 *
 * or any UIColor constructor.
 *
 * [[AFWTTYLogger sharedInstance] setForegroundColor:purple backgroundColor:nil forTag:PurpleTag];
 * [AFWLogManager addLogger:[AFWTTYLogger sharedInstance]];
 *
 * This would essentially give you a straight NSLog replacement that prints in purple:
 *
 * DDLogPurple(@"I'm a purple log message!");
 **/
- (void)setForegroundColor:(UIColor *)txtColor backgroundColor:(UIColor *)bgColor forTag:(id <NSCopying>)tag;

/**
 * Clearing color profiles.
 **/
- (void)clearColorsForFlag:(AFWLogFlag)mask;
- (void)clearColorsForTag:(id <NSCopying>)tag;
- (void)clearColorsForAllFlags;
- (void)clearColorsForAllTags;
- (void)clearAllColors;

@end
