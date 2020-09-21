//
//  SealSignAPI.h
//  SignAPI
//
//  Created by pingwanhui on 15/8/26.
//  Copyright (c) 2015年 pingwanhui. All rights reserved.
// 数据签名头文件

#import <Foundation/Foundation.h>
#import "SealSignCaptureObj.h"
#import "SealCommentCaptureObj.h"


@protocol CASealSignAPIDelegate;
@interface SealSignAPI : NSObject
/**
 *  SealSignAPI代理;返回签名和批注图片时使用。
 */
@property (nonatomic, assign) id<CASealSignAPIDelegate>sealSignAPIDelegate;
@property(nonatomic) BOOL isShouldAutorotate;//是否允许横屏左右旋转
/**
 *  加密算法
 */
typedef NS_ENUM(NSInteger, EncType) {
    /**
     *  RSA加密
     */
    EncType_RSA = 0,
    /**
     *  SM2加密
     */
    EncType_SM2
};

/**
 *  设置加密算法:与设置模版接口共同使用(不配置默认为RSA算法)
 */
@property (nonatomic, assign) EncType encryType;
/**
 *  证据类型
 */
typedef NS_ENUM(NSInteger, BioTypeEnum) {
    /**
     *  签名人居民身份证正面
     */
    PHOTO_SIGNER_IDENTITY_CARD_FRONT,
    /**
     *  签名人居民身份证背面
     */
    PHOTO_SIGNER_IDENTITY_CARD_BACK,
    /**
     *  签名人复述录音
     */
    SOUND_SIGNER_RETELL,
    /**
     *  签名人自定义录音
     */
    SOUND_SIGNER_OTHER
};

/**
 *  设置渠道号
 *
 *  @param channel 渠道号
 *
 *  @return 错误码
 */
- (int)setChannel:(NSString *)channel;

/**
 *  设置模版数据
 *
 *  @param data 模版数据
 *
 *  @return 错误码
 */
- (int)setOrigialContent;

/**
 *  配置签名框信息
 *
 *  @param captureObj 签名框属性
 *
 *  @return 错误码
 */
- (int)addSignCaptureObj:(SealSignCaptureObj *)captureObj;

/**
 *  配置批注框信息
 *
 *  @param captureObj 批注框属性
 *
 *  @return 错误码
 */
- (int)addCommentSignCaptureObj:(SealCommentCaptureObj *)captureObj;

/**
 *  调用签名框
 *
 *  @param index 第(0-99)个签名
 *
 *  @return 签名视图
 */
- (UIViewController *)showSignatureDialog:(int)index;

/**
 *  调用批注框
 *
 *  @param index 第(0-99)个批注
 *
 *  @return 批注视图
 */
- (UIViewController *)showCommentDialog:(int)index;

/**
 *  添加证据
 *
 *  @param signIndex 第（0-99）个签名的证据
 *  @param data      证据数据
 *  @param type      证据类型
 *
 *  @return 错误码
 */
- (int)addEvidenceWithSignIndex:(int)signIndex contentData:(NSData *)data bioType:(BioTypeEnum)type;

/**
 *  自定义签名框中使用,清除签名画布
 */
- (void)clearScreen;

/**
 *  自定义签名框中使用,签名确认
 *
 *  @return 签名图片（与加密包中图片相同）
 */
- (void)saveScreen;

/**
 *  自定义签名框中使用,取消签名
 */
- (void)cancleScreen;

/**
 *  获取上传服务端的加密请求包
 *
 *  @return 加密报文
 */
- (NSArray *)genSignRequest:(NSArray*)bags;

/**
 *  是否有打包数据
 *
 *  @return 错误码，1为返回正确
 */
- (int)isReadyToUpload;

/**
 *  获取版本号信息
 *
 *  @return 版本号
 */
- (NSString *)getVersionNumber;
/**
 *  清除API(目前未使用)
 */
- (void)resetApi;

@end

@protocol CASealSignAPIDelegate <NSObject>

/**
 *  代理方法：返回签名图片
 *
 *  @param signImage 签名图片
 */
- (void)didFinishedSign:(UIImage *)signImage;

/**
 *  代理方法：返回批注图片
 *
 *  @param commentImage 批注图片
 */
- (void)didFinishedCommentSign:(UIImage *)commentImage;

@optional
/**
 *  代理方法：取消签名视图，清除签名视图
 *
 *  @param result 参考demo实现
 *  returnKey : onSaveSign   保存（SignType_SIGN只对签名方式有效）
 *  returnKey : onCancelSign 取消
 *  returnKey : onClearSign  清屏
 *  resultCode: 0            成功
 *  resultCode: 1            失败
 *  signature : UIImage      签名图片
 *
 */
- (void)setOnSignatureResultListener:(NSDictionary *)result;
@end
