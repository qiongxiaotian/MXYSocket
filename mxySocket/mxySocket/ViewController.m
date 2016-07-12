//
//  ViewController.m
//  mxySocket
//
//  Created by heivr.mxy on 15/12/23.
//  Copyright © 2015年 heivr. All rights reserved.
//

#import "ViewController.h"
#import "socketDemo.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


     [socketDemo sharedInstance].socketHost = @"192.168.1.107";// host设定
     [socketDemo sharedInstance].socketPort = 55555;// port设定
     
     // 在连接前先进行手动断开
     [socketDemo sharedInstance].socket.userData = SocketOfflineByUser;
     [[socketDemo sharedInstance] cutOffSocket];
     
     // 确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
     [socketDemo sharedInstance].socket.userData = SocketOfflineByServer;
     [[socketDemo sharedInstance] socketConnectHost];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
