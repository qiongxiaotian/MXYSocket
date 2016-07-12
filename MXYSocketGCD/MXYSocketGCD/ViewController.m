//
//  ViewController.m
//  MXYSocketGCD
//
//  Created by heivr.mxy on 16/7/12.
//  Copyright © 2016年 heivr.mxy. All rights reserved.
//

#import "ViewController.h"
#import "SocketDemo.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SocketDemo sharedInstance].socketHost = @"192.168.1.107";// host设定
    [SocketDemo sharedInstance].socketPort = 55555;//port 设定
    
    // 在连接前先进行手动断开
    [SocketDemo sharedInstance].socket.userData = @(SocketOfflineByUser);
    [[SocketDemo sharedInstance] cutOffSocket];
    
    // 确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
    [SocketDemo sharedInstance].socket.userData = SocketOfflineByServer;
    [[SocketDemo sharedInstance] socketConnectHost];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
