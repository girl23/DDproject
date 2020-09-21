//
//  FlutterNativeSignPlugin.m
//  Runner
//
//  Created by 赵王杰 on 2020/5/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface NetHttpRequestClient : AFHTTPSessionManager;
+ (instancetype)sharedClient;
@end
