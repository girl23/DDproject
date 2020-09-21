//
//  SignDataModel.h
//  Runner
//
//  Created by 赵王杰 on 2020/5/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SignDataModel : NSObject

@property (nonatomic, strong) NSString *jcId;
@property (nonatomic, strong) NSString *posId;
@property (nonatomic, strong) NSString *signId;
@property (nonatomic, strong) NSString *signType;
@property (nonatomic, assign, getter=isSingle) Boolean single;
@property (nonatomic, copy) NSMutableArray *signDataArray;
@property (nonatomic, strong) NSString *offlinejcdata;

@end

