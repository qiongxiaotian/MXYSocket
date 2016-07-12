//
//  SocketDemo.h
//  MXYSocketGCD
//
//  Created by heivr.mxy on 16/7/12.
//  Copyright © 2016年 heivr.mxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>
enum {
    SocketOfflineByServer,//服务器掉线默认为0
    SocketOfflineByUser,//用户主动cut
};

@interface SocketDemo : NSObject<GCDAsyncSocketDelegate>

@property (nonatomic, copy)   NSString  *socketHost;
@property (nonatomic, assign) UInt16  socketPort;
@property (nonatomic,strong)GCDAsyncSocket *socket;
@property (nonatomic,retain)NSTimer *connectTimer;

- (void)socketConnectHost;//建立连接
- (void)cutOffSocket;//断开连接


+(SocketDemo *)sharedInstance;
@end
