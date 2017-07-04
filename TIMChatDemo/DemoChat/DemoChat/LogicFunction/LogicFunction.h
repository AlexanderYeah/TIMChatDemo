//
//  LogicFunction.h
//  DemoChat
//
//  Created by AlexanderYeah on 2017/7/3.
//  Copyright © 2017年 AlexanderYeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogicFunction : NSObject

/**
 1 获取字符串的MD5形式
 */
+(NSString*)GetMD5OfString:(NSString*)str;

/**
 2 从后台服务器获取 腾讯云通信的 userSig
 */
+ (NSString*)GetUserSigFromSerByUserID:(NSString*)usrName andPassword:(NSString*)psd;
@end
