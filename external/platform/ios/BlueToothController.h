//
//  BlueToothController.h
//  BlueTooth
//
//  Created by LIUBO on 15/9/24.
//
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>  //蓝牙需要
#include <functional>
#include <vector>

// typedef void (*ReceivedMessageCallback)(const char* msg);
typedef std::function<void(const char*)> ReceivedMessageCallback;

@interface BlueToothController : UIViewController<GKPeerPickerControllerDelegate, GKSessionDelegate> {
}

+ (instancetype)getInstance;

- (void)searchBleAndConnect;
- (void)closeConnected;

- (void)sendMessage:(NSString*)message;
- (void)addReceivedMessageCallback:(ReceivedMessageCallback)receiveMessageCallback;
//@property(nonatomic, assign, setter=addReceivedMessageCallBack:) ReceivedMessageCallback* receivedMessageCallback;

@end