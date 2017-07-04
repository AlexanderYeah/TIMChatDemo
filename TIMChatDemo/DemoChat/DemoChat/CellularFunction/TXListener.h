//
//  TXListener.h
//  DemoChat
//
//  Created by AlexanderYeah on 2017/6/30.
//  Copyright © 2017年 AlexanderYeah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>
#import <TLSSDK/TLSHelper.h>








/**
 4 登录
 */

@interface TLSPwdLoginListener : NSObject<TLSPwdLoginListener>
-(void)OnPwdLoginFail:(TLSErrInfo *)errInfo;
-(void)OnPwdLoginSuccess:(TLSUserInfo *)userInfo;
-(void)OnPwdLoginTimeout:(TLSErrInfo *)errInfo;
-(void)OnPwdLoginReaskImgcodeSuccess:(NSData *)picData;
-(void)OnPwdLoginNeedImgcode:(NSData *)picData andErrInfo:(TLSErrInfo *)errInfo;
@end

/**
 5 注册
 */
@interface TLSStrAccountRegListener : NSObject<TLSStrAccountRegListener>
-(void)OnStrAccountRegSuccess:(TLSUserInfo *)userInfo;
-(void)OnStrAccountRegFail:(TLSErrInfo *)errInfo;
-(void)OnStrAccountRegTimeout:(TLSErrInfo *)errInfo;
@end




