//
//  GlobalVariable.m
//  DemoChat
//
//  Created by AlexanderYeah on 2017/6/30.
//  Copyright © 2017年 AlexanderYeah. All rights reserved.
//

#import "GlobalVariable.h"


@implementation GlobalVariable

#pragma mark - 此处为app 的相关配置信息，将相应参数填上就行了
NSString* tim_accountType = @"";
NSString* tim_appAdmin = @"";
NSString* tim_appAdminPSD = @"";
int tim_sdkAppID = 1515151;


#pragma mark - 此处为app 全局变量
NSString* my_md5OfID = @"";
NSString* my_userSig = @"";
NSString* my_userID = @"";
NSString* my_pwd = @"";
NSString* my_nickname = @"";

NSMutableArray *historyArr;


@end
