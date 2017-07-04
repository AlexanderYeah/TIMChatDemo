//
//  CellularFunction.m
//  DemoChat
//
//  Created by AlexanderYeah on 2017/6/30.
//  Copyright © 2017年 AlexanderYeah. All rights reserved.
//

#import "CellularFunction.h"


#import "GlobalVariable.h"

#import "TXMsgListener.h"
#import "TXConnListener.h"
#import "TXStatusListener.h"
#import "TXRefreshListener.h"
#import "LogicFunction.h"

@implementation CellularFunction
/**
 1 腾讯云通信 初始化
 */
#pragma mark - 初始化操作
- (void)InitTIMSDK{
    //腾讯初始化
    TIMMessageListener *msg_lisener = [[TIMMessageListener alloc]init];//接受消息
    TIMUserStatusListerner *status_lisener = [[TIMUserStatusListerner alloc]init];//被踢，用户票据过期 通知
    TIMConnListener *connection_lisener = [[TIMConnListener alloc]init];//连接情况
    TIMRefreshListener *refresh_lisener = [[TIMRefreshListener alloc]init];//登录后异步获取离线消息同步资料数据 完成时会触发onRefresh
    
    [[TIMManager sharedInstance] setMessageListener:msg_lisener];
    [[TIMManager sharedInstance] setUserStatusListener:status_lisener];
    [[TIMManager sharedInstance] setConnListener:connection_lisener];
    [[TIMManager sharedInstance] setRefreshListener:refresh_lisener];

    // sdk的初始化  传入应用的APPID
    [[TIMManager sharedInstance]initSdk:tim_sdkAppID];
    
    
    
    
    
}


/**
 2 腾讯云通信 登录
 */
#pragma mark - 2 登录操作
- (void)LoginTIMWithUserID:(NSString *)userID andUserSig:(NSString *)userSig{
    // 此处省去登录前的相关账号和密码判断和处理操作，直接进行功能实现
    
    // 1 先查看自己是否已经是登录状态。如果已经登录，无需再次登录
    NSString *loginUser = [[TIMManager sharedInstance]getLoginUser];
    if(loginUser!=nil && [loginUser isEqualToString:userID])
    {
        NSLog(@"账号已经登录，无需重复登录。刷新朋友群组信息");
    }
    
    // 2 先读本地数据库，查看是否存在有效的用户签名。若存在，则使用本地。若不存在则申请
    // my_userSig 是要想 服务器所求签名
    
    // 进行sdk 登录
    TIMLoginParam *login_Param = [[TIMLoginParam alloc]init];
    login_Param.accountType = tim_accountType;
    // 这个要填写的
    login_Param.identifier = userID;
    login_Param.appidAt3rd = [NSString stringWithFormat:@"%d",tim_sdkAppID];
    login_Param.sdkAppId = tim_sdkAppID;
    // 这个要填写的
// e10adc3949ba59abbe56e057f20f883e --123456的MD5
    login_Param.userSig = userSig;
    // 向服务器post参数获取usersig 未成功，直接在线模拟请求获取的usersig
//    NSLog(@"Alexander- %@",[LogicFunction GetUserSigFromSerByUserID:@"15301653323" andPassword:@"123456"]);
    TIMManager *timManager = [TIMManager sharedInstance];
    [timManager login:login_Param succ:^{
        // 登录成功
        NSLog(@"Alexander- 登录成功");
        // 获取自身的信息
        int ret = [[TIMFriendshipManager sharedInstance]GetSelfProfile:^(TIMUserProfile* profile){
            
        } fail:^(int code,NSString* err){
            
            NSString *errorInfo = [[NSString alloc]initWithFormat:@"获取己方昵称失败   code = %d   desc = %@",code,err];
            NSLog(@"%@",errorInfo);
           
        }];
        
        // ret 是返回值
        
        
    } fail:^(int code, NSString *msg) {
        // 登录失败
        
        NSString *errorInfo = [[NSString alloc]initWithFormat:@"sdk login failed   code = %d   desc = %@",code,msg];
        NSLog(@"%@",errorInfo);
        
        if(code == 6208)
        {
            //sdk login failed   code = 6208   desc = Kicked off by other device, please login again
            //说明用户之前在别的账号登录过。需要进行重新进行登录。
            //先删除数据库用户签名
            //ret_login_info = @"-3";
            NSLog(@"用户之前在别的账号登录过,立即重登");
            
        }
        else if(code == 70004)
        {
            NSLog(@"UserSig无效");
            
        }
                
    }];

}

