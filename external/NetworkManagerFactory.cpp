//
// NetworkManagerFactory.cpp
// WuZiQi
//
// Created by LIUBO on 16/4/29.
//
//
#include "NetworkManagerFactory.h"
#include "BleManager.h"

NetworkManagerProtocol *NetworkManagerFactory::produceBleManager() {
    return BleManager::getInstance();
}