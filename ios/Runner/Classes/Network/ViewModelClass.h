//
//  FlutterNativeSignPlugin.m
//  Runner
//
//  Created by 赵王杰 on 2020/5/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConfig.h"

@protocol ViewModelDelegate ;
@interface ViewModelClass : NSObject
//@property (strong, nonatomic) ReturnValueBlock returnBlock;
//@property (strong, nonatomic) ErrorCodeBlock   errorBlock;
//
//
//// 传入交互的Block块
//-(void) setBlockWithReturnBlock: (ReturnValueBlock) returnBlock
//                 WithErrorBlock: (ErrorCodeBlock) errorBlock;
//
@property(nonatomic, weak, nullable) id<ViewModelDelegate> delegate;

@end

@protocol ViewModelDelegate <NSObject>

@optional
//用于xml或者json数据返回
- (void)viewModelWithNetResponse:(NSDictionary * _Nullable)response withMethodName:(NSString * _Nullable)methodName;
- (void)viewModelWithNetError:(NetErrorCode)errorCode withMethodName:(NSString * _Nullable)methodName;
//用于Protobuffer数据
- (void)viewModelWithNetDataResponse:(NSData * _Nullable)response withMethodName:(NSString * _Nullable)methodName;

@end
