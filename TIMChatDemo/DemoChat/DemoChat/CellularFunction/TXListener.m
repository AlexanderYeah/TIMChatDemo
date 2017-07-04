//
//  TXListener.m
//  DemoChat
//
//  Created by AlexanderYeah on 2017/6/30.
//  Copyright © 2017年 AlexanderYeah. All rights reserved.
//

#import "TXListener.h"


@implementation TLSPwdLoginListener
-(void)OnPwdLoginFail:(TLSErrInfo *)errInfo{

}
-(void)OnPwdLoginSuccess:(TLSUserInfo *)userInfo{

}

-(void)OnPwdLoginTimeout:(TLSErrInfo *)errInfo{

}
-(void)OnPwdLoginReaskImgcodeSuccess:(NSData *)picData{


}
-(void)OnPwdLoginNeedImgcode:(NSData *)picData andErrInfo:(TLSErrInfo *)errInfo{

}
@end



@implementation TLSStrAccountRegListener
-(void)OnStrAccountRegSuccess:(TLSUserInfo *)userInfo {
   
    NSLog(@"注册成功");
}
-(void)OnStrAccountRegFail:(TLSErrInfo *)errInfo {

    
}
- (void)OnStrAccountRegTimeout:(TLSErrInfo *)errInfo {

}
@end




