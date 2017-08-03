//
//  AFWLogFileManagerDefault.h
//  AFWealth
//
//  Created by lianjie.lj on 1/25/16.
//  Copyright © 2016 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>


// The LogFileManager protocol is designed to allow you to control all aspects of your log files.
//
// The primary purpose of this is to allow you to do something with the log files after they have been rolled.
// Perhaps you want to compress them to save disk space.
// Perhaps you want to upload them to an FTP server.
// Perhaps you want to run some analytics on the file.
//
// A default LogFileManager is, of course, provided.
// The default LogFileManager simply deletes old log files according to the maximumNumberOfLogFiles property.
//
// This protocol provides various methods to fetch the list of log files.
//
// There are two variants: sorted and unsorted.
// If sorting is not necessary, the unsorted variant is obviously faster.
// The sorted variant will return an array sorted by when the log files were created,
// with the most recently created log file at index 0, and the oldest log file at the end of the array.
//
// You can fetch only the log file paths (full path including name), log file names (name only),
// or an array of AFWLogFileInfo objects.
// The AFWLogFileInfo class is documented below, and provides a handy wrapper that
// gives you easy access to various file attributes such as the creation date or the file size.

@protocol AFWLogFileManagerProtocol <NSObject>
@required

// Public properties

/**
 * The maximum number of archived log files to keep on disk.
 * For example, if this property is set to 3,
 * then the LogFileManager will only keep 3 archived log files (plus the current active log file) on disk.
 * Once the active log file is rolled/archived, then the oldest of the existing 3 rolled/archived log files is deleted.
 *
 * You may optionally disable this option by setting it to zero.
 **/
@property (readwrite, assign, atomic) NSUInteger maximumNumberOfLogFiles;

/**
 * The maximum space that logs can take. On rolling logfile all old logfiles that exceed logFilesDiskQuota will
 * be deleted.
 *
 * You may optionally disable this option by setting it to zero.
 **/
@property (readwrite, assign, atomic) unsigned long long logFilesDiskQuota;

// Public methods

- (NSString *)logsDirectory;

- (NSArray *)unsortedLogFilePaths;
- (NSArray *)unsortedLogFileNames;
- (NSArray *)unsortedLogFileInfos;

- (NSArray *)sortedLogFilePaths;
- (NSArray *)sortedLogFileNames;
- (NSArray *)sortedLogFileInfos;

// Private methods (only to be used by AFWFileLogger)

- (NSString *)createNewLogFile;

@optional

// Notifications from AFWFileLogger

- (void)didArchiveLogFile:(NSString *)logFilePath;
- (void)didRollAndArchiveLogFile:(NSString *)logFilePath;

@end


/**
 * Default log file manager.
 *
 * All log files are placed inside the logsDirectory.
 * If a specific logsDirectory isn't specified, the default directory is used.
 * On Mac, this is in ~/Library/Logs/<Application Name>.
 * On iPhone, this is in ~/Library/Caches/Logs.
 *
 * Log files are named "<bundle identifier> <date> <time>.log"
 * Example: com.organization.myapp 2013-12-03 17-14.log
 *
 * Archived log files are automatically deleted according to the maximumNumberOfLogFiles property.
 **/
@interface AFWLogFileManagerDefault : NSObject <AFWLogFileManagerProtocol>

- (instancetype)init;
- (instancetype)initWithTag:(NSString *)tag;
#if TARGET_OS_IPHONE
///*
// * Calling this constructor you can override the default "automagically" chosen NSFileProtection level.
// * Useful if you are writing a command line utility / CydiaSubstrate addon for iOS that has no NSBundle
// * or like SpringBoard no BackgroundModes key in the NSBundle:
// *    iPhone:~ root# cycript -p SpringBoard
// *    cy# [NSBundle mainBundle]
// *    #"NSBundle </System/Library/CoreServices/SpringBoard.app> (loaded)"
// *    cy# [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIBackgroundModes"];
// *    null
// *    cy#
// **/
//- (instancetype)initWithLogsDirectory:(NSString *)logsDirectory defaultFileProtectionLevel:(NSString *)fileProtectionLevel;
#endif

/*
 * Methods to override.
 *
 * Log files are named "<bundle identifier> <date> <time>.log"
 * Example: com.organization.myapp 2013-12-03 17-14.log
 *
 * If you wish to change default filename, you can override following two methods.
 * - newLogFileName method would be called on new logfile creation.
 * - isLogFile: method would be called to filter logfiles from all other files in logsDirectory.
 *   You have to parse given filename and return YES if it is logFile.
 *
 * **NOTE**
 * newLogFileName returns filename. If appropriate file already exists, number would be added
 * to filename before extension. You have to handle this case in isLogFile: method.
 *
 * Example:
 * - newLogFileName returns "com.organization.myapp 2013-12-03.log",
 *   file "com.organization.myapp 2013-12-03.log" would be created.
 * - after some time "com.organization.myapp 2013-12-03.log" is archived
 * - newLogFileName again returns "com.organization.myapp 2013-12-03.log",
 *   file "com.organization.myapp 2013-12-03 2.log" would be created.
 * - after some time "com.organization.myapp 2013-12-03 1.log" is archived
 * - newLogFileName again returns "com.organization.myapp 2013-12-03.log",
 *   file "com.organization.myapp 2013-12-03 3.log" would be created.
 **/
@property (readonly, copy) NSString *newLogFileName;
- (BOOL)isLogFile:(NSString *)fileName;

/* Inherited from AFWLogFileManagerProtocol:
 
 @property (readwrite, assign, atomic) NSUInteger maximumNumberOfLogFiles;
 @property (readwrite, assign, atomic) NSUInteger logFilesDiskQuota;
 
 - (NSString *)logsDirectory;
 
 - (NSArray *)unsortedLogFilePaths;
 - (NSArray *)unsortedLogFileNames;
 - (NSArray *)unsortedLogFileInfos;
 
 - (NSArray *)sortedLogFilePaths;
 - (NSArray *)sortedLogFileNames;
 - (NSArray *)sortedLogFileInfos;
 
 */

@end
