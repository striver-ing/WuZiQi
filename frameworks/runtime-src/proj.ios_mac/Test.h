//
//  Test.h
//  WuZiQi
//
//  Created by LIUBO on 16/1/29.
//
//

#ifndef Test_h
#define Test_h

#include <stdio.h>
#include "cocos2d.h"

USING_NS_CC;

class Test : public Sprite{
    void test(){
        auto listener = EventListenerTouchOneByOne::create();
        Director::getInstance()->getEventDispatcher()->addEventListenerWithSceneGraphPriority(listener, this);
    }
};


#endif /* Test_h */
