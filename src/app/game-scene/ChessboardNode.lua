----------------------------
--版权: 564773807@qq.com
--作用: 棋盘
--作者: liubo
--时间: 20160129
--备注:
----------------------------

local ChessboardNode = class("ChessboardNode", function ()
    return display.newNode()
end)

local NO_CHESS     = -1
local WHITE_CHESS  = 0
local BLACK_CHESS = 1

function ChessboardNode:ctor()
    --棋盘
    self._chessboard = display.newSprite("chess.png"):addTo(self)
    self._chessboard:setAnchorPoint(cc.p(0.5, 0))

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self._chessboard)

    self:initChessboardArray()
end

function ChessboardNode:initChessboardArray()
        --棋盘数组
    self._chessboardArray = {}
    for i = 1, 15 do
        self._chessboardArray[i] = {}
        for j = 1, 15 do
            self._chessboardArray[i][j] = NO_CHESS
        end
    end

    dump(self._chessboardArray, "chessboardArray")
end

function ChessboardNode:addTouchCallFunc(callfunc)
    self._touchCallFunc = callfunc
end

function ChessboardNode:onTouchBegan(touch, event)
    local row, col = self:convertToChessSpace(touch)
    --执行回调
    if self._touchCallFunc then
        self._touchCallFunc(row, col)
        --检查是否连成五子
        self:checkChessboard()
    end
    return true
end

--将棋盘坐标转换为格子坐标
function ChessboardNode:convertToChessSpace(touch)
    local touchLocation = self._chessboard:convertToNodeSpace(touch:getLocation())
    --左下角为（1，1）
    local row = math.round((touchLocation.x - CHESS_OFFSETX) / CHESS_SETP + 1)
    local col = math.round((touchLocation.y - CHESS_OFFSETY) / CHESS_SETP + 1)

    return row, col
end

function ChessboardNode:addChess(row, col, chessType)
    --触摸到边界外
    if row < 1 or row > CHESS_GRID_NUM or col < 1 or col > CHESS_GRID_NUM  then  return end

    SoundManager.playEffect("chess.wav")
    local posX = (row - 1) * CHESS_SETP + CHESS_OFFSETX
    local posY = (col - 1) * CHESS_SETP + CHESS_OFFSETY

    local chess = nil
    if chessType == WHITE then
        chess = display.newSprite("white.png")
        self._chessboardArray[row][col] = WHITE_CHESS
    else
        chess = display.newSprite("black.png")
        self._chessboardArray[row][col] = BLACK_CHESS
    end
    chess:setPosition(posX, posY)
    chess:addTo(self._chessboard)
end

function ChessboardNode:removeAllChess()
    self._chessboard:removeAllChildren()
    self:initChessboardArray()
end

--检测是否连成五子
function ChessboardNode:checkChessboard()
end


return ChessboardNode
