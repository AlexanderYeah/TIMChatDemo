//
//  TXConnListener.h
//  DemoChat
//
//  Created by AlexanderYeah on 2017/7/3.
//  Copyright © 2017年 AlexanderYeah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>
#import <TLSSDK/TLSHelper.h>
/**
 3 网络连接监听
 */
@interface TIMConnListener : NSObject<TIMConnListener>
// 网络连接中
-(void)onConnecting;
// 网络连接成功
-(void)onConnSucc;
// 网络连接失败
-(void)onConnFailed:(int)code err:(NSString *)err;
// 网络连接断开
-(void)onDisconnect:(int)code err:(NSString *)err;
@end
@interface TXConnListener : NSObject

@end
