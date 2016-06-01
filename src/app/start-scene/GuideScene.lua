----------------------------
--版权:
--作者: liubo (564773807@qq.com)
--时间: 2016-06-01 18:54:49
--作用:
--备注:
----------------------------

local GuideScene = class("GuideScene", function()
    return display.newScene()
end)

function GuideScene:ctor()
    local rootNode = require("cocos-studio.guide.guide").create()['root']
    rootNode:addTo(self)

    self._currentIndex = 1
    --取子空件
    self._pageview = rootNode:getChildByName("guide_pv")
    self._skipBtn = rootNode:getChildByName("skip_btn")
    --表示第几幅图的小点
    self._guides = {}
    for i = 1, 10 do
        self._guides[i] = rootNode:getChildByName(string.format("p%d_sprite", i))
    end

    --为按钮添加事件
    self._skipBtn:addTouchEventListener(function(touch, event)
        local scene = require("app.start-scene.StartScene"):create()
        display.runScene(scene)
    end)

    -- 监听pageview当前页数， 高亮对应的小点
    self._pageview:addEventListener(function(sender, eventType)
        local index = self._pageview:getCurPageIndex()
        self:updatePointStatus(index + 1)
    end)
end

--更新显示当前页面小点的状态
function GuideScene:updatePointStatus(index)
    if self._currentIndex == index then return end

    self._currentIndex = index
    for _, guide in ipairs(self._guides) do
        guide:setOpacity(153)
    end
    self._guides[index]:setOpacity(255)
    -- self._guides[index]:setColor(cc.c3b(0, 0, 0))
end

return GuideScene