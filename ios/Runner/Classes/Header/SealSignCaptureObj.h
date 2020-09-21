//
//  SealSignCaptureObj.h
//  SignAPI
//
//  Created by pingwanhui on 15/8/26.
//  Copyright (c) 2015年 pingwanhui. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Signer.h"
#import "OCRCaptureObj.h"
typedef NS_ENUM(NSInteger, SignType) {
    SignType_SIGN = 0,
    SignType_MUTISIGN
};
@interface SealSignCaptureObj : NSObject
@property (nonatomic, assign) int index;//0-99
@property (nonatomic, strong) Signer *signer;//签名人
@property (nonatomic, strong) UIColor *strokeColor;//笔颜色
@property (nonatomic, assign) float strokeWidth;//笔粗细
@property (nonatomic, assign) CGSize SignImageSize;//获得图片大小
@property (nonatomic, assign) float scale;//图片压缩比
@property (nonatomic, strong) UIColor *titleColor;//标题字体颜色
@property (nonatomic, assign) float titleFont;//标题字体大小
@property (nonatomic, strong) NSString *titleTxt;//设置标题文字
@property (nonatomic, assign) SignType signType;//签名规则
@property (nonatomic, assign) int lineMax;//一行最多多少个字
@property (nonatomic, assign) BOOL isViewMyself;//是否自定义签名框
@property (nonatomic, copy) NSString *isTss;//是否加盖时间戳
@property (nonatomic, copy)  NSString *remindTitle;//单签名框中上部提醒文字
@property (nonatomic, assign)int titleSpanFromOffset;//单签名框中需要突出显示部分的起始位置
@property (nonatomic, assign)int titleSpanToOffset;//单签名框中需要突出显示部分的结束位置
@property (nonatomic, strong) OCRCaptureObj *ocrCaptureObj;
@end
