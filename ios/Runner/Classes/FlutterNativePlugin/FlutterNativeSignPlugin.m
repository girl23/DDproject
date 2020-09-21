//
//  FlutterNativeSignPlugin.m
//  Runner
//
//  Created by 赵王杰 on 2020/5/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "FlutterNativeSignPlugin.h"
#import "SignDataModel.h"
#import "NetRequestClass.h"
#import "AppDelegate.h"
#import "SignLandscapeViewController.h"

@interface FlutterNativeSignPlugin () <UIAlertViewDelegate>

@end

@implementation FlutterNativeSignPlugin

static NSString *METHOD_CHANNEL = @"com.ameco.lop.sign/method";
static NSString *MESSAGE_CHANNEL = @"com.ameco.lop.sign/message";

static NSString *METHOD_NAME_INIT_URL = @"initUrl";
static NSString *METHOD_NAME_INIT_API = @"initApi";
static NSString *METHOD_NAME_SHOW = @"show";
static NSString *METHOD_NAME_DELETE_SIGN = @"deleteSign";
static NSString *METHOD_NAME_TOAST_SHOW = @"toastShow";

UIViewController *_mainController;
static FlutterNativeSignPlugin *_instance;
FlutterBasicMessageChannel *_messageChannel;
NSString *_url;
NSString *_userId;
NSMutableArray *_signDataArray;

SignDataModel *_signDataModel;
//SealSignAPI *_sealSignApi;
//SealSignCaptureObj *_signCapObj;


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
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return _instance;
}
- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return _instance;
}


-(void)registMethod:(FlutterViewController * _Nonnull)controller{
    _mainController = controller;
    //注册方法调用通道(Flutter ——> Native)
    FlutterMethodChannel *signChannel = [FlutterMethodChannel methodChannelWithName:METHOD_CHANNEL binaryMessenger:controller.binaryMessenger];
    __weak typeof(self) weakSelf = self;
    [signChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        [weakSelf signFlutterMethodCall:call flutterResult:result];
    }];

    //注册消息通道(Flutter <——> Native)
    _messageChannel = [FlutterBasicMessageChannel messageChannelWithName:MESSAGE_CHANNEL binaryMessenger:controller.binaryMessenger codec:FlutterJSONMessageCodec.sharedInstance];
    [_messageChannel setMessageHandler:^(id  _Nullable message, FlutterReply  _Nonnull callback) {
        [weakSelf _flutterNativeMessageHandler:message flutterReply:callback];
    }];
}

#pragma mark  methodChannel: Flutter——>Native

-(void)signFlutterMethodCall:(FlutterMethodCall * _Nonnull) call flutterResult:(FlutterResult _Nonnull) result{
    NSString *methodName = call.method;
    NSLog(@"%s ,methodName = %@",__func__,methodName);
    if([METHOD_NAME_INIT_URL isEqualToString:methodName]){
        [self _initUrl:call.arguments];
    }else if([METHOD_NAME_INIT_API isEqualToString:methodName]){
        [self _initApi:call.arguments];
    }else if([METHOD_NAME_SHOW isEqualToString:methodName]){
        [self _showSign:call.arguments];
    }else if([METHOD_NAME_DELETE_SIGN isEqualToString:methodName]){
        [self _deleteSignWithEventName:@"iOSDeleteSign" eventData:call.arguments];
    }else if([METHOD_NAME_TOAST_SHOW isEqualToString:methodName]){
        [self _toastShow:call.arguments];
    }else{
        result(FlutterMethodNotImplemented);
    }
    result(@"success");
}

/**
 * 初始化网络请求地址
 */
-(void)_initUrl:(NSString *)url{
    _url = url;
}

/**
 * 初始化签名API
 */
-(void)_initApi:(NSString *)userInfo{
    if(userInfo == nil || [@"" isEqualToString:userInfo]){
        return;
    }
    NSArray *infoArray = [userInfo componentsSeparatedByString:@":"];
    _userId = infoArray[0];
    NSString *userName = infoArray[1];
    NSLog(@"userId = %@",_userId);
    NSLog(@"userName = %@",userName);
    [self _initApiStep_1];
    [self _initApiStep_2WithUserName:userName idNumber:_userId];
    
    
}

/**
 * 调用电签功能
 */
