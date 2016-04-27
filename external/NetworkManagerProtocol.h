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

typedef void (*ReceiveMessageCallback)(const char* msg);

class NetworkManagerProtocol {
public:
    //    static NetworkManagerProtocol* getInstance();

    virtual void searchBleAndConnect() = 0;
    virtual void closeConnected() = 0;
    virtual void sendMessage(const char* message) = 0;
    virtual void addReceiveMessageCallBack(ReceiveMessageCallback receiveMessageCallback) = 0;
};