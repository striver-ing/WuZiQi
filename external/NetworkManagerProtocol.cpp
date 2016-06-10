//
// NetworkManagerProtocol.cpp
// WuZiQi
//
// Created by LIUBO on 16/4/29.
//
//
#include "NetworkManagerProtocol.h"
#include "cocos2d.h"

USING_NS_CC;

void NetworkManagerProtocol::executeReceivedMessageCallback(const char* message) {
    for (ReceivedMessageCallback callback : _receivedMessageCallbacks) {
        callback(message);
    }
}

void NetworkManagerProtocol::executeOnConnectedCallback() {
    if (_onConnectedCallback) {
        _onConnectedCallback();
    }
}

void NetworkManagerProtocol::executeOnDisconnectedCallback() {
    if (_onDisconnectedCallback) {
        _onDisconnectedCallback();
    }
}

void NetworkManagerProtocol::executeCannelConnectedCallback() {
    if (_cannelConnectedCallback) {
        _cannelConnectedCallback();
    }
}
