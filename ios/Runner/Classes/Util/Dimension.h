//
//  Dimension.h
//  Runner
//
//  Created by 赵王杰 on 2020/5/18.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Dimension : NSObject

//PingFangSC的常规字体
#define SystemFontRegular(fontSize) (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_9_0)?[UIFont fontWithName:@"PingFangSC-Regular" size:fontSize]:[UIFont systemFontOfSize:fontSize]
//PingFangSC的中黑体
#define SystemFontMedium(fontSize) (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_9_0)?[UIFont fontWithName:@"PingFangSC-Medium" size:fontSize]:[UIFont boldSystemFontOfSize:fontSize]

#define isIphone4 ((CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] bounds].size)||CGSizeEqualToSize(CGSizeMake(480, 320), [[UIScreen mainScreen] bounds].size))?1:0)
#define isIphone5 ((CGSizeEqualToSize(CGSizeMake(320, 568), [[UIScreen mainScreen] bounds].size)||CGSizeEqualToSize(CGSizeMake(568, 320), [[UIScreen mainScreen] bounds].size))?1:0)
#define isIphone6 ((CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size)||CGSizeEqualToSize(CGSizeMake(667, 375), [[UIScreen mainScreen] bounds].size))?1:0)
#define isIphonePlus ((CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size)||CGSizeEqualToSize(CGSizeMake(736, 414), [[UIScreen mainScreen] bounds].size))?1:0)
#define isIphoneX_Xs ((CGSizeEqualToSize(CGSizeMake(375, 812), [[UIScreen mainScreen] bounds].size)||CGSizeEqualToSize(CGSizeMake(812, 375), [[UIScreen mainScreen] bounds].size))?1:0)
#define isIphoneXr_XsMax ((CGSizeEqualToSize(CGSizeMake(414, 896), [[UIScreen mainScreen] bounds].size)||CGSizeEqualToSize(CGSizeMake(896, 414), [[UIScreen mainScreen] bounds].size))?1:0)


#define iPhone4_5_6X_P(a,b,c,d) ((isIphone4==1)?(a) :((isIphone5==1) ? (b) : ((isIphone6 == 1)?(c) : ((isIphonePlus == 1) ?(d) : ((isIphoneX_Xs == 1) ?(c) : ((isIphoneXr_XsMax == 1) ?(d) : c))))))


@end
