----------------------------
--版权:
--作者: liubo (564773807@qq.com)
--时间: 2016-05-30 17:47:47
--作用: 这个layer用于拦截touch事件，在这个layer下面的所有Node都无法收到事件
--备注:
----------------------------

local MarkLayer = class("MarkLayer", function ()
    return cc.LayerColor:create(cc.c4b(0, 0, 0, 0))
end)

function MarkLayer:ctor()
    local listenner = cc.EventListenerTouchOneByOne:create()
    listenner:setSwallowTouches(true)
    listenner:registerScriptHandler(function(touch, event)
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, self)
end

return MarkLayer
