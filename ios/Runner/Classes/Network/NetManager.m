//
//  FlutterNativeSignPlugin.m
//  Runner
//
//  Created by 赵王杰 on 2020/5/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "NetManager.h"


@implementation NetManager
-(NSDictionary *)fetchDataWithReformer:(id)reformer{
    if (reformer == nil) {
        return self.rawData;
    } else {
        return [reformer reformDataWithManager:self];
    }
}
@end
