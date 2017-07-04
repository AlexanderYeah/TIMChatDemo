//
//  CellularFunction.h
//  DemoChat
//
//  Created by AlexanderYeah on 2017/6/30.
//  Copyright © 2017年 AlexanderYeah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>
#import <TLSSDK/TLSHelper.h>
@interface CellularFunction : NSObject

/**
 1 腾讯云通信 初始化
 */
- (void)InitTIMSDK;
/**
 2 腾讯云通信 登录
 */
- (void)LoginTIMWithUserID:(NSString *)userID andUserSig:(NSString *)userSig;
/**
 3 腾讯云通信 登出
 */
- (void)LogoutTIM;
/**
 4 腾讯云通信 发文本
 */
- (void)SendTextByTIMWithRemoteID:(NSString *)remoteID withContent:(NSString *)content withIsGroupMsg:(BOOL)isGroupMsg;
/**
 5 腾讯云通信 发图片
 */
- (void)SendPicByTIMWithRemoteID:(NSString *)remoteID withFilePath:(NSString *)filePath withIsGroupMsg:(BOOL)isGroupMsg;
/**
 6 腾讯云通信 发语音
 */
- (void)SendSoundByTIMWithRemoteID:(NSString *)remoteID withFilePath:(NSString *)filePath withVoiceLen:(int)voiceLen withIsGroupMsg:(BOOL)isGroupMsg;
/**
 7 腾讯云通信 发文件 小视频形式
 */
- (void)SendSmallFileByTIMWithRemoteID:(NSString *)remoteID withFilePath:(NSString *)filePath withIsGroupMsg:(BOOL)isGroupMsg;
/**
 8 腾讯云通信 自定义消息
 */
- (void)SendDIYInfoByTIM;

/**
 9  腾讯云通信 获取指定远程对象的会话
 */
- (TIMConversation *)GetTIMConversationWithRemoteID:(NSString *)remoteID withIsGroupMsg:(BOOL)isGroupMsg;
/**
 10 腾讯云通信 获取指定会话的最后一条消息
 */
- (TIMMessage *)GetLastMsgWithConversation:(TIMConversation *)conversation;

/**
 11 腾讯云通信 获取历史记录
 */
- (void)GetMsgsOfHistoryWithConversation:(TIMConversation *)conversation withCount:(int)count withLastMsg:(TIMMessage *)lastMsg;









@end
