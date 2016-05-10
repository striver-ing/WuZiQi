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

local isWhiteTurn = false
local firstChessType = BLACK
local isGameOver = false
local chessNumber = 0  -- 棋子上显示序列号用
local IS_SHOW_CHESSNUMBER = true
local GameoverLayer = require("app.gameover-layer.GameoverLayer")

function ChessboardNode:ctor()
    --棋盘
    self._chessboard = display.newSprite("chess.png"):addTo(self)
    self._chessboard:setAnchorPoint(cc.p(0.5, 0))

    self:addChessboardListener()

    self:initChessboardArray()
end

function ChessboardNode:addChessboardListener()
    self._listener = cc.EventListenerTouchOneByOne:create()
    self._listener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)

    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self._listener, self._chessboard)
end

function ChessboardNode:remveChessboardListener()
    cc.Director:getInstance():getEventDispatcher():removeEventListener(self._listener)
end

function ChessboardNode:initChessboardArray()
    --棋盘数组
    self._chessboardArray = {}
    for i = 1, 15 do
        self._chessboardArray[i] = {}
        for j = 1, 15 do
            self._chessboardArray[i][j] = {}
            self._chessboardArray[i][j].type = NO_CHESS
            self._chessboardArray[i][j].chess = nil
        end
    end

    self._currentChessTip = nil
    self._chess = {}
    chessNumber = 0

    isGameOver = false
    isWhiteTurn = false

    -- dump(self._chessboardArray, "chessboardArray")
end

function ChessboardNode:getChessBoardArray()
    return self._chessboardArray
end

function ChessboardNode:addTouchCallFunc(callFunc)
    self._touchCallFunc = callFunc
end

function ChessboardNode:onTouchBegan(touch, event)
    local row, col = self:convertToChessSpace(touch)
    --执行回调
    if self._touchCallFunc then
        self._touchCallFunc(row, col)
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

--设置先执棋子(默认执黑)
function ChessboardNode:setFirstChessType(type)
    firstChessType = type

    if type == WHITE then
        isWhiteTurn = true
    else
        isWhiteTurn = false;
    end
end

--取先执子方
function ChessboardNode:getFirstChessType()
   return firstChessType
end

function ChessboardNode:getBehindChessType()
    return firstChessType == BLACK and WHITE or BLACK
end

function ChessboardNode:addChess(row, col, callFunc)
    if row == nil or col == nil then
        if callFunc then callFunc() end
        return
    end
    --触摸到边界外
    if row < 1 or row > CHESS_GRID_NUM or col < 1 or col > CHESS_GRID_NUM  or self._chessboardArray[row][col].type ~= NO_CHESS or isGameOver then
      if callFunc then callFunc() end
      return
    end

    SoundManager.playEffect("chess.wav")
    local posX = (row - 1) * CHESS_SETP + CHESS_OFFSETX
    local posY = (col - 1) * CHESS_SETP + CHESS_OFFSETY

    local chess = nil
    if isWhiteTurn then
        chess = display.newSprite("white.png")
        self._chessboardArray[row][col].type = WHITE
        self._chessboardArray[row][col].chess = chess
    else
        chess = display.newSprite("black.png")
        self._chessboardArray[row][col].type = BLACK
        self._chessboardArray[row][col].chess = chess
    end
    chess.row = row
    chess.col = col
    chess:setPosition(posX, posY)
    chess:addTo(self._chessboard)
    --给棋子添加序号
    if IS_SHOW_CHESSNUMBER then
        self._lable = cc.Label:createWithSystemFont(chessNumber, "", 22)
        self._lable:setTextColor(cc.RED)
        chess:addChild(self._lable)
        self._lable:setPosition(cc.p(chess:getContentSize().width / 2 , chess:getContentSize().height / 2))
        chessNumber = chessNumber + 1
    end

    --储存所下棋子 悔棋时用
    table.insert(self._chess, chess)

    --当前棋子提示
    if self._currentChessTip == nil then
        self._currentChessTip = display.newSprite("current_chess_tip.png")
        self._currentChessTip:addTo(self._chessboard, 1)
        if IS_SHOW_CHESSNUMBER then
            self._currentChessTip:setVisible(false)
        end
    end
    self._currentChessTip:setPosition(posX, posY)

    --检查是否连成五子
    local chessType = isWhiteTurn and WHITE or BLACK
    self:checkChessboard(row, col, chessType)

    --更新下棋方
    self:updataChessTurn()

    if callFunc then callFunc() end
    return
