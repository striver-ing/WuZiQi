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

class NetworkManagerProtocol {
protected:
    std::vector<ReceivedMessageCallback> _receivedMessageCallbacks;
    void executeReceivedMessageCallback(const char* message);

public:
    virtual void searchBleAndConnect() = 0;
    virtual void closeConnected() = 0;
    virtual void sendMessage(const char* message) = 0;
    virtual void addReceivedMessageCallback(ReceivedMessageCallback receivedMessageCallback) = 0;

    void notifyReceivedMessageCallback(const char* message);
};