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

local _retractCount = 1 --悔棋步数

function GameBaseScene:ctor()
    -- add background image
    display.newSprite("bg.jpg")
        :move(display.center)
        :addTo(self)

    --棋盘
    self._chessboard = require("app.game-scene.ChessboardNode"):new()
    self._chessboard:setPosition(cc.p(display.cx,  display.visibleoriginY + 150))
    self._chessboard:addTo(self)

    --功能按钮
    self:addSomeButton()

    --子类程序入口
    if self.onCreate then self:onCreate() end
end

--设置悔棋步数
function GameBaseScene:setRetractChessStep(retractCount)
    _retractCount = retractCount
end

--添加一些功能按钮
function GameBaseScene:addSomeButton()
    --重玩
    self:addButton(nil, "重玩", 50, display.cx - 100, display.top - 50, function(sender, eventType)
        self._chessboard:removeAllChess()
    end)

    --悔棋
    self:addButton(nil, "悔棋", 50, display.cx + 100, display.top - 50, function(sender, eventType)
      for i = 1, _retractCount do
         self._chessboard:retractChess()
      end
    end)
end

function GameBaseScene:addButton(img, text, fontSize, posX, posY, callFunc)
    local btn = ccui.Button:create()
    btn:setPosition(cc.p(posX, posY))
    btn:setTitleText(text)
    btn:setTitleFontSize(fontSize)
    btn:addTo(self)
    btn:addTouchEventListener(callFunc)
    if img then btn:loadTextureNormal(img) end
end

return GameBaseScene
