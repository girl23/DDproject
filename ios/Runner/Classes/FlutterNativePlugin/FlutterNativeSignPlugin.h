//
//  FlutterNativeSignPlugin.h
//  Runner
//
//  Created by 赵王杰 on 2020/5/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>


@interface FlutterNativeSignPlugin : UIViewController

+(instancetype _Nullable )shareInstance;

-(void)registMethod:(FlutterViewController * _Nonnull)controller;

@end

