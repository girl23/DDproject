//
//  FlutterNativeSignPlugin.m
//  Runner
//
//  Created by 赵王杰 on 2020/5/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetManager.h"
#import "NetConfig.h"

@interface NetRequestClass : NSObject

#pragma 监测网络的可链接性
+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl;

#pragma POST请求
/**
 *requestURLString：请求地址，不是全地址，类型+方法名组合而成
 *parameter：参数，参数中需要包含方法名的参数
 */
+ (NSURLSessionDataTask *) NetRequestPostWithMethod: (NSString *) methodName
                                        parameters: (NSDictionary *) parameters
                                        returnBlock: (ReturnValueBlock) block
                                        errorBlock: (ErrorCodeBlock) errorBlock;


+ (NSURLSessionDataTask *)netRequestGetWithUrl:(NSString *)url
                                    parameters:(NSDictionary *)parameters
                                  returnBlock:(ReturnValueBlock)valueBlock
                                    errorBlock:(ErrorCodeBlock)errorBlock;
@end
