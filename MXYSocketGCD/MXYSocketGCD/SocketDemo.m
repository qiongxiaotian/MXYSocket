//
//  SocketDemo.m
//  MXYSocketGCD
//
//  Created by heivr.mxy on 16/7/12.
//  Copyright © 2016年 heivr.mxy. All rights reserved.
//

#import "SocketDemo.h"
static NSTimeInterval const kSocketConnectTimeOut = 5.0;
static NSTimeInterval const kSocketConnectTimerTimeInterval = 30.0f;
static NSString     * const kSocketConnectString = @"longConnect";


@implementation SocketDemo

+ (SocketDemo*)sharedInstance{
    static SocketDemo *shareInstance = nil;
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        shareInstance = [[self alloc]init];
    });
    return shareInstance;
}
//连接
- (void)socketConnectHost{
    
    self.socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    //设置网址和端口
    [self.socket connectToHost:self.socketHost onPort:self.socketPort withTimeout:kSocketConnectTimeOut error:&error];
    NSLog(@"error = %@",error);
}
//断开
- (void)cutOffSocket{
    self.socket.userData = @(SocketOfflineByUser);
    [self.connectTimer invalidate];
    self.connectTimer = nil;
    [self.socket disconnect];//断开socket连接

}
#pragma mark delegate
/**
 *  Socket连接成功的回调
 *  注意：这里需要向服务器发送心跳包
 *
 *  @param sock 连接成功的Socket
 *  @param host 主机名
 *  @param port 端口
 */
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"连接成功");
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:kSocketConnectTimerTimeInterval target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];// 在longConnectToSocket方法中进行长连接需要向服务器发送的讯息
    [self.connectTimer fire];
    [self.socket readDataWithTimeout:-1 tag:0];
}
/**
 *  Socket断开连接的回调
 *  Note:这里需要判断Socket断开连接的原因：如果是用户自行断开，则不需要重新连接；如果是服务器断开连接，则需要进行重连
 *
 *  @param sock 断开连接的Socket
 *  @param err  错误描述
 */
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {
    NSLog(@"连接失败 userData = %@,error = %@",sock.userData,err);
    
    if ([sock.userData  isEqual: @(SocketOfflineByServer)]) {
        //服务器掉线重连
        NSLog(@"服务器掉线");
        [self socketConnectHost];
    }else if ([sock.userData  isEqual: @(SocketOfflineByUser)]){
        NSLog(@"用户断开不进行重连");
        return;
    }
}
/**
 *  读取放回的数据
 *
 *  @param sock 写入数据的Socket
 *  @data   返回的数据
 *  @param tag  The tag is for your convenience.
 *              You can use it as an array index, step number, state id, pointer, etc.
 */
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    [self.socket readDataWithTimeout:-1 tag:0];
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"===%@",aStr);
    NSLog(@"%@",data);

}


#pragma mark private method
//发送数据
- (void)longConnectToSocket{
    // 根据服务器要求发送固定格式的数据
    NSString *longConnect = kSocketConnectString;
    NSLog(@"%@",longConnect);
    NSData   *dataStream  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:dataStream withTimeout:30 tag:1];
}



@end
