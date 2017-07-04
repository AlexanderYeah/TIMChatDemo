//
//  TXStatusListener.h
//  DemoChat
//
//  Created by AlexanderYeah on 2017/7/3.
//  Copyright © 2017年 AlexanderYeah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>
#import <TLSSDK/TLSHelper.h>
/**
 2 用户状态监听
 */
@interface TIMUserStatusListerner : NSObject<TIMUserStatusListener>
// 踢下线通知
-(void)onForceOffline;
// 用户登录的userSig过期（用户需要重新获取userSig后登录）
-(void)onUserSigExpired;

@end
@interface TXStatusListener : NSObject

@end
