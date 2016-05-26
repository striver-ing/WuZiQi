//
//  org_cocos2dx_lua_BluetoothManager.cpp
//  WuZiQi
//
//  Created by LIUBO on 16/5/25.
//
//

#include "BleManager.h"
#include "cocos2d.h"
#include <string>
#include "platform/android/jni/JniHelper.h"
#include "org_cocos2dx_lua_BluetoothManager.h"

USING_NS_CC;

//收到蓝牙消息
JNIEXPORT void JNICALL Java_org_cocos2dx_lua_BluetoothManager_onDataReceived(JNIEnv *env, jobject, jstring data) {
    if (data != nullptr) {
        std::string msg = JniHelper::jstring2string(data);
        Director::getInstance()->getScheduler()->performFunctionInCocosThread([=]() { BleManager::getInstance()->executeReceivedMessageCallback(msg.c_str()); });
    }
}

JNIEXPORT void JNICALL Java_org_cocos2dx_lua_BluetoothManager_isConnected(JNIEnv *, jobject) {
}

JNIEXPORT void JNICALL Java_org_cocos2dx_lua_BluetoothManager_disConnected(JNIEnv *, jobject) {
}
