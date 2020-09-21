//
//  FlutterNativeSignPlugin.m
//  Runner
//
//  Created by 赵王杰 on 2020/5/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "NetRequestClass.h"
#import "NetHttpRequestClient.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "JSONKit.h"

@implementation NetRequestClass

#pragma 监测网络的可链接性
+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl{
    __block BOOL netState = NO;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                netState = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netState = NO;
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
    
    return netState;
}

#pragma --mark POST请求方式

+(NSURLSessionDataTask *)NetRequestPostWithMethod:(NSString *)methodName
                                       parameters:(NSDictionary *)parameters
                                      returnBlock:(ReturnValueBlock)valueBlock
                                       errorBlock:(ErrorCodeBlock)errorBlock{
    
    NetHttpRequestClient *client = [NetHttpRequestClient sharedClient];
    client.requestSerializer =  [AFHTTPRequestSerializer serializer];

    
    NSString *requestUrl = [NSString stringWithFormat:@"%@",methodName];
    //启动请求
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [client POST:requestUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        NSString *theResponse = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
        NSDictionary *dataDoc = [theResponse objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];

        NetManager *manager   = [[NetManager alloc]init];
        manager.rawData = dataDoc;
        valueBlock(manager);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf doErrorWithTask:task error:error errorBlock:errorBlock];
    }];
    return dataTask;
}

+ (NSURLSessionDataTask *)netRequestGetWithUrl:(NSString *)url
                                    parameters:(NSDictionary *)parameters
                                   returnBlock:(ReturnValueBlock)valueBlock
                                    errorBlock:(ErrorCodeBlock)errorBlock{
    NetHttpRequestClient *client = [NetHttpRequestClient sharedClient];
    client.requestSerializer =  [AFHTTPRequestSerializer serializer];
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [client GET:url parameters:parameters
       progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *theResponse = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
        NSDictionary *dataDoc = [theResponse objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];

        NetManager *manager   = [[NetManager alloc]init];
        manager.rawData = dataDoc;
        valueBlock(manager);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf doErrorWithTask:task error:error errorBlock:errorBlock];
    }];
    return dataTask;
    
}

+(void)doErrorWithTask:(NSURLSessionDataTask *)dataTask error:(NSError *)error errorBlock:(ErrorCodeBlock)errorBlock{
    if(dataTask){
        [dataTask cancel];
        dataTask = nil;
    }
    NSInteger code = error.code;
    if(code == NSURLErrorCancelled){//取消
        return;
    }else if(code == NSURLErrorTimedOut){//超时
        errorBlock(NetErrorCodeTimeOut);
        return;
    }
    NSDictionary *userInfo      = error.userInfo;//NSURLErrorCancelled
    NSHTTPURLResponse *response = userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    if(response.statusCode == 404){
        errorBlock(NetErrorCode404);
    }else if(response.statusCode > 500){
        errorBlock(NetErrorCode500);
    }else{
        errorBlock(NetErrorCodeOther);
    }
}

@end
