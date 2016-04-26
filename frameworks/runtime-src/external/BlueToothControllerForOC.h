//
//  BlueToothControllerForOC.h
//  BlueTooth
//
//  Created by LIUBO on 15/9/24.
//
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>//蓝牙需要

@interface BlueToothControllerForOC : UIViewController<GKPeerPickerControllerDelegate, GKSessionDelegate>{
    GKPeerPickerController *pickerController;//通过GKPeerPickerController开启手机蓝牙开关,不需要切换到Setting界面
    GKSession *currentSession;////GKSession对象用于表现两个蓝牙设备之间连接的一个会话，你也可以使用它在两个设备之间发送和接收数据

    IBOutlet UIScrollView *scrollView;

    NSString * _msg;
}

+(id)getInstance;

-(void) getConnect;
-(void) closeConnect;

-(void) sendMessage:(NSString*) message;
-(NSString*) getMessage;

@end