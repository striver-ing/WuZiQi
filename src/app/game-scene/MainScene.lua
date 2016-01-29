
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



end

return MainScene
