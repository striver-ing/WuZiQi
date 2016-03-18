----------------------------
--版权:
--作者: liubo (564773807@qq.com)
--时间: 2016-03-18 19:10:20
--作用:
--备注:
----------------------------

local HumanVsAIScene = class("HumanVsAIScene", require("app.game-scene.GameBaseScene"))
local AI = require("app.game-scene.AI")

function HumanVsAIScene:onCreate()
    Log.d("人机对弈")

    local isWhiteTurn = true
    self._chessboard:addTouchCallFunc(function(row, col)
            self._chessboard:addChess(row, col)
    end)

    local chessBoardArray = self._chessboard:getChessBoardArray()
    --重玩
    self:addButton(nil, "分析8 8 black点", 50, display.visiblesizeWidth / 2, display.visibleoriginX + 50, function(sender, eventType)
        AI.evalatePoint(chessBoardArray, 8, 8, BLACK)
    end)

end

return HumanVsAIScene