----------------------------
--版权：
--作用: 游戏主场景
--作者: liubo
--时间: 20160129
--备注:
----------------------------

local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- add background image
    display.newSprite("bg.jpg")
        :move(display.center)
        :addTo(self)

    local chessNode = require("app.game-scene.ChessNode"):new()
    chessNode:setPosition(cc.p(display.cx,  display.visibleoriginY + 150))
    chessNode:addTo(self)

    local reStartBtn = ccui.Button:create():addTo(self)
    reStartBtn:setTitleText("重玩")
    reStartBtn:setTitleFontSize(50)
    reStartBtn:setPosition(cc.p(display.cx, display.top))
    reStartBtn:addTouchEventListener(function (sender, eventType)
        if eventType ~= ccui.TouchEventType.ended then return end
        chessNode:removeAllChess()

    end)



end

return MainScene
