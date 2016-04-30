/********************************************************************
 @file           NetworkManagerFactory.h
 @copyright
 @author         LIUBO(564773807@qq.com)
 @version        1.0
 @date           16/4/29
 @brief          Starts a paragraph that serves as a brief description
 @detail         Starts the detailed description.
 *********************************************************************/

#pragma once
#include <stdio.h>
#include "NetworkManagerProtocol.h"

class NetworkManagerFactory {
public:
    static NetworkManagerProtocol* produceBleManager();
};