end

function ChessboardNode:updataChessTurn()
     if isWhiteTurn then
        isWhiteTurn = false
     else
        isWhiteTurn = true
     end
end

function ChessboardNode:getCurrentChessType()
    if isWhiteTurn then
        return BLACK
    else
        return WHITE
    end
end

function ChessboardNode:getNextTurnChessType()
    if isWhiteTurn then
        return WHITE
    else
        return BLACK
    end
end

--悔棋
function ChessboardNode:retractChess()
    if #self._chess == 0 then return end

    local chess = table.remove(self._chess)
    self._chessboardArray[chess.row][chess.col].type = NO_CHESS
    self._chessboardArray[chess.row][chess.col].chess = nil
    chess:removeSelf()
    if IS_SHOW_CHESSNUMBER then
        chessNumber = chessNumber - 1
    end

    self:updataChessTurn()
    if #self._chess == 0 then
         self._currentChessTip:removeSelf()
         self._currentChessTip = nil
         return
    end
    local currentChess = self._chess[#self._chess]
    self._currentChessTip:setPosition(currentChess:getPosition())
end

--检测是否连成五子 和 是否没有空位
function ChessboardNode:checkChessboard(row, col, chessType)
    --和棋判断（判断棋盘是否还有空位）
    local isNoEmptyPlace = true
    for i, chessTb in pairs(self._chessboardArray) do
        for j, chess in pairs(chessTb) do
            if chess.type == NO_CHESS then
                isNoEmptyPlace = false
                break
            end
        end
        if not isNoEmptyPlace then break end
    end
    if isNoEmptyPlace then
        self:gameOver()
        return
    end

    --五子判断
    local oneLineChessNum = 0
    local offset = {
                    {{x = -1, y = 1}, {x = 1,  y = -1}},
                    {{x = 0,  y = 1}, {x = 0,  y = -1}},
                    {{x = 1,  y = 1}, {x = -1, y = -1}},
                    {{x = 1,  y = 0}, {x = -1, y = 0}}}

    --计算一个方向上的棋子数目
    local function getOneLineChessNum(self, row, col, chessType, oneLineOtherChessNum, oneLineChessSpriteTb, offsetX, offsetY)
        if row < 1 or row > CHESS_GRID_NUM or col < 1 or col > CHESS_GRID_NUM or self._chessboardArray[row][col].type ~= chessType then
            return oneLineOtherChessNum, oneLineChessSpriteTb
        end

        oneLineOtherChessNum = oneLineOtherChessNum + 1
        table.insert(oneLineChessSpriteTb, self._chessboardArray[row][col].chess)
        return getOneLineChessNum(self, row + offsetX, col + offsetY, chessType, oneLineOtherChessNum, oneLineChessSpriteTb, offsetX, offsetY)
    end

    --遍历8个方向
    for i = 1, #offset do
        local chessNum = 1
        local chessSpriteTb = {self._chessboardArray[row][col].chess}
        for j = 1, 2 do
            local oneLineOtherChessNum, oneLineChessSpriteTb = getOneLineChessNum(self, row + offset[i][j].x, col + offset[i][j].y, chessType, 0, {}, offset[i][j].x, offset[i][j].y)
            chessNum = chessNum + oneLineOtherChessNum
            for _, chess in ipairs(oneLineChessSpriteTb) do
                table.insert(chessSpriteTb, chess)
            end
        end
        if chessNum >= 5 then
            self:gameOver(chessType, chessSpriteTb)
            return
        end
    end

end

function ChessboardNode:restartGame()
    self._chessboard:removeAllChildren()
    self:initChessboardArray()
end

function ChessboardNode:gameOver(chessType, chessSpriteTb)
    isGameOver = true
    --和棋
    if chessType == nil or chessSpriteTb == nil then
        Log.d("*************和棋***********")
        return
    end
    --赢了
    Log.d("******赢了*******" .. chessType .. "*****赢了******")
    Log.d("chessSpriteTb = " .. #chessSpriteTb)
    local blink = cc.Blink:create(1.5, 3)
    for _, chess in ipairs(chessSpriteTb) do
        chess:runAction(blink:clone())
    end
end

return ChessboardNode
