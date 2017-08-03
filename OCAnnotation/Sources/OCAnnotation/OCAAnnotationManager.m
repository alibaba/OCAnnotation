/**
 * Created by OCAnnotation.
 * Copyright (c) 2017, Ant Financial Wealth Mobile Team. All rights reserved.
 *
 * This source code is licensed under the Apache.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import "OCAAnnotationManager.h"
#import "OCAAnnotationDefines.h"
#import "OCABaseClassAnnotation.h"
#import "OCABaseMethodAnnotation.h"
#import "OCABasePropertyAnnotation.h"

@interface OCAAnnotationManager ()

@property(nonatomic, strong) NSMutableDictionary *annotationGroupDic;                  //以annotationKey进行分组
@property(nonatomic, strong) NSMutableDictionary *classAnnotationTypeInfos;
@property(nonatomic, strong) NSMutableDictionary *propertyAnnotationTypeInfos;
@property(nonatomic, strong) NSMutableDictionary *methodAnnotationTypeInfos;
@property(nonatomic, strong) NSMutableDictionary *registeredAnnotationClassDic;

@end

@implementation OCAAnnotationManager

+ (instancetype)sharedManager
{
    static OCAAnnotationManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[OCAAnnotationManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.annotationGroupDic = [[NSMutableDictionary alloc] init];
        self.classAnnotationTypeInfos = [[NSMutableDictionary alloc] init];
        self.propertyAnnotationTypeInfos = [[NSMutableDictionary alloc] init];
        self.methodAnnotationTypeInfos = [[NSMutableDictionary alloc] init];
        self.registeredAnnotationClassDic = [[NSMutableDictionary alloc] init];
        [self registerDefaultTypes];
    }
    return self;
}

#pragma mark - public methods

- (NSArray<OCABaseAnnotation *> *)annotationInfosWithPosition:(OCAAnnotationPosition)position
                              className:(NSString*)className
                             typeString:(NSString*)typeString
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    @synchronized(_annotationGroupDic) {
        for (NSString *annotationKey in self.annotationGroupDic) {
            NSArray *group = self.annotationGroupDic[annotationKey];
            for (OCABaseAnnotation *anno in group) {
                if (![anno isAnnotationMatchPosition:position
                                           className:className
                                          typeString:typeString]) {
                    continue;
                }
                [resultArray addObject:anno];
            }
        }
    }
    return resultArray;
}
- (BOOL)registerAnnotationType:(NSString*)typeString
                      position:(OCAAnnotationPosition)position
                         class:(Class)annoClass
{
    if (!typeString || [typeString length] == 0) {
        return NO;
    }
    
    if (!annoClass || ![annoClass isSubclassOfClass:[OCABaseAnnotation class]]) {
        return NO;
    }
    
    NSMutableDictionary *typeInfos = nil;
    switch (position) {
        case OCAAnnotationPositionClass:{
            typeInfos = self.classAnnotationTypeInfos;
            break;
        }
        case OCAAnnotationPositionProperty:{
            typeInfos = self.propertyAnnotationTypeInfos;
            break;
        }
        case OCAAnnotationPositionMethod:{
            typeInfos = self.methodAnnotationTypeInfos;
            break;
        }
        case OCAAnnotationPositionUnknown:{
            break;
        }
    }
    if (!typeInfos) {
        return NO;
    }
    
    typeInfos[typeString] = NSStringFromClass(annoClass);
    return YES;
}

- (void)addConfigsWithConfigDic:(NSDictionary*)configDic
{
    if (!configDic || [configDic count] == 0) {
        NSAssert(NO, @"invalid config dic");
        return;
    }
    NSDictionary *configs = [NSDictionary dictionaryWithDictionary:configDic];
    if (!configs || ![configs isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSMutableDictionary *currentAnnoGroupDic = [[NSMutableDictionary alloc] init];
    for (NSString *sourceFile in configs) {
        NSArray *infos = configs[sourceFile];
        for (NSDictionary *annoInfo in infos) {
            NSString *positionString = annoInfo[@"position"];
            OCABaseAnnotation *anno = nil;
            OCAAnnotationPosition position = OCAAnnotationPositionFromString(positionString);
            
            switch (position) {
                case OCAAnnotationPositionClass:{
                    anno = [OCABaseClassAnnotation annotationWithInfos:annoInfo
                                                            sourceFile:sourceFile];
                    break;
                }
                case OCAAnnotationPositionMethod:{
                    anno = [OCABaseMethodAnnotation annotationWithInfos:annoInfo
                                                             sourceFile:sourceFile];
                    break;
                }
                case OCAAnnotationPositionProperty:{
                    anno = [OCABasePropertyAnnotation annotationWithInfos:annoInfo
                                                               sourceFile:sourceFile];
                    break;
                }
                case OCAAnnotationPositionUnknown:{
                    break;
                }
            }
            
            if (!anno) {
                NSAssert(NO,@"something wrong here: invalid annotation info");
                continue;
            }
            //规则：className_position_type作为唯一key进行分组
            NSString *key  = [anno groupKey];
            if (!key) {
                NSAssert(NO,@"something wrong here: invalid annotation group key");
                continue;
            }
            
            NSMutableArray *annoGroup = currentAnnoGroupDic[key];
            if (!annoGroup) {
                annoGroup = [[NSMutableArray alloc] init];
            }
            [annoGroup addObject:anno];
            
            currentAnnoGroupDic[key] = annoGroup;
        }
    }
    
    @synchronized(_annotationGroupDic) {
        [_annotationGroupDic addEntriesFromDictionary:currentAnnoGroupDic];
        
        //trigger annotation`s onCreate method
        [self triggerOnCreatedJobWithGroupDic:currentAnnoGroupDic];
    }
    
}

#pragma mark - private methods

- (void)triggerOnCreatedJobWithGroupDic:(NSDictionary*)groupDic
{
    for (NSString *annotationKey in groupDic) {
        NSArray *group = groupDic[annotationKey];
        for (OCABaseAnnotation *anno in group) {
            if (!anno.onAnnotationCreated) {
                continue;
            }
            anno.onAnnotationCreated(anno);
        }
    }
}

#pragma mark - private methods: register related

- (void)registerDefaultTypes
{
    [self registerAnnotationType:kOCAAnnotationDefaultTypeString
                        position:OCAAnnotationPositionClass
                           class:[OCABaseClassAnnotation class]];
    [self registerAnnotationType:kOCAAnnotationDefaultTypeString
                        position:OCAAnnotationPositionProperty
                           class:[OCABasePropertyAnnotation class]];
    [self registerAnnotationType:kOCAAnnotationDefaultTypeString
                        position:OCAAnnotationPositionMethod
                           class:[OCABaseMethodAnnotation class]];
}

- (Class)annotationClassForTypeString:(NSString*)typeString
                             position:(OCAAnnotationPosition)position
{
    if (!typeString || [typeString length] == 0) {
        return nil;
    }
    
    NSMutableDictionary *typeInfos = nil;
    switch (position) {
        case OCAAnnotationPositionClass:{
            typeInfos = self.classAnnotationTypeInfos;
            break;
        }
        case OCAAnnotationPositionProperty:{
            typeInfos = self.propertyAnnotationTypeInfos;
            break;
        }
        case OCAAnnotationPositionMethod:{
            typeInfos = self.methodAnnotationTypeInfos;
            break;
        }
        case OCAAnnotationPositionUnknown:{
            break;
        }
    }
    if (!typeInfos) {
        return nil;
    }

    NSString *classString = typeInfos[typeString];
    if (!classString || [classString length] == 0) {
        return nil;
    }
    return NSClassFromString(classString);
}


@end
