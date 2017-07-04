//
//  ViewController.m
//  DemoChat
//
//  Created by AlexanderYeah on 2017/6/30.
//  Copyright © 2017年 AlexanderYeah. All rights reserved.
//

#import "ViewController.h"
#import "CellularFunction.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldText;

@property (nonatomic,strong)CellularFunction *cf;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 调用登录
    self.cf = [[CellularFunction alloc]init];
    [self.cf InitTIMSDK];
    // userSig 此处只是示例，要进行后台获取的
    NSString *userSig =  @"dansdnas";
    
    [self.cf LoginTIMWithUserID:@"" andUserSig:userSig];
    
}



#pragma mark - 1 发送文本按钮 测试成功
- (IBAction)sendTextBtn:(id)sender {
    [self.cf SendTextByTIMWithRemoteID:@"test05" withContent:self.textFieldText.text withIsGroupMsg:NO];

}
#pragma mark - 2 发送图片按钮
- (IBAction)sendImgBtn:(id)sender {
   
    NSString *path = [[NSBundle mainBundle]pathForResource:@"2.png" ofType:nil];
    NSLog(@"alexander-path%@",path);
    [self.cf SendPicByTIMWithRemoteID:@"test05" withFilePath:path withIsGroupMsg:NO];
    
}
#pragma mark - 3 发送语音按钮
- (IBAction)sendSoundBtn:(id)sender {
    
    
}
#pragma mark - 4 发送小视频按钮
- (IBAction)sendSmallAVBtn:(id)sender {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"L.mp4" ofType:nil];
    NSLog(@"alexander-path%@",path);
    [self.cf SendSmallFileByTIMWithRemoteID:@"test05" withFilePath:path withIsGroupMsg:NO];
    
}


#pragma mark   收消息测试
// 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
