----------------------------
--版权: 564773807@qq.com
--作用: 双人对弈
--作者: liubo
--时间: 20160308
--备注:
----------------------------

local DoubleVsScene = class("DoubleVsScene", require("app.game-scene.GameBaseScene"))

function DoubleVsScene:onCreate()
    Log.d("双人对弈")

    local isWhiteTurn = true
    self._chessboard:addTouchCallFunc(function(row, col)
        if isWhiteTurn then
            self._chessboard:addChess(row, col, WHITE)
            isWhiteTurn = false
        else
            self._chessboard:addChess(row, col, BLACK)
            isWhiteTurn = true
        end

    end)
end

return DoubleVsScene