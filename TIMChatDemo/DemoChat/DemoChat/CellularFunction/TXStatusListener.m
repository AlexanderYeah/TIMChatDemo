//
//  TXStatusListener.m
//  DemoChat
//
//  Created by AlexanderYeah on 2017/7/3.
//  Copyright © 2017年 AlexanderYeah. All rights reserved.
//

#import "TXStatusListener.h"
@implementation TIMUserStatusListerner
-(void)onForceOffline {
    NSLog(@"被踢下线");
}

-(void)onUserSigExpired {
    NSLog(@"票据过期");
    
}
@end

@implementation TXStatusListener

@end
