//
//  Colors.h
//  Runner
//
//  Created by 赵王杰 on 2020/5/18.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Colors : NSObject

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromARGB(argbValue) [UIColor colorWithRed:((float)((argbValue & 0xFF0000) >> 16))/255.0 green:((float)((argbValue & 0xFF00) >> 8))/255.0 blue:((float)(argbValue & 0xFF))/255.0 alpha:((float)((argbValue & 0xFF000000) >> 24))/255.0]

#define COLOR_ffffff UIColorFromRGB(0Xffffff)
#define COLOR_1499f7 UIColorFromRGB(0X1499f7)
#define COLOR_0488e5 UIColorFromRGB(0X0488e5)
#define COLOR_e0e0e0 UIColorFromRGB(0Xe0e0e0)
#define COLOR_333333 UIColorFromRGB(0X333333)
#define COLOR_0f191919 UIColorFromARGB(0X0f191919)

@end
