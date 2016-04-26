//
//  BlueToothController.m
//  BlueTooth
//
//  Created by LIUBO on 15/9/24.
//
//

#import "BlueToothControllerForOC.h"
#import <GameKit/GameKit.h>
#import "SVProgressHUD.h"

static BlueToothControllerForOC * blueToothController=nil;

@interface BlueToothControllerForOC ()

@end

@implementation BlueToothControllerForOC

#pragma mark - init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self addGestRecognizer];
}

#pragma mark - click

+(id)getInstance{
//    @synchronized 的作用是创建一个互斥锁，保证此时没有其它线程对self对象进行修改
    @synchronized(self) {
        if (blueToothController==nil) {
            blueToothController=[[self alloc]init];
        }
    }

    return blueToothController;
}

/*
 *利用GKPeerPickerController框架搜索附近的蓝牙设备
 */

//1.蓝牙连接
-(void) getConnect{
    pickerController = [[GKPeerPickerController alloc]init];
    pickerController.delegate = self;

    pickerController.connectionTypesMask = GKPeerPickerConnectionTypeNearby;// 使用蓝牙
    //    pickerController.connectionTypesMask = GKPeerPickerConnectionTypeOnline; //基于互联网的连接

    [pickerController show];
}

//2.发送数据
-(void) sendMessage:(NSString*) message{

    if(currentSession){
        NSString *msg = message;
        NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
        [currentSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
    }

}

//取消连接
-(void) closeConnect{
    [currentSession disconnectFromAllPeers];
    currentSession = nil;
    pickerController.delegate = nil;

}

#pragma mark - 空白处收起键盘
- (void)addGestRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    tap.numberOfTouchesRequired =1;
    tap.numberOfTapsRequired =1;
    tap.cancelsTouchesInView = NO;
    [scrollView addGestureRecognizer:tap];
}
- (void)tapped:(UIGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
}

#pragma mark - GKPeerPickerControllerDelegate
- (GKSession *) peerPickerController:(GKPeerPickerController *)picker
            sessionForConnectionType:(GKPeerPickerConnectionType)type {
    currentSession = [[GKSession alloc] initWithSessionID:@"sunnada_CoreBlueToothDemo" displayName:nil sessionMode:GKSessionModePeer];
    currentSession.delegate = self;

    return currentSession;
}

/* Notifies delegate that the user cancelled the picker.
 * 如果用户取消了蓝牙选择器
 */
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
//    [SVProgressHUD showErrorWithStatus:@"蓝牙连接取消"];
    picker.delegate = nil;
    currentSession = nil;
}

//连接后
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{

    currentSession = session;
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];

    picker.delegate = nil;
    [picker dismiss];

}

#pragma mark - GKSessionDelegate
//设备断开或连接时
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
    switch (state) {
        case GKPeerStateConnected:
//            [SVProgressHUD showSuccessWithStatus:@"蓝牙已连接"];
            break;
        case GKPeerStateDisconnected:
//            [SVProgressHUD showSuccessWithStatus:@"蓝牙已断开"];
            pickerController.delegate = nil;
            currentSession = nil;
            break;
        default:
            break;
    }
}

//方法功能：接受数据
-(void)receiveData:(NSData*)data fromPeer:(NSString*)peer inSession:(GKSession*)session context:(void*)context{
    _msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    [SVProgressHUD showSuccessWithStatus:@"数据接收成功"];
}

-(NSString*) getMessage{
    return _msg;
}

@end

