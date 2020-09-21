//
//  ChannelPlugin.h
//  Runner
//
//  Created by 赵王杰 on 2020/5/18.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChannelPlugin : NSObject

+(instancetype _Nullable )shareInstance;

-(void)registMethod:(FlutterViewController * _Nonnull)controller;

@end

NS_ASSUME_NONNULL_END
