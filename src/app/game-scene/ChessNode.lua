----------------------------
--版权：
--作用: 棋盘
--作者: liubo
--时间: 20160129
--备注:
----------------------------

local ChessNode = class("ChessNode", function ()
    return display:newNode()
end)

function ChessNode:ctor()
    --棋盘
    self._chessboard = display.newSprite("chess.png"):addTo(self)
    self._chessboard:setAnchorPoint(cc.p(0.5, 0))

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self._chessboard)
end

function ChessNode:onTouchBegan(touch, event)
    Log.d("on touch begin ...")
    local touchLocation = self._chessboard:convertToNodeSpace(touch:getLocation())
    --左下角为（1，1）
    local row = math.round((touchLocation.x - CHESS_OFFSETX) / CHESS_SETP + 1)
    local col = math.round((touchLocation.y - CHESS_OFFSETY) / CHESS_SETP + 1)
    --触摸到边界外
    if row < 1 or row > CHESS_GRID_NUM or col < 1 or col > CHESS_GRID_NUM  then
        return false
    end

    Log.d("row = " .. row .. " col = " .. col)
    self:addChess(row, col)

    return true
end

function ChessNode:onTouchEnded(touch, event)
    Log.d("on touch ended ...")
end

function ChessNode:addChess(row, col)
    SoundManager.playEffect("chess.wav")
    local posX = (row - 1) * CHESS_SETP + CHESS_OFFSETX
    local posY = (col - 1) * CHESS_SETP + CHESS_OFFSETY

    local chess = display.newSprite("black.png")
    chess:setPosition(posX, posY)
    chess:addTo(self._chessboard)
end

function ChessNode:removeAllChess()
    self._chessboard:removeAllChildren()
end


return ChessNode
