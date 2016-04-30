//
// BleManager.cpp
// WuZiQi
//
// Created by LIUBO on 16/4/27.
//
//
#import "BleManager.h"
#import "BlueToothController.h"

void BleManager::searchBleAndConnect() {
    NSLog(@"getConnect");
    [[BlueToothController getInstance] searchBleAndConnect];
}

void BleManager::closeConnected() {
    [[BlueToothController getInstance] closeConnected];
}

void BleManager::sendMessage(const char* message) {
    NSString* msg = [NSString stringWithUTF8String:message];
    [[BlueToothController getInstance] sendMessage:msg];
}

void BleManager::addReceivedMessageCallBack(ReceivedMessageCallback receivedMessageCallback) {
    [[BlueToothController getInstance] addReceivedMessageCallBack:receivedMessageCallback];
}