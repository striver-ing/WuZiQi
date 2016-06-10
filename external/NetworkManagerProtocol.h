/********************************************************************
 @file           NetworkManagerProtocol.h
 @copyright
 @author         LIUBO(564773807@qq.com)
 @version        1.0
 @date           16/4/29
 @brief          联机对弈接口
 @detail         Starts the detailed description.
 *********************************************************************/

#pragma once
#include <stdio.h>
#include <iostream>
#include <vector>
#include <functional>
using namespace std;

// typedef void (*ReceiveMessageCallback)(const char* msg);//无法获取形参以外的参数
typedef std::function<void(const char*)> ReceivedMessageCallback;
typedef std::function<void()> OnConnectedCallback;
typedef std::function<void()> OnDisconnectedCallback;
typedef std::function<void()> CannelConnectedCallback;

class NetworkManagerProtocol {
protected:
    std::vector<ReceivedMessageCallback> _receivedMessageCallbacks;
    OnConnectedCallback _onConnectedCallback;
    OnDisconnectedCallback _onDisconnectedCallback;
    CannelConnectedCallback _cannelConnectedCallback;

public:
    virtual void searchBleAndConnect() = 0;
    virtual void closeConnected() = 0;
    virtual void sendMessage(const char* message) = 0;
    virtual bool isConnected() = 0;

    virtual void addReceivedMessageCallback(ReceivedMessageCallback receivedMessageCallback) = 0;
    virtual void addOnConnectedCallback(OnConnectedCallback onConnectedCallback) = 0;
    virtual void addOnDisconnectedCallback(OnDisconnectedCallback onDisconnectedCallback) = 0;
    virtual void addCannelConnectedCallback(CannelConnectedCallback cannelConnectedCallback) = 0;

    void executeReceivedMessageCallback(const char* message);
    void executeOnConnectedCallback();
    void executeOnDisconnectedCallback();
    void executeCannelConnectedCallback();
};