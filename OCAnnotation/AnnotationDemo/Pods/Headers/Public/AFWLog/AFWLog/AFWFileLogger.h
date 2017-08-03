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

#import "AFWLogManager.h"
#import "AFWLogFileManagerDefault.h"
#import "AFWAbstractLogger.h"
@class AFWLogFileInfo;

extern BOOL doesAppRunInBackground(void);
/**
 * This class provides a logger to write log statements to a file.
 **/


// Default configuration and safety/sanity values.
//
// maximumFileSize         -> kDDDefaultLogMaxFileSize
// rollingFrequency        -> kDDDefaultLogRollingFrequency
// maximumNumberOfLogFiles -> kDDDefaultLogMaxNumLogFiles
// logFilesDiskQuota       -> kDDDefaultLogFilesDiskQuota
//
// You should carefully consider the proper configuration values for your application.

extern unsigned long long const kDDDefaultLogMaxFileSize;
extern NSTimeInterval     const kDDDefaultLogRollingFrequency;
extern NSUInteger         const kDDDefaultLogMaxNumLogFiles;
extern unsigned long long const kDDDefaultLogFilesDiskQuota;

@interface AFWFileLogger : AFWAbstractLogger <AFWLoggerProtocol>

- (instancetype)init;
- (instancetype)initWithLogFileManager:(id <AFWLogFileManagerProtocol>)logFileManager NS_DESIGNATED_INITIALIZER;

/**
 * Log File Rolling:
 *
 * maximumFileSize:
 *   The approximate maximum size to allow log files to grow.
 *   If a log file is larger than this value after a log statement is appended,
 *   then the log file is rolled.
 *
 * rollingFrequency
 *   How often to roll the log file.
 *   The frequency is given as an NSTimeInterval, which is a double that specifies the interval in seconds.
 *   Once the log file gets to be this old, it is rolled.
 *
 * Both the maximumFileSize and the rollingFrequency are used to manage rolling.
 * Whichever occurs first will cause the log file to be rolled.
 *
 * For example:
 * The rollingFrequency is 24 hours,
 * but the log file surpasses the maximumFileSize after only 20 hours.
 * The log file will be rolled at that 20 hour mark.
 * A new log file will be created, and the 24 hour timer will be restarted.
 *
 * You may optionally disable rolling due to filesize by setting maximumFileSize to zero.
 * If you do so, rolling is based solely on rollingFrequency.
 *
 * You may optionally disable rolling due to time by setting rollingFrequency to zero (or any non-positive number).
 * If you do so, rolling is based solely on maximumFileSize.
 *
 * If you disable both maximumFileSize and rollingFrequency, then the log file won't ever be rolled.
 * This is strongly discouraged.
 **/
@property (readwrite, assign) unsigned long long maximumFileSize;
@property (readwrite, assign) NSTimeInterval rollingFrequency;
@property (readwrite, assign, atomic) BOOL doNotReuseLogFiles;

/**
 * The AFWLogFileManagerProtocol instance can be used to retrieve the list of log files,
 * and configure the maximum number of archived log files to keep.
 *
 * @see AFWLogFileManagerProtocol.maximumNumberOfLogFiles
 **/
@property (strong, nonatomic, readonly) id <AFWLogFileManagerProtocol> logFileManager;

/**
 * When using a custom formatter you can set the logMessage method not to append
 * '\n' character after each output. This allows for some greater flexibility with
 * custom formatters. Default value is YES.
 **/

@property (readwrite, assign) BOOL automaticallyAppendNewlineForCustomFormatters;

// You can optionally force the current log file to be rolled with this method.
// CompletionBlock will be called on main queue.

- (void)rollLogFileWithCompletionBlock:(void (^)())completionBlock;

// Method is deprecated. Use rollLogFileWithCompletionBlock: method instead.

- (void)rollLogFile __attribute((deprecated));

// Inherited from AFWAbstractLogger

// - (id <AFWLogFormatterProtocol>)logFormatter;
// - (void)setLogFormatter:(id <AFWLogFormatterProtocol>)formatter;

/**
 * Returns the log file that should be used.
 * If there is an existing log file that is suitable,
 * within the constraints of maximumFileSize and rollingFrequency, then it is returned.
 *
 * Otherwise a new file is created and returned.
 **/
- (AFWLogFileInfo *)currentLogFileInfo;

@end
