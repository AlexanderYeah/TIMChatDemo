//
//  TXMsgListener.m
//  DemoChat
//
//  Created by AlexanderYeah on 2017/7/3.
//  Copyright © 2017年 AlexanderYeah. All rights reserved.
//

#import "TXMsgListener.h"

/**
 1 消息监听实现
 */
@implementation TIMMessageListener
#pragma mark - 监听到消息
-(void)onNewMessage:(NSArray *)msgs {
      NSLog(@"alexander-收到消息");
    // 1 for 循环 取出每一条消息
    for (TIMMessage *msg in msgs) {
      
#pragma mark - 收到消息第一步 处理
        // 1 消息的具体信息  发送者 时间
        NSString * sender = [msg sender];
        NSDate * timeDate = [msg timestamp];
        NSTimeInterval timeInterval = [timeDate timeIntervalSince1970];
        
        //2屏蔽自己收到自己的信息
        if(sender!=nil && [sender isEqualToString:@"自己的uid"])
            continue;
        
        //3 获取收到消息的昵称
        TIMUserProfile *sender_Profile = [msg GetSenderProfile];
        NSString *nickName = [sender_Profile nickname];
        if(nickName == nil)
            nickName = @"";//不是好友发来的消息，昵称是收不到的
        
        TIMConversation *conv = [msg getConversation];// 会话
        TIMConversationType conv_type = [conv getType];//类型
        NSString* remoteID = [conv getReceiver];//获取会话人，单聊为对方账号，群聊为群组Id
        // 判断是否是群组
        int isGroupMsg = 0;
        if(conv_type == TIM_C2C)
            isGroupMsg = 0;
        else if(conv_type == TIM_GROUP)
            isGroupMsg = 1;
#pragma mark - 收到消息第二步 for 循环取出每一条消息
        for (int i = 0; i < [msg elemCount]; i ++) {
            // 1 逐个取出消息的每个元素
            TIMElem *elem = [msg getElem:i];
            // 2 进入if else 对元素进行类判断，区分是什么类型的元素
            // 2.1 群系统消息
            if([elem isKindOfClass:[TIMGroupSystemElem class]]){
                if([sender isEqualToString:@"@TIM#SYSTEM"]){
                    TIMGroupSystemElem* group_sys_ele = (TIMGroupSystemElem*)elem;
                    NSData* userData = [group_sys_ele userData];
                    NSString* groupID = [group_sys_ele group];

                    // 进行其数据库相关的操作
                    continue;
                }
                
            }
            // 2.2 关系链变更消息
            if([elem isKindOfClass:[TIMSNSSystemElem class]]){
                //判断是否是删除好友的系统消息
                TIMSNSSystemElem* sys_ele = (TIMSNSSystemElem*)elem;
                if(TIM_SNS_SYSTEM_DEL_FRIEND == [sys_ele type])
                {
                    NSLog(@"探测到 %@ 删除了我",sender);
                    //重新登录，刷新朋友列表
                    
                }else{
                    NSLog(@"探测到别的系统消息");
                }
                
                continue;
                
            }
            
            // 2.3 文本消息
            if([elem isKindOfClass:[TIMTextElem class]]){
                TIMTextElem *text_elem = (TIMTextElem*)elem;
                NSString *str_info = [text_elem text];
                NSLog(@"alexander-收到文本消息:%@",str_info);
                //  进行数据库等操作
                
            }
            else if ([elem isKindOfClass:[TIMImageElem class]]){
                // 2.4 图片消息
                // 将图片存储到沙盒路径
                NSString *tempDir = NSTemporaryDirectory();
                NSString* imageDir = [[NSString alloc]initWithFormat:@"%@/%@/%@",tempDir,@"自己的UID进行MD5",@"发送者UID进行MD5"];
                
                if([[NSFileManager defaultManager]fileExistsAtPath:imageDir]==NO){
                    BOOL res = [[NSFileManager defaultManager]createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
                    if(res==NO){
                        NSLog(@"图片存储到本地--创建目录失败");
                        continue;
                    }
                }
                // 缩略图  大图 原始图
                NSString *thumbPath = imageDir;
                NSString *largePath = imageDir;
                NSString *originPath = imageDir;
                
                TIMImageElem *image_elem = (TIMImageElem*)elem;
                //遍历所有图片规格（缩略图 大图 原图）
                NSArray *imgList = [image_elem imageList];
                for(TIMImage *image in imgList){
                    //1.文件名
                    NSString *fileName = [image uuid];
                    //图片类型判断   0 缩略  1 大图 2 就大图了
                    int type = -1;
                    if([image type] == TIM_IMAGE_TYPE_THUMB){
                        fileName = [fileName stringByAppendingString:@"_thumb"];
                        fileName = [fileName stringByAppendingPathExtension:@"jpg"];
                        thumbPath = [thumbPath stringByAppendingPathComponent:fileName];
                        type = 0;
                    }else if([image type] == TIM_IMAGE_TYPE_LARGE){
                        // continue;//只要下载缩略图 所以跳过
                        fileName = [fileName stringByAppendingString:@"_large"];
                        fileName = [fileName stringByAppendingPathExtension:@"jpg"];
                        largePath = [largePath stringByAppendingPathComponent:fileName];
                        type = 1;
                        
                    }else if([image type] == TIM_IMAGE_TYPE_ORIGIN){
                        // continue;//只要下载缩略图 所以跳过
                        fileName = [fileName stringByAppendingString:@"_origin"];
                        fileName = [fileName stringByAppendingPathExtension:@"jpg"];
                        originPath = [originPath stringByAppendingPathComponent:fileName];
                        type = 2;
                    }
                    
                    
                    // 完整图片存储路径
                    NSString *pic_path = @"";
                    if(type == 0){
                        pic_path = [thumbPath copy];
                    }else if(type == 1){
                        pic_path = [largePath copy];
                    }else if(type == 2){
                        pic_path = [originPath copy];
                    }
                    
                    // 获取图片
                    
                    [image getImage:pic_path succ:^{
                        NSLog(@"存储图片成功  success");
                        // 数据库相关的操作
                    } fail:^(int code, NSString *msg) {
                        NSLog(@"存储图片成功  failed");
                    }];
                    
                }
                
                
                
            }
            else if ([elem isKindOfClass:[TIMSoundElem class]]){
                // 2.5 语音消息
                NSLog(@"收到语音消息");
                TIMSoundElem *sound_elem = (TIMSoundElem*)elem;
                NSString *fileName = [sound_elem uuid];
                fileName = [fileName stringByAppendingPathExtension:@"amr"];
                //2.存储目录
                NSString *homeDir = NSHomeDirectory();
                NSString *storageDir = [[NSString alloc]initWithFormat:@"%@/Library/audio",homeDir];
                if([[NSFileManager defaultManager]fileExistsAtPath:storageDir]==NO)
                    [[NSFileManager defaultManager]createDirectoryAtPath:storageDir withIntermediateDirectories:YES attributes:nil error:nil];
                //3.存储路径
                NSString *sound_path = [storageDir stringByAppendingPathComponent:fileName];
                int voiceLen = sound_elem.second;
                NSString* newMsgWithTime = [NSString stringWithFormat:@"%@;%d",sound_path,voiceLen];
                // 4 获取到录音文件
                [sound_elem getSoundToFile:sound_path succ:^{
                    NSLog(@"存储录音消息 success");
                } fail:^(int code, NSString *msg) {
                    NSLog(@"存储录音消息 failed");
                }];
                
                // 数据库相关的操作
                
                
                
                
            }
            else if ([elem isKindOfClass:[TIMFileElem class]]){
                // 2.6 小文件消息
                TIMFileElem *file_elem = (TIMFileElem*)elem;
                NSString *fileName = [file_elem filename];
                NSString *smallAVfileType = @"mp4";
                if([[[fileName lastPathComponent] pathExtension] isEqualToString:smallAVfileType]){
                    // 小视频类型
                    NSLog(@"收到小视频");
                    int size = [file_elem fileSize];
                    //1.文件名
                    int name_temp = 1970; // 这是时间戳，要算的
                    NSString* avfileName = [[NSString alloc]initWithFormat:@"%d",name_temp];
                    fileName = [avfileName stringByAppendingPathExtension:smallAVfileType];
                    //2.存储目录
                    NSString *homeDir = NSHomeDirectory();
                    NSString *storageDir = [[NSString alloc]initWithFormat:@"%@/Library/video",homeDir];
                    if([[NSFileManager defaultManager]fileExistsAtPath:storageDir]==NO)
                    {
                        BOOL result = [[NSFileManager defaultManager]createDirectoryAtPath:storageDir withIntermediateDirectories:YES attributes:nil error:nil];
                        if(result == YES)
                            NSLog(@"小视频接受文件夹创建成功");
                        else
                            NSLog(@"小视频接受文件夹创建失败");
                    }else{
                        NSLog(@"小视频接受文件夹已创建");
                    }
                    
                    //3.存储路径
                    NSString *avfilepath = [storageDir stringByAppendingPathComponent:fileName];
                    
                    //4 获取文件
                    [file_elem getToFile:avfilepath succ:^{
                        NSLog(@"小视频存储 success");
                        // 存数据库相关的操作
                    } fail:^(int code, NSString *msg) {
                        NSLog(@"小视频存储 failed");
                    }];
                    
                }
                
                
                
                
            }
            else if ([elem isKindOfClass:[TIMCustomElem class]]){
                TIMCustomElem *custom_elem = (TIMCustomElem*)elem;
                // 自定义的描述信息
                NSString *desc = [custom_elem desc];
                if(desc!=nil && [desc isEqualToString:@"make a friend with you"]){
                    // 添加好友请求
                    NSData *rec_data = [custom_elem data];
                    NSString *target_nickName = [[NSString alloc]initWithData:rec_data encoding:NSUTF8StringEncoding];
                    // 判断发送该请求的人是否已经是好友
                    [[TIMFriendshipManager sharedInstance]GetFriendList:^(NSArray *friends) {
                        BOOL isMyFriend = NO; // 标记是否是好友
                        // 快速遍历自己的好友列表，判断是否存在发送人
                        for(TIMUserProfile *tim_userProfile in friends) {
                            NSString* afriend_uid = [tim_userProfile identifier];
                            if(afriend_uid!=nil && [afriend_uid isEqualToString:sender]){
                                isMyFriend = YES;
                                break;
                            }
                        }
                        // 不是好友
                        if(isMyFriend == NO){
                            // 做相关操作，存入数据库，未添加好友列表
                        }
                        
                    } fail:^(int code, NSString *msg) {
                        NSLog(@"从服务器获取好友列表失败。无法得知是否已经是好友");
                    }];
                    
                    
                    
                }
                else if(desc!=nil && [desc isEqualToString:@"okay_make a friend with you"]){
                    // 加好友反馈消息——同意,对方已经双向加好友了。但需要更新好友列表
                    [[TIMFriendshipManager sharedInstance] GetFriendList:^(NSArray *friends) {
                        NSLog(@"添加好友成功");
                    } fail:^(int code, NSString *msg) {
                        
                    }];
                    
                }
                else if (desc!=nil && [desc isEqualToString:@"I wana enter into your group"]){
                    
                    NSData* postInfo_Data = [custom_elem data];
                    NSString *postInfo_Str = [[NSString alloc]initWithData:postInfo_Data encoding:NSUTF8StringEncoding];
                    
                    NSString *groupID = [[NSString alloc]init];
                    NSString *rec_nickName = [[NSString alloc]init];
                    NSData *jsonData = postInfo_Data;
                    NSError *error = nil;
                    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
                    if([jsonObject isKindOfClass:[NSDictionary class]]){
                        NSDictionary *dic = (NSDictionary*)jsonObject;
                        groupID = [dic objectForKey:@"GroupID"];
                        rec_nickName = [dic objectForKey:@"NickName"];
                        
                    }else if([jsonObject isKindOfClass:[NSArray class]]){
                        NSLog(@"收到申请群消息，但json解析不支持字典模式");
                        return;
                    }else{
                        NSLog(@"收到申请群消息，但json解析失败");
                        return;
                    }
                    
                    // 根据对应的groupID判定成员是否加入群
                    [[TIMGroupManager sharedInstance] GetGroupMembers:groupID succ:^(NSArray *members) {
                        // 标记是否加入群组
                        BOOL entered = NO;
                        for(TIMGroupMemberInfo *tim_groupMemInfo in members){
                            if([tim_groupMemInfo member]!=nil && [[tim_groupMemInfo member] isEqualToString:sender]){
                                entered = YES;
                                break;
                            }
                        }
                        // 如果未加入群组，将加群消息放置在数据库
                        if (entered == NO) {
                            // 数据库相应的操作
                            
                        }
                        
                        
                        
                    } fail:^(int code, NSString *msg) {
                        
                    }];
                    
                    
                }
                
            }
            
            
            
        }
        
        
        
    }
    
}
@end


@implementation TXMsgListener

@end
