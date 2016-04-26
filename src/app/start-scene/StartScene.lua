----------------------------
--版权: 564773807@qq.com
--作用: 开始界面
--作者: liubo
--时间: 20160306
--备注:
----------------------------

local StartScene = class("StartScene", function()
    return display.newScene()
end)

function StartScene:ctor()
    -- add background image
    display.newSprite("bk.jpg")
        :move(display.center)
        :addTo(self)

    --人机对战
    self:addButton("model.png", display.visiblesizeWidth / 2, display.visiblesizeHeight * 0.6 , function(sender, eventType)
        local scene = require("app.game-scene.HumanVsAIScene"):create()
        display.runScene(scene)
    end)

    --双人对弈
    self:addButton("doublem.png", display.visiblesizeWidth / 2, display.visiblesizeHeight * 0.45 , function(sender, eventType)
        local scene = require("app.game-scene.DoubleVsScene"):create()
        display.runScene(scene)
    end)

    --蓝牙对弈
    self:addButton("doublem.png", display.visiblesizeWidth / 2, display.visiblesizeHeight * 0.3, function(sender, eventType)
        local scene = require("app.game-scene.BleVsScene"):create()
        display.runScene(scene)
    end)


    --残局对弈
    self:addButton("doublem.png", display.visiblesizeWidth / 2, display.visiblesizeHeight * 0.15, function(sender, eventType)
    end)
end

function StartScene:addButton(img, posX, posY, callFunc)
    local btn = ccui.Button:create()
    btn:loadTextureNormal(img)
    btn:setPosition(cc.p(posX, posY))
    btn:addTo(self)
    btn:addTouchEventListener(callFunc)
end



return StartScene