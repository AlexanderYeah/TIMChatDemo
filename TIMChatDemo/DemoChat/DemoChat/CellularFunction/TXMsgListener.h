//
//  TXMsgListener.h
//  DemoChat
//
//  Created by AlexanderYeah on 2017/7/3.
//  Copyright © 2017年 AlexanderYeah. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ImSDK/ImSDK.h>
#import <TLSSDK/TLSHelper.h>
/**
 1 消息监听
 */
@interface TIMMessageListener : NSObject<TIMMessageListener>
// 新消息列表，TIMMessage 类型数组
-(void)onNewMessage:(NSArray *)msgs;
@end
@interface TXMsgListener : NSObject

@end
