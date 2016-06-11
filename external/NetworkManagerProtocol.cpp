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

void NetworkManagerProtocol::addReceivedMessageCallback(ReceivedMessageCallback receivedMessageCallback) {
    _receivedMessageCallbacks.push_back(receivedMessageCallback);
}

void NetworkManagerProtocol::addOnConnectedCallback(OnConnectedCallback onConnectedCallback) {
    _onConnectedCallback = onConnectedCallback;
}

void NetworkManagerProtocol::addOnDisconnectedCallback(OnDisconnectedCallback onDisconnectedCallback) {
    _onDisconnectedCallback = onDisconnectedCallback;
}

void NetworkManagerProtocol::addCannelConnectedCallback(CannelConnectedCallback cannelConnectedCallback) {
    _cannelConnectedCallback = cannelConnectedCallback;
}

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
