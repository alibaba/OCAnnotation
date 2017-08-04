#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "OCAAnnotation.h"
#import "OCAAnnotationDefines.h"
#import "OCAAnnotationManager.h"
#import "OCABaseAnnotation.h"
#import "OCABaseClassAnnotation.h"
#import "OCABaseMethodAnnotation.h"
#import "OCABasePropertyAnnotation.h"

FOUNDATION_EXPORT double OCAnnotationVersionNumber;
FOUNDATION_EXPORT const unsigned char OCAnnotationVersionString[];