/**
 3 腾讯云通信 登出
 */
#pragma mark - 3 登出操作
- (void)LogoutTIM{
    
    // 此处省去登出前的一些步骤，删除表，签名
    //1 传入自己的uid 清除用户登录数据
    [[TLSHelper getInstance] clearUserInfo:@"my_uid" withOption:YES];
    //2 登出操作
    [[TIMManager sharedInstance]logout:^{
        NSLog(@"logout succ");
    } fail:^(int code, NSString *msg) {
        NSLog(@"logout fail: code=%d err=%@", code, msg);
    }];
    
}
/**
 4 腾讯云通信 发文本
 */
#pragma mark - 4 发送文本信息
- (void)SendTextByTIMWithRemoteID:(NSString *)remoteID withContent:(NSString *)content withIsGroupMsg:(BOOL)isGroupMsg{
    
    // 将会话存入数据库等操作省略
    
    // 消息类型 C2C  群消息类型为  TIM_GROUP
    NSString *target = remoteID;
    NSString *context = content;    

    int msg_type = TIM_C2C;
    if(isGroupMsg == YES){
        msg_type = TIM_GROUP;
    }
    // 1  创建会话
    TIMConversation *c2c_conversation = [[TIMManager sharedInstance] getConversation:msg_type receiver:target];
    // 创建文本元素 消息对象
    TIMTextElem *text_elem = [[TIMTextElem alloc]init];
     [text_elem setText:context];
    TIMMessage *msg = [[TIMMessage alloc]init];
    [msg addElem:text_elem];
    
    // 发送消息
    [c2c_conversation sendMessage:msg succ:^{
        // 发送成功的操作 插入数据库 等等
        NSLog(@"alexander--发送文本成功");
    } fail:^(int code, NSString *msg) {
        // 发送失败
        NSString* errorInfo = [[NSString alloc]initWithFormat:@"信息发送失败   code = %d   desc = %@",code,msg];
        NSLog(@"%@",errorInfo);
    }];
}


/**
 5 腾讯云通信 发图片
 */
#pragma mark - 5 发送图片
- (void)SendPicByTIMWithRemoteID:(NSString *)remoteID withFilePath:(NSString *)filePath withIsGroupMsg:(BOOL)isGroupMsg{
    
    //将数据存入数据库等操作省略
    
    NSString *target = remoteID;
    // 是否为群消息

    int msg_type = TIM_C2C;
    if(isGroupMsg == YES){
        msg_type = TIM_GROUP;
        
    }
    
    
    // 1 创建会话
    
    TIMConversation *c2c_conversation = [[TIMManager sharedInstance] getConversation:msg_type receiver:target];

    //  创建图像元素对象
    TIMImageElem *image_elem = [[TIMImageElem alloc]init];
    image_elem.path = filePath;
    // 将图像元素装入对象
    TIMMessage *msg = [[TIMMessage alloc]init];
    [msg addElem:image_elem];
    
    // 2 发送操作
    [c2c_conversation sendMessage:msg succ:^{
        // 发送成功的操作 插入数据库 等等
        NSLog(@"alexander--发送图片成功");
    } fail:^(int code, NSString *msg) {
        // 发送失败
        NSString* errorInfo = [[NSString alloc]initWithFormat:@"alexander发送图片失败   code = %d   desc = %@",code,msg];
        NSLog(@"%@",errorInfo);
    }];
    
}

/**
 6 腾讯云通信 发语音
 */
