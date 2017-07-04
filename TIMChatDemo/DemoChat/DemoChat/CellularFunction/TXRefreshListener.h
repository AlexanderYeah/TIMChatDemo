//
//  TXRefreshListener.h
//  DemoChat
//
//  Created by AlexanderYeah on 2017/7/3.
//  Copyright © 2017年 AlexanderYeah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>
#import <TLSSDK/TLSHelper.h>
/**
 登录拉去新消息
 */
@interface TIMRefreshListener : NSObject<TIMRefreshListener>
-(void)onRefresh;
-(void)onRefreshConversations:(NSArray *)conversations;

@end



@interface TXRefreshListener : NSObject

@end
