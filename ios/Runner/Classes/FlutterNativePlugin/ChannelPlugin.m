//
//  ChannelPlugin.m
//  Runner
//
//  Created by 赵王杰 on 2020/5/18.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "ChannelPlugin.h"

@implementation ChannelPlugin


static NSString *METHOD_NAME_GET_CHANNEL = @"getChannel";


static ChannelPlugin *_instance;

+(instancetype)shareInstance{
    return [[self alloc]init];
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}


-(void)registMethod:(FlutterViewController *)controller{
    //注册方法调用通道(Flutter ——> Native)
    FlutterMethodChannel *signChannel = [FlutterMethodChannel methodChannelWithName:@"plugins.com.ameco.lop/get_channel" binaryMessenger:controller.binaryMessenger];
    __weak typeof(self) weakSelf = self;
    [signChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        [weakSelf channelFlutterMethodCall:call flutterResult:result];
    }];

}


-(void)channelFlutterMethodCall:(FlutterMethodCall * _Nonnull) call flutterResult:(FlutterResult _Nonnull) result{
    NSString *methodName = call.method;
    if([METHOD_NAME_GET_CHANNEL isEqualToString:methodName]){
        result(@"iOS");
    }else{
        result(FlutterMethodNotImplemented);
    }
}

@end
