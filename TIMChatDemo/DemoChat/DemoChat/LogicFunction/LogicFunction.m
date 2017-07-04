//
//  LogicFunction.m
//  DemoChat
//
//  Created by AlexanderYeah on 2017/7/3.
//  Copyright © 2017年 AlexanderYeah. All rights reserved.
//

#import "LogicFunction.h"
#import <CommonCrypto/CommonDigest.h>
@implementation LogicFunction

//－－－－－－－－－－－－－辅助函数－－－－－－－－－－－－－
+ (NSString*)GetUserSigFromSerByUserID:(NSString*)usrName andPassword:(NSString*)psd {
    NSString *md5_psd = [self GetMD5OfString:psd];
    
    //第一步，创建URL
    
    NSString * URLString = [[NSString alloc]initWithFormat:@"http://%@/yourapp/auth.php",@"这个地址就是你获取userfsig的地址"];
    NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString* postString =[[NSString alloc]init];
    //设定Post参数
    postString = [[NSString alloc]initWithFormat:@"username=%@&pwd=%@",usrName,md5_psd];
    
    NSData* postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    //第二步，创建请求
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    [request setTimeoutInterval:10]; //设定5秒超时
    
    //第三步，连接服务器
    NSURLResponse * response;
    NSError * error;
    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    int code = (int)httpResponse.statusCode;
    
    if (code!=200) {
        NSLog(@"error:连接服务器出错");
        return nil;
    }else{
        NSLog(@"response: %@",response);//响应结果
        
        NSString* ret=[[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding];
        NSLog(@"Alex--UserSig: %@",ret);//返回的数据
        
        return ret;
    }
}


+(NSString*)GetMD5OfString:(NSString*)str
{
    char *c = (char*)[str UTF8String];
    unsigned char result[16];
    CC_MD5(c,(CC_LONG)strlen(c),result);
    NSString *md5 = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],result[8],result[9],result[10],result[11],result[12],result[13],result[14],result[15]];
    md5 = [md5 lowercaseString];
    return md5;
}



@end
