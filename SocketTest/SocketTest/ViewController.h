//
//  ViewController.h
//  SocketTest
//
//  Created by 88 on 13-9-26.
//  Copyright (c) 2013年 88. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
#import "AsyncUdpSocket.h"

@interface ViewController : UIViewController<AsyncSocketDelegate>


@property (nonatomic,strong) AsyncUdpSocket *socket;

-(IBAction)sendMessage:(id)sender;

@end
