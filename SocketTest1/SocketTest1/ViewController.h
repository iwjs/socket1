//
//  ViewController.h
//  SocketTest1
//
//  Created by 88 on 13-9-26.
//  Copyright (c) 2013年 88. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncUdpSocket.h"

@interface ViewController : UIViewController

@property (nonatomic , strong) AsyncUdpSocket *socket;

-(IBAction)sendMessage:(id)sender;

@end