-(void)_showSign:(NSString *)signData{
    if(signData == nil || [@"" isEqualToString:signData]){
        NSLog(@"工卡数据失败");
        return;
    }

    NSArray *dataArray = [signData componentsSeparatedByString:@":"];
    NSString *operation = dataArray[0];
    _signDataModel = [[SignDataModel alloc]init];
    if([@"jcid" isEqualToString:operation]){//完工签署
        _signDataModel.signType = @"jc";
        _signDataModel.jcId = dataArray[1];
        _signDataModel.single = YES;
    }else if([@"date" isEqualToString:operation]){//日期签署
        _signDataModel.signType = @"date";
        _signDataModel.jcId = dataArray[1];
    }else if([@"posid" isEqualToString:operation]){//工序签署
        _signDataModel.signType = @"pos";
        _signDataModel.jcId = dataArray[1];
        _signDataModel.posId = dataArray[2];
        _signDataModel.signId = dataArray[3];
        if(dataArray.count == 5){
            // hint 提示用户当前为离线签署
            // Toast.makeText(activity,"离线签署！",Toast.LENGTH_LONG).show();
            // 将jcdata存入成员变量 方便签名时使用
            _signDataModel.offlinejcdata = dataArray[4];
            // 给RN发log信息，用于调试
            [self sendMsgToFlutterWithEventName:@"iOSToRNMessageLog" eventData:_signDataModel.offlinejcdata];
        }
        if ([_signDataModel.signId containsString:@","]){
            _signDataModel.single = NO;// 批量签署
        }else{
            _signDataModel.single = YES;// 单个签署
        }
    }
    if([@"date" isEqualToString:_signDataModel.signType]){//日期签署，直接显示签名框
        /* TODO
        [_sealSignApi setOrigialContent];
        [_sealSignApi showSignatureDialog:0];
         */
    }else{//其他签署，需要先请求获取加密串
        [self _getEncodeSignData];
    }
}

/**
 * 删除已有签名
 */
-(void)_deleteSignWithEventName:(NSString *)eventName eventData:(NSString *)eventData{
    [self sendMsgToFlutterWithEventName:eventName eventData:eventData];
}

/**
 * 显示签名失败的toast信息
 */
-(void)_toastShow:(NSString *)message{

}

#pragma mark messageChannel:Flutter ——> Native
/**
 * 接收Flutter —> Native 消息
 */
-(void)_flutterNativeMessageHandler:(id _Nullable) message flutterReply:(FlutterReply) callback{
    NSLog(@"asdfasdfasdfs");
}

#pragma mark private method
-(void)sendMsgToFlutterWithEventName:(NSString *)eventName eventData:(NSString *)eventData{
    NSDictionary *dic = @{@"eventName":eventName,@"eventData":eventData};
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&parseError];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"message: %@",str);
    
    [_messageChannel sendMessage:str];
}
#pragma mark initApi步骤
/**
 * 初始化api，添加渠道号，模板信息
 */
- (void)_initApiStep_1{
    /* TODO
    //1、初始化api
    if(_sealSignApi == nil){
        _sealSignApi = [[SealSignAPI alloc]init];
    }
//    _sealSignApi.sealSignAPIDelegate = self;
    _sealSignApi.isShouldAutorotate = YES;
    //2、设置渠道号
    [_sealSignApi setChannel:@"999999"];
    //3、设置模板信息
    [_sealSignApi setEncryType:EncType_RSA];//设置加密方法（需项目经理指导）
    [_sealSignApi setOrigialContent];//配置表单信息,orgdata为原文数据
    */
}

/**
 * 添加签名信息
 */

- (void)_initApiStep_2WithUserName:(NSString *)uName idNumber:(NSString *)idNumber{
    /*
     TODO
    _signCapObj = [[SealSignCaptureObj alloc]init];
    //此index对应签名接口的(int)index
    _signCapObj.index = 0;
    //签名人信息：1.姓名 2.证件类型 3.证件号码
    _signCapObj.signer.UName = uName;
    _signCapObj.signer.IDNumber = idNumber;
    _signCapObj.signer.IDType = TYPE_IDENTITY_CARD;
    //设置笔迹颜色
    _signCapObj.strokeColor = [UIColor blackColor];
    //设置笔迹粗细
    _signCapObj.strokeWidth = 8.0;
    //设置图片大小（按照实际签名图片计算）
    _signCapObj.SignImageSize = CGSizeMake(100, 100);
    _signCapObj.scale = 1.0;
    //设置签名数据类型，1.签名数据。2.批注数据
    _signCapObj.signType = SignType_SIGN;
    _signCapObj.lineMax = 4;
    _signCapObj.titleTxt = @"签名";
    _signCapObj.titleColor = [UIColor blackColor];

    //设置是否自定义签名框
    _signCapObj.isViewMyself = NO;
    //设置是否开启时间戳，对应服务器端配置
    _signCapObj.isTss = @"true";

    //设置提醒文字
    [_signCapObj setRemindTitle:[NSString stringWithFormat: @"请签名人%@签字",uName]];
    //设置从第几个字开始凸显出来
    [_signCapObj setTitleSpanFromOffset:5];
    //设置到第几个字凸显结束
    [_signCapObj setTitleSpanToOffset:5+(int)uName.length];
    //调用配置签名信息接口
    int isPass=[_sealSignApi addSignCaptureObj:_signCapObj];
    if (isPass==1) {
        NSLog(@"配置签名框信息成功");
    }else {
        NSLog(@"错误码：%d",isPass);
    }
     */
}


