//
// BleToothManagerTest.cpp
// WuZiQi
//
// Created by LIUBO on 16/4/27.
//
//
#include "BleToothManagerTest.h"
#include "BleManager.h"

bool BleToothManagerTest::init() {
    if (!Layer::init()) {
        return false;
    }
    auto visibleSize = Director::getInstance()->getVisibleSize();

    auto connecBtn = createBtn((char*)"搜索蓝牙", Vec2(visibleSize.width / 2, visibleSize.height * 0.8));
    connecBtn->addTouchEventListener([=](Ref* sender, Widget::TouchEventType type) {
        if (type == Widget::TouchEventType::ENDED) {
            BleManager::getInstance()->searchBleAndConnect();
        }

    });

    auto sendMsg = createBtn((char*)"发送数据hello", Vec2(visibleSize.width / 2, visibleSize.height * 0.6));
    sendMsg->addTouchEventListener([=](Ref* sender, Widget::TouchEventType type) {
        if (type == Widget::TouchEventType::ENDED) {
            BleManager::getInstance()->sendMessage("hello");
        }

    });

    auto closeBtn = createBtn((char*)"断开蓝牙", Vec2(visibleSize.width / 2, visibleSize.height * 0.4));
    closeBtn->addTouchEventListener([=](Ref* sender, Widget::TouchEventType type) {
        if (type == Widget::TouchEventType::ENDED) {
            BleManager::getInstance()->closeConnected();
        }

    });

    BleManager::getInstance()->addReceiveMessageCallBack([](const char* msg) { MessageBox(msg, "收到数据"); });

    return true;
}

Button* BleToothManagerTest::createBtn(char* text, Vec2 p) {
    auto btn = Button::create();
    btn->setTitleText(text);
    btn->setTitleFontSize(40);
    btn->setPosition(p);
    addChild(btn);

    return btn;
}