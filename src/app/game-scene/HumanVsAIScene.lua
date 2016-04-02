----------------------------
--版权:
--作者: liubo (564773807@qq.com)
--时间: 2016-03-18 19:10:20
--作用:
--备注:
----------------------------

local HumanVsAIScene = class("HumanVsAIScene", require("app.game-scene.GameBaseScene"))
local AI = require("app.game-scene.AI")

local computer = WHITE
local human = BLACK
local isAdding = false

function HumanVsAIScene:onCreate()
    Log.d("人机对弈")

    --设置悔棋步数
    self:setRetractChessStep(2)

    self:isComputerFirst(true)

    self._chessboard:addTouchCallFunc(function(row, col)
        if isAdding then return end

        if self._chessboard:getNextTurnChessType() == human then
            -- self._chessboard:addChess(row, col)

            AI.setComputerChessType(human)
            Log.d("aiAddChess() color = " .. human)
            self:aiAddChess()
        end
        if self._chessboard:getNextTurnChessType() == computer then
            isAdding = true
            local scheduler = cc.Director:getInstance():getScheduler()
            performWithDelay(self, function()
                Log.d("电脑下子")
                AI.setComputerChessType(computer)
                -- self:aiAddChess()
                self:aiAddChessByFeatureStep(2)
            end, 0.01)
        end
    end)

end

--必须设置（在下子前设置）
function HumanVsAIScene:isComputerFirst(flag)
    if flag then
        self._chessboard:addChess(8, 8)
        computer = self._chessboard:getFirstChessType()
        human = self._chessboard:getBehindChessType()
    else
        human = self._chessboard:getFirstChessType()
        computer = self._chessboard:getBehindChessType()
    end

    AI.setComputerChessType(computer)
end

--就当前局势找最大分数处下子
function HumanVsAIScene:aiAddChess()
    local position = AI.getMaxSorcePoint(self._chessboard:getChessBoardArray())
    self._chessboard:addChess(position.row, position.col, function ()
        isAdding = false;
    end)
end

--利用极大极小算法下子
function HumanVsAIScene:aiAddChessByFeatureStep(depth)
    local position = AI.getNextPlayChessPosition(self._chessboard:getChessBoardArray(), depth)
    self._chessboard:addChess(position.row, position.col, function ()
        isAdding = false;
        Log.d("电脑下子完毕")
    end)
end

return HumanVsAIScene