----------------------------
--版权:
--作者: liubo (564773807@qq.com)
--时间: 2016-04-26 18:26:22
--作用: 蓝牙对弈
--备注:
----------------------------

local BleVsScene = class("BleVsScene", require("app.game-scene.GameBaseScene"))

local BleManager = require("utils.BleManager")
local AI = require("app.ai-algorithm.AI")
local ownPlayChessType = nil

function BleVsScene:onCreate()
    Log.d("蓝牙对弈")
    self.init();
    BleManager:searchBleAndConnect()

    self._chessboard:addTouchCallFunc(function(row, col)
        if ownPlayChessType == nil then
            self._chessboard:addChess(row, col)
            ownPlayChessType = self._chessboard:getCurrentChessType()
            BleManager.ownSideAddChess(row, col)

        elseif ownPlayChessType == self._chessboard:getNextTurnChessType() then
            self._chessboard:addChess(row, col)
            BleManager.ownSideAddChess(row, col)
        end


    end)

    self:addCallback()


    -- --接收到消息的回调
    -- BleManager.addReceivedMessageCallback(function (msg)
    --     Log.d(msg)
    -- end)

   -- self:addButton(nil, display.cx, display.visibleoriginX + 80, self, function(sender, eventType)
   --      BleManager.sendMessage("hello")
   --  end, "hello", 50)

end

function BleVsScene:init()
    ownPlayChessType = nil
end

--悔棋
function BleVsScene:retractChess()
        -- 当前已下棋方不是自己 不能悔棋
    if ownPlayChessType == nil or ownPlayChessType == self._chessboard:getNextTurnChessType() then
        Dialog.show("现在不能悔棋😄")
    else
        BleManager.sendRequest(MSG.RETRACT)
        Dialog.show("悔棋请求已发出...")
    end
end

--重玩
function BleVsScene:reStart()
    BleManager.sendRequest(MSG.RESTART)
    Dialog.show("重玩请求已发出...")
end

--提示
function BleVsScene:hint()
   Dialog.show("不要耍赖哦！", "好吧")
end

--回调
function BleVsScene:addCallback()
    --添加对方下棋的回调
    BleManager.enemySideAddChessCallback(function(row, col)
        self._chessboard:addChess(row, col)
    end)

    --收到请求回调
    BleManager.addReceivedRequestCallback(function(request)
        if request == MSG.RETRACT then              -- 悔棋请求
            Log.d("悔棋请求")
            Dialog.show("让我悔下棋吧😭...", "允 许", "拒 绝", function(btnPos)
                if btnPos == 1 then                 --同意
                    self._chessboard:retractChess()
                    BleManager.sendRequest(MSG.RETRACT_OK)
                elseif btnPos == 2 then             --拒绝
                    BleManager.sendRequest(MSG.RETRACT_REFUSED)
                end

            end)

        elseif request == MSG.RETRACT_OK then       -- 同意悔棋
            Dialog.show("对方同意了您的请求")
            self._chessboard:retractChess()

        elseif request == MSG.RETRACT_REFUSED then  -- 拒绝悔棋
            Dialog.show("对方拒绝了您的请求")

        elseif request == MSG.RESTART then          -- 重玩请求
            Dialog.show("咱俩重玩吧😭...", "允 许", "拒 绝", function(btnPos)
                if btnPos == 1 then                 --同意
                    self:stopAction(self._scheduleAction)
                    self._chessboard:restartGame()
                    self:resetGameTime()

                    BleManager.sendRequest(MSG.RESTART_OK)

                elseif btnPos == 2 then             --拒绝
                    BleManager.sendRequest(MSG.RESTART_REFUSED)
                end

            end)

        elseif request == MSG.RESTART_OK then       -- 同意重玩
            Dialog.show("对方同意了您的请求")

            self:stopAction(self._scheduleAction)
            self._chessboard:restartGame()
            self:resetGameTime()

        elseif request == MSG.RESTART_REFUSED then  -- 拒绝重玩
            Dialog.show("对方拒绝了您的请求")
        end
    end)
end


return BleVsScene