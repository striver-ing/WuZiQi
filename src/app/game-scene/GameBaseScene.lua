----------------------------
--版权: 564773807@qq.com
--作用: 游戏基类
--作者: liubo
--时间: 20160129
--备注:
----------------------------

local GameBaseScene = class("GameBaseScene", function()
    return display.newScene()
end)

function GameBaseScene:ctor()
    -- add background image
    display.newSprite("bg.jpg")
        :move(display.center)
        :addTo(self)

    self._chessboard = require("app.game-scene.ChessboardNode"):new()
    self._chessboard:setPosition(cc.p(display.cx,  display.visibleoriginY + 150))
    self._chessboard:addTo(self)

    --重玩
    local reStartBtn = ccui.Button:create():addTo(self)
    reStartBtn:setTitleText("重玩")
    reStartBtn:setTitleFontSize(50)
    reStartBtn:setPosition(cc.p(display.cx, display.top - 50))
    reStartBtn:addTouchEventListener(function (sender, eventType)
        if eventType ~= ccui.TouchEventType.ended then return end
            self._chessboard:removeAllChess()
    end)

    --子类程序入口
    if self.onCreate then self:onCreate() end
end

return GameBaseScene
