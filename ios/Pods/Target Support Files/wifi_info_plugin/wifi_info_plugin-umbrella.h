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

#import "WifiInfoPlugin.h"

FOUNDATION_EXPORT double wifi_info_pluginVersionNumber;
FOUNDATION_EXPORT const unsigned char wifi_info_pluginVersionString[];

