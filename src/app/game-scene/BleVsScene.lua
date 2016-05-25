----------------------------
--版权:
--作者: liubo (564773807@qq.com)
--时间: 2016-04-26 18:26:22
--作用: 蓝牙对弈
--备注:
----------------------------

local BleVsScene = class("BleVsScene", require("app.game-scene.GameBaseScene"))

local BleManager = require("utils.BleManager")
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

    --添加对方下棋的回调
    BleManager.enemySideAddChessCallback(function(row, col)
        Log.d("add chess " .. " row = " .. row .. " col = " .. col)
        self._chessboard:addChess(row, col)
    end)


    --接收到消息的回调
    BleManager.addReceivedMessageCallback(function (msg)
        Log.d(msg)
    end)

   self:addButton(nil, display.cx, display.visibleoriginX + 80, self, function(sender, eventType)
        BleManager.sendMessage("hello")
    end, "hello", 50)

end

function BleVsScene:init()
    ownPlayChessType = nil
end

return BleVsScene