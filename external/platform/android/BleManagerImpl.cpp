//
//  BleManagerImpl.cpp
//  WuZiQi
//
//  Created by LIUBO on 16/5/24.
//
//

#include "BleManager.h"
#include "cocos2d.h"
#include "platform/android/jni/JniHelper.h"

USING_NS_CC;

// set BluetoothManager to global reference for better performance
static jobject sBluetoothManagerObj = 0;

static void callBluetoothManagerVoidMethod(const char *name, const char *sig, ...) {
    JNIEnv *env = cocos2d::JniHelper::getEnv();
    jclass classId = env->FindClass("org/cocos2dx/lua/BluetoothManager");
    jmethodID mid = env->GetMethodID(classId, name, sig);
    if (mid != 0 && sBluetoothManagerObj != nullptr) {
        va_list args;
        va_start(args, sig);
        env->CallVoidMethodV(sBluetoothManagerObj, mid, args);
        va_end(args);
    } else {
        log("callBluetoothManagerVoidMethod failed.");
    }
    env->DeleteLocalRef(classId);
}

//为了保证单例 同java使用的是一个BluetoothManager对像
static void init() {
    if (0 == sBluetoothManagerObj) {
        JNIEnv *env = cocos2d::JniHelper::getEnv();
        jclass clzz = env->FindClass("org/cocos2dx/lua/BluetoothManager");
        if (clzz != 0) {
            jmethodID mid = env->GetStaticMethodID(clzz, "getInstance", "()Lorg/cocos2dx/lua/BluetoothManager;");  // Lorg/cocos2dx/lua/BluetoothManager  返回值类型为BluetoothManager
            if (mid != 0) {
                jobject obj = env->CallStaticObjectMethod(clzz, mid);
                if (obj != nullptr) {
                    sBluetoothManagerObj = env->NewGlobalRef(obj);
                    env->DeleteLocalRef(obj);
                } else {
                    log("BleManagerImpl init() NewGlobalRef failed.");
                }
            } else {
                log("BleManagerImpl init() failed.");
            }
            env->DeleteLocalRef(clzz);
        } else {
            log("can't find BluetoothManager");
        }
    }
}

void BleManager::searchBleAndConnect() {
    init();
    callBluetoothManagerVoidMethod("searchBleAndConnect", "()V");
}

void BleManager::closeConnected() {
    callBluetoothManagerVoidMethod("closeConnected", "()V");
}

void BleManager::sendMessage(const char *message) {
    JNIEnv *env = cocos2d::JniHelper::getEnv();
    jstring msg = env->NewStringUTF(message);
    callBluetoothManagerVoidMethod("sendMessage", "(Ljava/lang/String;)V", msg);
}

void BleManager::addReceivedMessageCallback(ReceivedMessageCallback receivedMessageCallback) {
    _receivedMessageCallbacks.push_back(receivedMessageCallback);
}

void BleManager::addOnConnectedCallback(OnConnectedCallback onConnectedCallback) {
    _onConnectedCallback = onConnectedCallback;
}

void BleManager::addOnDisconnectedCallback(OnDisconnectedCallback onDisconnectedCallback) {
    _onDisconnectedCallback = onDisconnectedCallback;
}

void BleManager::addCannelConnectedCallback(CannelConnectedCallback cannelConnectedCallback) {
    _cannelConnectedCallback = cannelConnectedCallback;
}