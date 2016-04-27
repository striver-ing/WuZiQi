//
//  BlueToothController.h
//  BlueTooth
//
//  Created by LIUBO on 15/9/24.
//
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>  //蓝牙需要

typedef void (*ReceivedMessageCallback)(const char* msg);

@interface BlueToothController : UIViewController<GKPeerPickerControllerDelegate, GKSessionDelegate> {
}

+ (instancetype)getInstance;

- (void)searchBleAndConnect;
- (void)closeConnected;

- (void)sendMessage:(NSString*)message;
- (void)addReceiveMessageCallBack:(ReceivedMessageCallback)receiveMessageCallback;
//@property(nonatomic, assign, setter=addReceiveMessageCallBack:) ReceivedMessageCallback* receivedMessageCallback;

@end