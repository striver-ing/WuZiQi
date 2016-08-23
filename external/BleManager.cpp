//
// BleManager.cpp
// WuZiQi
//
// Created by LIUBO on 16/4/27.
//
//
#include "BleManager.h"

static BleManager* bleManager = nullptr;

BleManager* BleManager::getInstance() {
    if (bleManager == nullptr) {
        bleManager = new (std::nothrow) BleManager();
    }

    return bleManager;
}
