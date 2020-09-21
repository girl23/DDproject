//
//  SignLandscapeViewController.m
//  Runner
//
//  Created by 赵王杰 on 2020/5/18.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "SignLandscapeViewController.h"
#import "AppDelegate.h"
#import "Colors.h"
#import "UIImage+Color.h"
#import "Dimension.h"
#import "NetRequestClass.h"

@interface SignLandscapeViewController ()//<CASealSignAPIDelegate>

@property (nonatomic, weak) UIView *signView;
//@property (nonatomic, weak) SealSignAPI *sealSignAPI;



@end

@implementation SignLandscapeViewController{
    NSArray *_signDataArray;
    SignDataModel *_signDataModel;
    NSString *_userId;
    NSString *_url;
}


/* TODO
-(instancetype)initWithSignView:(UIView *)signView signApi:(SealSignAPI *)signApi{
    self = [super init];
    if(self != nil){
        _signView = signView;
        _sealSignAPI = signApi;
    }
    return self;
}
*/
-(void)setSignDataArray:(NSArray *)signDataArray{
    _signDataArray = signDataArray;
}

-(void)setSignDataModel:(SignDataModel *)signDataModel{
    _signDataModel = signDataModel;
}

-(void)setUserId:(NSString *)userId{
    _userId = userId;
}

-(void)setUrl:(NSString *)url{
    _url = url;
}

- (void)viewDidLoad{
    [super viewDidLoad];
//    _sealSignAPI.sealSignAPIDelegate = self;
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_signView];
    [self addCustomerButton];
    CGRect frame = _signView.subviews.lastObject.frame;
    frame.size = CGSizeMake(UIScreen.mainScreen.bounds.size.width, frame.size.height);
    _signView.subviews.lastObject.frame = frame;
//    _signView.subviews.lastObject.backgroundColor = [UIColor blueColor];
}


/**
 * 添加自定义按钮。
 */
-(void)addCustomerButton{
//    CGRect screentRect = UIScreen.mainScreen.bounds;
//    CGFloat screenWid = screentRect.size.width;
//    CGFloat screenHei = screentRect.size.height;
//
//    CGSize btnSize = CGSizeMake(screenWid*0.2f, 34.0f);//按钮的大小
//    CGFloat y = screenHei - btnSize.height - screenHei*0.05f;//距离下方的高度
//
//    float x = screenWid * 0.1f;
//    UIButton *btnCancel = [self createNagativeButton:CGRectMake(x, y, btnSize.width, btnSize.height)];
//    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
//    [btnCancel addTarget:_sealSignAPI action:@selector(cancleScreen) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnCancel];
//
//    x += (screenWid * 0.1f + btnSize.width);
//    UIButton *btnClear = [self createPositiveButton:CGRectMake(x, y, btnSize.width, btnSize.height)];
//    [btnClear setTitle:@"清屏" forState:UIControlStateNormal];
//    [btnClear addTarget:_sealSignAPI action:@selector(clearScreen) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnClear];
//
//    x += (screenWid * 0.1f + btnSize.width);
//    UIButton *btnSave = [self createPositiveButton:CGRectMake(x, y, btnSize.width, btnSize.height)];
//    [btnSave setTitle:@"确定" forState:UIControlStateNormal];
//    [btnSave addTarget:_sealSignAPI action:@selector(saveScreen) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnSave];
}


//白色+边框按钮
-(UIButton *)createNagativeButton:(CGRect)rect{
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    [button setBackgroundImage:[UIImage imageFromContextWithColor:COLOR_ffffff] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageFromContextWithColor:COLOR_0f191919] forState:UIControlStateHighlighted];
    [button setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    [button setTitleColor:COLOR_333333 forState:UIControlStateHighlighted];
    button.layer.borderColor = COLOR_e0e0e0.CGColor;
    button.layer.cornerRadius = 6.0f;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0f;
    button.titleLabel.font = SystemFontRegular(iPhone4_5_6X_P(13, 13, 15, 17));
    return button;
}

//蓝色按钮
-(UIButton *)createPositiveButton:(CGRect)rect{
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    [button setBackgroundImage:[UIImage imageFromContextWithColor:COLOR_1499f7] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageFromContextWithColor:COLOR_0488e5] forState:UIControlStateHighlighted];
    [button setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
    [button setTitleColor:COLOR_ffffff forState:UIControlStateHighlighted];
    button.layer.cornerRadius = 6.0f;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = SystemFontRegular(iPhone4_5_6X_P(13, 13, 15, 17));
    return button;
}


-(void)viewWillDisappear:(BOOL)animated {
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = 0;
    [super viewWillAppear:animated];
    [self orientationToPortrait:UIInterfaceOrientationPortrait];
}

- (void)orientationToPortrait:(UIInterfaceOrientation)orientation {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    UIInterfaceOrientation val = orientation;
    [invocation setArgument:&val atIndex:2];//前两个参数已被target和selector占用
    [invocation invoke];
}


