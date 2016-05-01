----------------------------
--版权:
--作者: liubo (564773807@qq.com)
--时间: 2016-04-26 18:26:22
--作用: 蓝牙对弈
--备注:
----------------------------

local BleVsScene = class("BleVsScene", require("app.game-scene.GameBaseScene"))

-- local BleManager = NetworkManagerFactory:produceBleManager()
local BleManager = require("utils.BleManager")

function BleVsScene:onCreate()
    Log.d("蓝牙对弈")

    local isWhiteTurn = true
    self._chessboard:addTouchCallFunc(function(row, col)
        BleManager.ownSideAddChess(row, col)
            -- self._chessboard:addChess(row, col)
    end)

    BleManager.enemySideAddChessCallback(function(row, col)
        self._chessboard:addChess(row, col)
    end)

    -- BleManager:searchBleAndConnect()

    BleManager.addReceivedMessageCallback(function (msg)
        Log.d(msg)
    end)

   self:addButton(nil, display.cx, display.visibleoriginX + 80, self, function(sender, eventType)
        BleManager.sendMessage("😄")
    end, "发送消息😄", 50)

end

return BleVsScene