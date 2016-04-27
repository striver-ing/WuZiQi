/********************************************************************
 @file           BleToothManagerTest.h
 @copyright      
 @author         LIUBO(564773807@qq.com)
 @version        1.0
 @date           16/4/27
 @brief          Starts a paragraph that serves as a brief description
 @detail         Starts the detailed description.
 *********************************************************************/

#pragma once
#include <stdio.h>
#include "cocos2d.h"
#include "ui/CocosGUI.h"

USING_NS_CC;
using namespace ui;

class BleToothManagerTest : public Layer {
public:
    virtual bool init();
    Button* createBtn(char * text,Vec2 p);
    CREATE_FUNC(BleToothManagerTest);

};