- (void)didFinishedCommentSign:(UIImage *)commentImage {
    NSLog(@"%s",__func__);
}

//签名页面:点击“确定”
- (void)didFinishedSign:(UIImage *)signImage {
    NSLog(@"%s",__func__);
}

//签名页面:点击“取消”、“清屏”、"确定"
- (void)setOnSignatureResultListener:(NSDictionary *)result{
    NSString *value = result[@"returnKey"];
    if([@"onCancelSign" isEqualToString:value]){
        if(_signReturnBlock != nil){
            _signReturnBlock(-1, nil);
        }
        [self.navigationController popViewControllerAnimated: YES];
        
    }else if([@"onClearSign" isEqualToString:value]){
    }else if([@"onSaveSign" isEqualToString:value]){
        NSString *resultCode = result[@"resultCode"];
        if([resultCode isEqualToString:@"0"]){//成功
            UIImage *signature = [result objectForKey:@"signature"];//签名图片
            [self packageSignData:signature];
        }else{
            [self showAlertView:@"签名失败" message:nil];
        }
    }
    
}


- (void)packageSignData:(UIImage *)image{
    /*
    int enable = [_sealSignAPI isReadyToUpload];
    if(enable != 1){
        NSLog(@"%s %d",__func__,enable);
        return;
    }
    
    if(_userId == nil){
        [self showAlertView:@"签名失败" message:nil];
        return;
    }
    
    //转图片为base64
    NSString *uploadBase64Str = nil;
    if(image != nil){
        NSData *base64Code = [UIImagePNGRepresentation(image) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString *string = [[NSString alloc] initWithData:base64Code encoding:NSUTF8StringEncoding];
        uploadBase64Str = string;
//        uploadBase64Str = [string stringByReplacingOccurrencesOfString:@"\r|\n"withString:@""];//最后需要上传的数据
    }
    
    //处理需要上传的数据
    NSArray *requestDataArray = [_sealSignAPI genSignRequest:_signDataArray];
    //将数据封装到Dictionary中
    NSMutableDictionary *dataDic = [NSMutableDictionary new];
    //"signData"
    if(_signDataModel.isSingle){
        [dataDic setValue:requestDataArray[0] forKey:@"signdata"];
    }else{
        NSArray *signIdArr = [_signDataModel.signId componentsSeparatedByString:@","];
        NSString *signData = @"";
        for(NSString *signId in signIdArr){
            for(int i = 0; i < _signDataModel.signDataArray.count; i++){
                NSString *tempData = _signDataModel.signDataArray[i];
                NSString *containsStr = [signId stringByAppendingString:@"-textInfo:"];
                if([tempData containsString:containsStr]){
                    if([signData isEqualToString:@""]){
                        signData = [signId stringByAppendingFormat:@":%@",requestDataArray[i]];
                    }else{
                        signData = [signData stringByAppendingFormat:@"-split-%@:%@",signId,requestDataArray[i]];
                    }
                }
            }
        }
        [dataDic setValue:signData forKey:@"signdata"];
    }
    
    [dataDic setValue:_signDataModel.jcId forKey:@"jcid"];
    [dataDic setValue:uploadBase64Str forKey:@"base64"];
    [dataDic setValue:_signDataModel.posId forKey:@"posid"];
    [dataDic setValue:_signDataModel.signId forKey:@"signid"];
    [dataDic setValue:_signDataModel.signType forKey:@"signtype"];
    [dataDic setValue:_userId forKey:@"userid"];
    
    //处理在线
    if(_signDataModel.offlinejcdata == nil){//在线模式
        NSString *url = [NSString stringWithFormat:@"%@AirlineTaskAction/signJcData.do",_url];
        __weak typeof(self) weakSelf = self;
        [NetRequestClass NetRequestPostWithMethod:url parameters:dataDic returnBlock:^(id returnValue) {
            [weakSelf signDataSucc:returnValue base64Code:uploadBase64Str];
        } errorBlock:^(NetErrorCode errorCode) {
            [weakSelf signDataError:errorCode];
        }];
    }else{//离线模式，暂时未处理
        if(_signDataModel.isSingle){
        }else {}
    }
     */
}



-(void)showAlertView:(NSString *)title message:(NSString *)message{
    
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
     UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
         weakSelf.signReturnBlock(-1,nil);
         [weakSelf.navigationController popViewControllerAnimated:YES];
     }];
     [alertController addAction:okAction];
     [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)signDataSucc:(id)response base64Code:(NSString *)base64Code{
    if(response != nil && [response isKindOfClass:[NetManager class]]){
        NetManager *netManager = response;
        NSDictionary *dataDic = netManager.rawData;
        NSString *result = dataDic[@"result"];
        if([@"success" isEqualToString:result]){//成功
            self.signReturnBlock(1,base64Code);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showAlertView:@"签名失败" message:nil];
        }
    }
}

-(void)signDataError:(NetErrorCode )errorCode{
    self.signReturnBlock(-1,nil);
}

@end
