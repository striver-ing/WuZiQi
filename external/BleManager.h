/********************************************************************
 @file               BleManager.h
 @copyright
 @author         LIUBO(564773807@qq.com)
 @version       1.0
 @date            16/4/27
 @brief            Starts a paragraph that serves as a brief description
 @detail          starts the detailed description.
 *********************************************************************/

#pragma once
#include "NetworkManagerProtocol.h"
#include "BleManager.h"

class BleManager : public NetworkManagerProtocol {
public:
    static BleManager* getInstance();
    virtual void searchBleAndConnect();
    virtual void closeConnected();
    virtual void sendMessage(const char* message);

    virtual bool isConnected();
};