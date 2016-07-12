//
//  socketDemo.m
//  mxySocket
//
//  Created by heivr.mxy on 15/12/23.
//  Copyright © 2015年 heivr. All rights reserved.
//

#import "socketDemo.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

@implementation socketDemo

+ (socketDemo*)sharedInstance{

    static socketDemo *sharedInstance = nil;
    
//    static dispatch_once_t oneTokent;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

//socket连接
- (void)socketConnectHost{

    self.socket = [[AsyncSocket alloc]initWithDelegate:self];
    
    NSError *error = nil;
    //设置网址和端口
    [self.socket connectToHost:self.socketHost onPort:self.socketPort withTimeout:3 error:&error];
    NSLog(@"error = %@",error);
}

//连接成功回调
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{

    NSLog(@"连接成功");
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];// 在longConnectToSocket方法中进行长连接需要向服务器发送的讯息
    [self.connectTimer fire];
    [self.socket readDataWithTimeout:-1 tag:0];
}
//发送数据
- (void)longConnectToSocket{
    // 根据服务器要求发送固定格式的数据
    NSString *longConnect = @"playy\n\n";
    NSLog(@"%@",longConnect);
    NSData   *dataStream  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:dataStream withTimeout:30 tag:1];
}
//切断socket
- (void)cutOffSocket{

    self.socket.userData = SocketOfflineByUser;//说明是用户主动断开切断
    [self.connectTimer invalidate];
    [self.socket disconnect];//断开socket连接
    
}
//连接失败的代理
- (void)onSocketDidDisconnect:(AsyncSocket *)sock{

    NSLog(@"连接失败 ，%ld",sock.userData);
    if (sock.userData == SocketOfflineByServer) {
        //服务器掉线重连
        NSLog(@"服务器掉线");
        [self socketConnectHost];
    }else if (sock.userData == SocketOfflineByUser){
        NSLog(@"用户断开不进行重连");
        return;
    }
}

//返回的数据
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{

    [self.socket readDataWithTimeout:-1 tag:0];
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"===%@",aStr);
    NSLog(@"%@",data);
}

@end
