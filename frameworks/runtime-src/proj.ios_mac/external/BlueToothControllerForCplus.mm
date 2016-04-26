//
//  BlueTooth.m
//  BlueTooth
//
//  Created by LIUBO on 15/9/24.
//
//

#import "BlueToothControllerForCplus.h"
#import "BlueToothControllerForOC.h"

static BlueToothControllerForCplus * blueTooth=nil;


BlueToothControllerForCplus * BlueToothControllerForCplus::getInstance(){
    if (blueTooth==nil) {
        blueTooth=new BlueToothControllerForCplus();
    }

    return blueTooth;
}

void BlueToothControllerForCplus::getConnect(){
    NSLog(@"搜索蓝牙");

    [[BlueToothControllerForOC getInstance] getConnect];

}

void BlueToothControllerForCplus::closeConnect(){
    [[BlueToothControllerForOC getInstance] closeConnect];
}

void BlueToothControllerForCplus::sendMessage(const char * message){
    NSString * msg=[NSString stringWithUTF8String:message];

    [[BlueToothControllerForOC getInstance] sendMessage:msg];
}

const char* BlueToothControllerForCplus::getMessage(){
    NSString* msg=[[BlueToothControllerForOC getInstance]getMessage];
    NSLog(@"BlueToothControllerForCplus");

    return [msg UTF8String];
}



