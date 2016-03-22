----------------------------
--版权:
--作者: liubo (564773807@qq.com)
--时间: 2016-03-18 19:10:20
--作用:
--备注:
----------------------------

local HumanVsAIScene = class("HumanVsAIScene", require("app.game-scene.GameBaseScene"))
local AI = require("app.game-scene.AI")

local computer = nil
local human = nil

function HumanVsAIScene:onCreate()
    Log.d("人机对弈")

    --设置悔棋步数
    self:setRetractChessStep(2)

    self:isComputerFirst(true)

    self._chessboard:addTouchCallFunc(function(row, col)
        if self._chessboard:getNextTurnChessType() == human then
            self._chessboard:addChess(row, col)
        end
        if self._chessboard:getNextTurnChessType() == computer then
            self:aiAddChess()
        end
    end)

    --重玩
    self:addButton(nil, "计算机下子", 50, display.visiblesizeWidth / 2, display.visibleoriginX + 50, function(sender, eventType)
    end)

end

function HumanVsAIScene:isComputerFirst(flag)
    if flag then
        self._chessboard:addChess(8, 8)
        computer = self._chessboard:getFirstChessType()
        human = self._chessboard:getBehindChessType()
    else
        human = self._chessboard:getFirstChessType()
        computer = self._chessboard:getBehindChessType()
    end
end

function HumanVsAIScene:aiAddChess()
    local chessType = self._chessboard:getNextTurnChessType()
    local row, col = AI.findMaxSorcePoint(self._chessboard:getChessBoardArray(), chessType)
    self._chessboard:addChess(row, col)
end

return HumanVsAIScene