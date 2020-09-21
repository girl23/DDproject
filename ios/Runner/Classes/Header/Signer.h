//
//  Signer.h
//  SignAPI
//
//  Created by pingwanhui on 15/8/17.
//  Copyright (c) 2015年 pingwanhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Signer : NSObject
//1为身份证，2为军官证，3为护照，4为户口本，5港澳台回乡证，6出生证，7外国人永久居留身份证
typedef NS_ENUM(NSInteger, CardType)  {
    TYPE_IDENTITY_CARD = 1,
    TYPE_OFFICER_CARD,
    TYPE_PASSPORT_CARD,
    TYPE_RESIDENT_CARD,
    TYPE_RETURNHOME_CARD,
    TYPE_BIRTH_CARD,
    TYPE_PERMANENTRESIDENCE_CARD

};

@property (nonatomic, strong) NSString *UName;//姓名
@property (nonatomic, strong) NSString *IDNumber;//证据号
@property (nonatomic, assign) CardType IDType;//证件类型
@end
