//
//  FlutterNativeSignPlugin.m
//  Runner
//
//  Created by 赵王杰 on 2020/5/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "NetHttpRequestClient.h"

@implementation NetHttpRequestClient

+ (instancetype)sharedClient {
    static NetHttpRequestClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [NetHttpRequestClient manager];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [securityPolicy setValidatesDomainName:NO];
        _sharedClient.securityPolicy = securityPolicy;
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedClient.requestSerializer.timeoutInterval = 40.0f;
    });
    return _sharedClient;
}

@end
