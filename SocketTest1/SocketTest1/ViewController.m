//
//  ViewController.m
//  SocketTest1
//
//  Created by 88 on 13-9-26.
//  Copyright (c) 2013年 88. All rights reserved.
//

#import "ViewController.h"
#import "AsyncUdpSocket.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (weak, nonatomic) IBOutlet UITextField *enterMessage;
@property (weak, nonatomic) IBOutlet UILabel *showMessage;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self openUDPServer];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//建立基于UDP的Socket连接
-(void)openUDPServer{
	//初始化udp
	self.socket=[[AsyncUdpSocket alloc] initWithDelegate:self];
	//绑定端口
	NSError *error = nil;
	[self.socket bindToPort:4333 error:&error];
    
    //发送广播设置
    [self.socket enableBroadcast:YES error:&error];
    
    //加入群里，能接收到群里其他客户端的消息
    [self.socket joinMulticastGroup:@"224.0.0.2" error:&error];
    
   	//启动接收线程
	[self.socket receiveWithTimeout:-1 tag:0];
    
}




#pragma mark -
#pragma mark UDP Delegate Methods
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    
    [self.socket receiveWithTimeout:-1 tag:0];
    NSLog(@"host---->%@",host);

    NSLog(@"data : %@" , [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    self.showMessage.text =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	//已经处理完毕
	return YES;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
	//无法发送时,返回的异常提示信息
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:[error description]
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:nil];
	[alert show];

	
}
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
	//无法接收时，返回异常提示信息
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:[error description]
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:nil];
	[alert show];

}


-(IBAction)sendMessage:(id)sender {
    BOOL res = [self.socket sendData:[self.enterMessage.text dataUsingEncoding:NSUTF8StringEncoding]
                              toHost:@"224.0.0.2"
                                port:4333
                         withTimeout:-1
                
                                 tag:0];
    
    
   	if (!res) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"发送失败"
													   delegate:self
											  cancelButtonTitle:@"取消"
											  otherButtonTitles:nil];
		[alert show];
	}


}


@end
