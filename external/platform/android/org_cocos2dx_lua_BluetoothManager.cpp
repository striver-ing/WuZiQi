//
//  org_cocos2dx_lua_BluetoothManager.cpp
//  WuZiQi
//
//  Created by LIUBO on 16/5/25.
//
//

#include "BleManager.h"
#include "cocos2d.h"
#include "platform/android/jni/JniHelper.h"
#include "org_cocos2dx_lua_BluetoothManager.h"

USING_NS_CC;

//收到蓝牙消息
JNIEXPORT void JNICALL Java_org_cocos2dx_lua_BluetoothManager_onDataReceived(JNIEnv *, jobject, jstring data) {
    Director::getInstance()->getScheduler()->performFunctionInCocosThread([&data]() {
        if (data != nullptr) {
            log("1.---------");
            const char *msg = JniHelper::jstring2string(data).c_str();
            log("2.---------");
            log("received msg = %s", data);
            log("3.---------");

            BleManager::getInstance()->notifyReceivedMessageCallback(msg);
        }
    });
}