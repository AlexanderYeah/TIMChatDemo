//
//  TXConnListener.m
//  DemoChat
//
//  Created by AlexanderYeah on 2017/7/3.
//  Copyright © 2017年 AlexanderYeah. All rights reserved.
//

#import "TXConnListener.h"
@implementation TIMConnListener
-(void)onConnecting {
    NSLog(@"腾讯SDK 连接中");
}
-(void)onConnSucc {
    NSLog(@"腾讯SDK 连接成功");
}
-(void)onConnFailed:(int)code err:(NSString *)err {
    NSLog(@"腾讯SDK 连接失败 code=%d error=%@",code,err);
}
-(void)onDisconnect:(int)code err:(NSString *)err {
    NSLog(@"腾讯SDK 连接断开 code=%d error=%@",code,err);
}
@end


@implementation TXConnListener

@end
