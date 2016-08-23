----------------------------
--版权:
--作者: liubo (564773807@qq.com)
--时间: 2016-03-18 19:10:20
--作用: 人机对弈
--备注:
----------------------------

local HumanVsAIScene = class("HumanVsAIScene", require("app.game-scene.GameBaseScene"))
local AI = require("app.ai-algorithm.AI")

local computer = WHITE
local human = BLACK
local isAdding = false
local isComputerFirst = true

function HumanVsAIScene:onCreate()
    Log.d("人机对弈")

    --设置悔棋步数
    self:setRetractChessStep(2)

    self:setComputerFirst(true)

    self._chessboard:addTouchCallFunc(function(row, col)
        if isAdding then return end

        if self._chessboard:getNextTurnChessType() == human then
            self._chessboard:addChess(row, col)

            -- AI.setComputerChessType(human)
            -- Log.d("aiAddChess() color = " .. human)
            -- self:aiAddChess()
        end
        if self._chessboard:getNextTurnChessType() == computer then
            isAdding = true
            self:showAddingChessTip()

            performWithDelay(self, function()
                -- Log.d("电脑下子")
                -- AI.setComputerChessType(computer)
                self:aiAddChess()
                -- self:aiAddChessByFeatureStep(2)
            end, 0.01)
        end
    end)

end

--必须设置（在下子前设置）
function HumanVsAIScene:setComputerFirst(flag)
    isComputerFirst = flag

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
        self:hideAddingChess()
    end)
end

--利用极大极小算法下子
function HumanVsAIScene:aiAddChessByFeatureStep(depth)
    local position = AI.getNextPlayChessPosition(self._chessboard:getChessBoardArray(), depth)
    self._chessboard:addChess(position.row, position.col, function ()
        isAdding = false;
        self:hideAddingChess()
        Log.d("电脑下子完毕")
    end)
end

--重写gameBaseScene的提示
function HumanVsAIScene:hint()
    self:aiAddChess() -- 替人下
    self:aiAddChess() -- 电脑自己下
end

--重写gameBaseScene reStart 方法
function HumanVsAIScene:reStart()
    self._chessboard:restartGame()
    self:setComputerFirst(not isComputerFirst)
    self:resetGameTime()
    self:stopAction(self._scheduleAction)
end

return HumanVsAIScene
