//
//  SealCommentCaptureObj.h
//  SignAPI
//
//  Created by BJCA on 15/11/3.
//  Copyright © 2015年 pingwanhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Signer.h"
#import "OCRCaptureObj.h"
@interface SealCommentCaptureObj : NSObject

@property (nonatomic, assign) int index;//0-99
@property (nonatomic, strong) Signer *signer;//签名人
@property (nonatomic, strong) UIColor *strokeColor;//笔颜色
@property (nonatomic, assign) float strokeWidth;//笔粗细
@property (nonatomic, assign) CGSize SignImageSize;//获得图片大小
@property (nonatomic, assign) float scale;//图片压缩比
@property (nonatomic, assign) int lineMax;//生成签名图片一行多少个字
@property (nonatomic, assign) BOOL isEcho;//确认签名后是否回显签名内容
@property (nonatomic, copy) NSString *isTss;//是否加盖时间戳

@end