#pragma mark - 6 发送语音
- (void)SendSoundByTIMWithRemoteID:(NSString *)remoteID withFilePath:(NSString *)filePath withVoiceLen:(int)voiceLen withIsGroupMsg:(BOOL)isGroupMsg{
    //将数据存入数据库等操作省略
    
    NSString *target = remoteID;
    // 是否为群消息
    int msg_type = TIM_C2C;
    if(isGroupMsg == YES){
        msg_type = TIM_GROUP;
        
    }
    // 时间
    int time = voiceLen;
    // 录音的数据
    NSData *soundData = [[NSFileManager defaultManager]contentsAtPath:filePath];
    
    // 1 创建会话
    TIMConversation *c2c_conversation = [[TIMManager sharedInstance] getConversation:msg_type receiver:target];
    
    // 2 创建语音的元素
    TIMSoundElem *sound_elem = [[TIMSoundElem alloc]init];
    [sound_elem setData:soundData];
    [sound_elem setSecond:time];
    
    
    //  将语音元素装入消息对象
    TIMMessage *msg = [[TIMMessage alloc]init];
    [msg addElem:sound_elem];
    
    // 发送语音操作
    [c2c_conversation sendMessage:msg succ:^{
        // 发送成功的操作 插入数据库 等等
        
    } fail:^(int code, NSString *msg) {
        // 发送失败
        NSString* errorInfo = [[NSString alloc]initWithFormat:@"信息发送失败   code = %d   desc = %@",code,msg];
        NSLog(@"%@",errorInfo);
    }];

    
}

/**
 7 腾讯云通信 发文件 小视频形式
 */
#pragma mark - 7 发送小视频
- (void)SendSmallFileByTIMWithRemoteID:(NSString *)remoteID withFilePath:(NSString *)filePath withIsGroupMsg:(BOOL)isGroupMsg{
    
    NSString *target = remoteID;
    // 是否为群消息
    // 是否为群消息
    int msg_type = TIM_C2C;
    if(isGroupMsg == YES){
        msg_type = TIM_GROUP;
        
    }
    
    // 小视频文件要做一个压缩的操作，压缩过程省略
    //创建文件元素
    TIMFileElem *avfile_elem = [[TIMFileElem alloc]init];
    [avfile_elem setPath:filePath];
    [avfile_elem setFilename:@"文件名"];//原先的，不带_Compressed的文件名
    
    TIMMessage *msg = [[TIMMessage alloc]init];
    [msg addElem:avfile_elem];

    TIMConversation *c2c_conversation = [[TIMManager sharedInstance] getConversation:msg_type receiver:target];

    
    // 发送小视频操作
    [c2c_conversation sendMessage:msg succ:^{
        // 发送成功的操作 插入数据库 等等
        NSLog(@"alexander--发送小视频成功");
    } fail:^(int code, NSString *msg) {
        // 发送失败
        NSString* errorInfo = [[NSString alloc]initWithFormat:@"信息发送失败   code = %d   desc = %@",code,msg];
        NSLog(@"%@",errorInfo);
    }];

}
/**
 9  腾讯云通信 获取指定远程对象的会话
 */
- (TIMConversation *)GetTIMConversationWithRemoteID:(NSString *)remoteID withIsGroupMsg:(BOOL)isGroupMsg{
    int msg_type = TIM_C2C;
    if(isGroupMsg == YES){
        msg_type = TIM_GROUP;
        
    }
    TIMConversation * c2c_conversation = [[TIMManager sharedInstance] getConversation:msg_type receiver:remoteID];
    
    return c2c_conversation;
}
/**
 10 腾讯云通信 获取指定会话的最后一条消息
 */
- (TIMMessage *)GetLastMsgWithConversation:(TIMConversation *)conversation{
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    // 获取的消息数组
    
    [conversation getMessage:1 last:nil succ:^(NSArray *msgs) {
        // 成功
        for (TIMMessage * msg in msgs) {
            if ([msg isKindOfClass:[TIMMessage class]]) {
                [tempArr addObject:msg];
            }
        }
    } fail:^(int code, NSString *msg) {
        // 失败
    }];
    return tempArr[0];
}

/**
 11 腾讯云通信 获取历史记录
 */
- (void)GetMsgsOfHistoryWithConversation:(TIMConversation *)conversation withCount:(int)count withLastMsg:(TIMMessage *)lastMsg{
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    
    [conversation getMessage:count last:lastMsg succ:^(NSArray *msgs) {
        // 成功
        for (TIMMessage * msg in msgs) {
            if ([msg isKindOfClass:[TIMMessage class]]) {
                [tempArr addObject:msg];
            }
        }
        
    } fail:^(int code, NSString *msg) {
        // 失败
    }];
    
    // 历史记录返回
    
    historyArr = tempArr;
    
}




@end
