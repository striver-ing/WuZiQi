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
    [[BlueToothController getInstance] searchBleAndConnect];
}

void BleManager::closeConnected() {
    [[BlueToothController getInstance] closeConnected];
}

void BleManager::sendMessage(const char* message) {
    NSString* msg = [NSString stringWithUTF8String:message];
    [[BlueToothController getInstance] sendMessage:msg];
}

void BleManager::addReceivedMessageCallback(ReceivedMessageCallback receivedMessageCallback) {
    [[BlueToothController getInstance] addReceivedMessageCallback:receivedMessageCallback];
}

void BleManager::addOnConnectedCallback(OnConnectedCallback onConnectedCallback) {
    [[BlueToothController getInstance] addOnConnectedCallback:onConnectedCallback];
}
void BleManager::addOnDisconnectedCallback(OnDisconnectedCallback onDisconnectedCallback) {
    [[BlueToothController getInstance] addOnDisconnectedCallback:onDisconnectedCallback];
}
void BleManager::addCannelConnectedCallback(CannelConnectedCallback cannelConnectedCallback) {
    [[BlueToothController getInstance] addCannelConnectedCallback:cannelConnectedCallback];
}
