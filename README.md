# TIMChatDemo
### 本DEMO 是没有SDK集成的，由于framework太大，push的时候给删除了。So，这是项目run不起来了的😂😂😂😂😂
#### 仅仅是为了记录一下上个项目中聊天的框架，大致的逻辑，能在下一个项目中快速回忆起相关逻辑

##### 大致记一下，毕竟腾讯官方文档那么清楚  
###### 那就给出文档链接😍😍😍😍😍https://cloud.tencent.com/document/product/269/1566
一 SDK 的初始化   
```object-c
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


```
    
二 登录   
1 登录要获取用户的签名，获取用户的签名usersig，是要向后台post你的用户名密码参数的，饭后返回给你用户签名，然后拿着userSig 去进行登录  
2 然后就是要填写相关的参数了，accountType， identifier，appidAt3rd，sdkAppId ，userSig ，五个参数，忘记了，去看文档


```
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
    login_Param.identifier = userID;
    login_Param.appidAt3rd = [NSString stringWithFormat:@"%d",tim_sdkAppID];
    login_Param.sdkAppId = tim_sdkAppID;
    // 这个要填写的
// e10adc3949ba59abbe56e057f20f883e --123456的MD5
    login_Param.userSig = userSig;


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
    } fail:^(int code, NSString *msg) {
        // 登录失败
        
        NSString *errorInfo = [[NSString alloc]initWithFormat:@"sdk login failed   code = %d   desc = %@",code,msg];
        NSLog(@"%@",errorInfo);
        
        if(code == 6208)
        {
            //sdk login failed   code = 6208   desc = Kicked off by other device, please login again
            //说明用户之前在别的账号登录过。需要进行重新进行登录。
            //先删除数据库用户签名
            NSLog(@"用户之前在别的账号登录过,立即重登");
            
        }
        else if(code == 70004)
        {
            NSLog(@"UserSig无效");           
        }                
    }];

}
```

三 消息的发送  

  1 消息的发送，调用方法就行了，在CellularFunction 函数中，已经抽取了，大致的逻辑就是这样




四 消息接收监听  

 1 在TXListener 文件夹中，监听这各种信息    
 
 * TXMsgListener 新收取消息的监听  
 * TXConnListener 网络连接状态的监听   
 * TXStatusListener 用户状态的监听  
 * TXRefreshListener 登录之后拉去最新消息的监听  
 
 五 另外的就去看文档吧，什么离线推送什么的。

