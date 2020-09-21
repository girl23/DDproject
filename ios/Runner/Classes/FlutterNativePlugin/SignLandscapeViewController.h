//
//  SignLandscapeViewController.h
//  Runner
//
//  Created by 赵王杰 on 2020/5/18.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SealSignAPI.h"
#import "SignDataModel.h"
 

typedef void(^SignReturnBlock)(int type, NSString *signImage);




//NS_ASSUME_NONNULL_BEGIN

@interface SignLandscapeViewController : UIViewController

@property (copy,nonatomic) SignReturnBlock signReturnBlock;

//-(instancetype)initWithSignView:(UIView *)signView signApi:(SealSignAPI *)signApi;

-(void)setSignDataArray:(NSArray *)signDataArray;

-(void)setSignDataModel:(SignDataModel *)signDataModel;

-(void)setUserId:(NSString *)userId;

-(void)setUrl:(NSString *)url;
@end

//NS_ASSUME_NONNULL_END