- (void)_getEncodeSignData{
    NSString *url = [NSString stringWithFormat:@"%@AirlineTaskAction/getJcData.do",_url];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:_signDataModel.signType forKey:@"signtype"];
    [parameters setValue:_signDataModel.jcId forKey:@"jcid"];
    [parameters setValue:_signDataModel.posId forKey:@"posid"];
    [parameters setValue:_signDataModel.signId forKey:@"signid"];
    [parameters setValue:_userId forKey:@"userid"];
    __weak typeof(self) weakSelf = self;
    [NetRequestClass netRequestGetWithUrl:url parameters:parameters returnBlock:^(id returnValue) {
        [weakSelf _doGetEncodeSignSucc:returnValue];
    } errorBlock:^(NetErrorCode errorCode) {
        [weakSelf _doGetEncodeSignFail:errorCode];
    }];
}

-(void)_doGetEncodeSignSucc:(id)response{
    if(response != nil && [response isKindOfClass:[NetManager class]]){
        NetManager *netManager = response;
        NSDictionary *dataDic = netManager.rawData;
        NSString *status = dataDic[@"result"];
        if([@"success" isEqualToString:status]){
            if(_signDataArray != nil){
                [_signDataArray removeAllObjects];
            }else{
                _signDataArray = [NSMutableArray new];
            }

            NSString *jcdata = dataDic[@"jcdata"];
            if(_signDataModel.isSingle){//单签
                NSData *data = [jcdata dataUsingEncoding:NSUTF8StringEncoding];
                [_signDataArray addObject:data];
            }else{
                NSArray *signDataArr = [jcdata componentsSeparatedByString:@"-split-"];
                for(NSString *signData in signDataArr){
                     [_signDataArray addObject:[signData dataUsingEncoding:NSUTF8StringEncoding]];
                }
            }
            [self _startMutiSign];
        }else{
             [self showAlertView:@"失败" message:@"获取签名加密串失败！"];
        }

    }

    [self sendMsgToFlutterWithEventName: @"IosToRNMessageLog" eventData:@"加密成功运行"];
    
    
    
}
-(void)_doGetEncodeSignFail:(NetErrorCode )errorCode{
    [self sendMsgToFlutterWithEventName: @"ErrorToRNMessage" eventData:@""];
}

/**
 * 调用签名
 */
- (void)_startMutiSign {
    /* TODO
    if(_sealSignApi != nil){
       UIViewController *signController = [_sealSignApi showSignatureDialog:0];
       //自定义按钮事例
        if (signController) {
            AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.allowRotation = 1;
            [self orientationToPortrait:UIInterfaceOrientationLandscapeLeft];
            
            SignLandscapeViewController *con = [[SignLandscapeViewController alloc]initWithSignView:signController.view signApi:_sealSignApi];
            [con setSignDataArray:_signDataArray];
            [con setSignDataModel:_signDataModel];
            [con setUserId:_userId];
            [con setUrl:_url];
            con.signReturnBlock = ^(int type, NSString *signImage) {
                if(type == -1){//取消
                    [self sendMsgToFlutterWithEventName:@"ErrorToRNMessage" eventData:@""];
                }else if(type == 1){//签名成功
                    [self sendMsgToFlutterWithEventName:@"iOSToRNMessageLog" eventData:@"签名完成，当前为在线模式"];
                    [self sendMsgToFlutterWithEventName:@"iOSToRNMessage" eventData:signImage];
                }
            };
            [_mainController.navigationController pushViewController:con animated:YES];
        }else {
            [self showAlertView:@"显示失败" message:nil];
        }
    }
     */
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


-(void)showAlertView:(NSString *)title message:(NSString *)message{
    
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//    __weak typeof(self) weakSelf = self;
     UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
     }];
     [alertController addAction:okAction];
     [self presentViewController:alertController animated:YES completion:nil];

}


@end
