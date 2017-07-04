//
//  GlobalVariable.h
//  DemoChat
//
//  Created by AlexanderYeah on 2017/6/30.
//  Copyright © 2017年 AlexanderYeah. All rights reserved.
//

#import <Foundation/Foundation.h>
//---------------MARK:App配置信息---------------
//1腾讯云即时聊天 腾讯云的以Tim 开头


extern NSString* tim_accountType;
extern NSString* tim_appAdmin;
extern NSString* tim_appAdminPSD;
extern int tim_sdkAppID;


//---------------MARK:腾讯云相关全局变量---------------
extern NSString* my_md5OfID;
extern NSString* my_userSig;
extern NSString* my_userID;
extern NSString* my_pwd;
extern NSString* my_nickname;


// 获取历史消息会话
extern NSMutableArray *historyArr;
@interface GlobalVariable : NSObject


@end
