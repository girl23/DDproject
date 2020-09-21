//
//  FlutterNativeSignPlugin.m
//  Runner
//
//  Created by 赵王杰 on 2020/5/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#ifndef NetConfig_h
#define NetConfig_h

typedef NS_ENUM(NSInteger, NetErrorCode) {
    NetErrorCodeEncryption = 1,//加密错误
    NetErrorCodeDecryption = 2,//解密错误
    NetErrorCode404 = 404,
    NetErrorCode500 = 500,
    NetErrorCodeTimeOut = 3,
    NetErrorCodeDictionaryModel = 4,//字典数据转换为model数据时错误
    NetErrorCodeOther = 5
};

typedef void (^ReturnValueBlock) (id returnValue);
typedef void (^ErrorCodeBlock) (NetErrorCode errorCode);

#endif /* NetConfig_h */
