//
//  socketDemo.h
//  mxySocket
//
//  Created by heivr.mxy on 15/12/23.
//  Copyright © 2015年 heivr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
//#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
//static dispatch_once_t onceToken = 0; \
//__strong static id sharedInstance = nil; \
//dispatch_once(&onceToken, ^{ \
//sharedInstance = block(); \
//}); \
//return sharedInstance; 
//
enum{
    SocketOfflineByServer,//服务器掉线默认为0
    SocketOfflineByUser,//用户主动cut
};

@interface socketDemo : NSObject<AsyncSocketDelegate>

@property (nonatomic,strong)AsyncSocket *socket;
@property (nonatomic,copy)NSString *socketHost;
@property (nonatomic,assign)UInt16 socketPort;
@property (nonatomic,retain)NSTimer *connectTimer;

+(socketDemo *)sharedInstance;

- (void)socketConnectHost;//建立连接
- (void)cutOffSocket;//断开连接

@end
