//
//  FlutterNativeSignPlugin.m
//  Runner
//
//  Created by 赵王杰 on 2020/5/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManager : NSObject

/**
 *  原始数据
 *  json和xml的返回类型为NSDictionary
 *  protocolBuffer则是NSData类型
 */
@property (nonatomic,strong)id rawData;

-(NSDictionary *)fetchDataWithReformer:(id)reformer;

@end

@protocol ReformerProtocol
-(NSDictionary *)reformDataWithManager:(NetManager *)manager;
@end
