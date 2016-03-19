----------------------------
--版权: 564773807@qq.com
--作用: 人机算法
--作者: liubo
--时间: 201603016
--备注:
----------------------------

local AI = {}

local computer = nil
local human = nil

local ORDER_FIRST = "first"
local ORDER_SECOND = "second"

local chessLineRecord = {
    left     = {}, --左斜
    right    = {},--右斜
    horizon  = {}, --水平
    vertical = {} --垂直
}   --用于存放水平、垂直、左斜、右斜 4 个方向上所有棋型分析结果

---------------------function-------------------------
--设置电脑执棋类型
function AI.setComputerChessType(chessType)
    if chessType == nil or chessType == BLACK then
        computer = BLACK
        human = WHITE
    else
        computer = WHITE
        human = BLACK
    end
end

--反转棋子类型
function AI.reverseChessType(chessType)
    return chessType == BLACK and WHITE or BLACK
end

--初始化记录棋子类型的数组
function AI.initChessLineRecord()
    chessLineRecord = {
       left     = {}, --左斜
       right    = {},--右斜
       horizon  = {}, --水平
       vertical = {} --垂直
    }   --用于存放水平、垂直、左斜、右斜 4 个方向上所有棋型分析结果

end

--------------------评估相关-------------------------
--评分表
function AI.initChessLineScoreTb(chessType)
    local selfChess  = chessType
    local enemyChess = AI.reverseChessType(chessType)
    local chessLinesSoreTb = {
        {lineType = {selfChess, selfChess, selfChess, selfChess, selfChess}                        , score = 50000}, -- ooooo
        {lineType = {NO_CHESS, selfChess, selfChess, selfChess, selfChess, NO_CHESS}               , score = 4320},  -- +oooo+
        {lineType = {NO_CHESS, selfChess, selfChess, selfChess, NO_CHESS, NO_CHESS}                , score = 720},   -- +ooo++
        {lineType = {NO_CHESS, NO_CHESS, selfChess, selfChess, selfChess, NO_CHESS}                , score = 720},   -- ++ooo+
        {lineType = {NO_CHESS, selfChess, selfChess, NO_CHESS, selfChess, NO_CHESS}                , score = 720},   -- +oo+o+
        {lineType = {NO_CHESS, selfChess, NO_CHESS, selfChess, selfChess, NO_CHESS}                , score = 720},   -- +o+oo+
        {lineType = {enemyChess, selfChess, selfChess, selfChess, selfChess, NO_CHESS}             , score = 720},   -- oooo+
        {lineType = {NO_CHESS, selfChess, selfChess, selfChess, selfChess, enemyChess}             , score = 720},   -- +oooo
        {lineType = {enemyChess, selfChess, selfChess, NO_CHESS, selfChess, selfChess, enemyChess} , score = 720},   -- oo+oo
        {lineType = {enemyChess, selfChess, NO_CHESS, selfChess, selfChess, selfChess, enemyChess} , score = 720},   -- o+ooo
        {lineType = {enemyChess, selfChess, selfChess, selfChess, NO_CHESS, selfChess, enemyChess} , score = 720},   -- ooo+o
        {lineType = {NO_CHESS, NO_CHESS, selfChess, selfChess, NO_CHESS, NO_CHESS}                 , score = 120},   -- ++oo++
        {lineType = {NO_CHESS, NO_CHESS, selfChess, NO_CHESS, selfChess, NO_CHESS}                 , score = 120},   -- ++o+o+
        {lineType = {NO_CHESS, selfChess, NO_CHESS, selfChess, NO_CHESS, NO_CHESS}                 , score = 120},   -- +o+o++
        {lineType = {NO_CHESS, NO_CHESS, NO_CHESS, selfChess, NO_CHESS, NO_CHESS}                  , score = 20},    -- +++o++
        {lineType = {NO_CHESS, NO_CHESS, selfChess, NO_CHESS, NO_CHESS, NO_CHESS}                  , score = 220},   -- ++o+++
    }
end

--分析某一条线上的棋子  order 为前半截 和 后半截
function AI.analysisLine(chessBoardArray, chessType, row, col, offsetX, offsetY, direction, order)
    Log.d("row " .. row .. " col " .. col)
    --到达边界 或者 对方棋子 保存对方棋子  返回
    if row < 1 or row > CHESS_GRID_NUM or col < 1 or col > CHESS_GRID_NUM or chessBoardArray[row][col].type == AI.reverseChessType(chessType) then
        table.insert(chessLineRecord[direction], AI.reverseChessType(chessType))
        return
    end
    --如果连续两个空 保存空 返回
    if chessBoardArray[row][col].type == NO_CHESS and chessBoardArray[row - offsetX][col - offsetY].type == NO_CHESS then
       table.insert(chessLineRecord[direction], NO_CHESS)
       return
    end

    --分上半截和下半截分析  row 和 col 所在的位置为分界点  为了存储顺序 如++++o++++
    --second 为下半截 按搜索顺序存储
    --first  为上半截 倒序存储
    if order == ORDER_SECOND then
        Log.d("table insert  second")
       table.insert(chessLineRecord[direction], chessBoardArray[row][col].type)
    end
    AI.analysisLine(chessBoardArray, chessType, row + offsetX, col + offsetY, offsetX, offsetY, direction, order)
    if order == ORDER_FIRST then
        Log.d("table insert first")
       table.insert(chessLineRecord[direction], chessBoardArray[row][col].type)
    end
end


--评估某一点的分数
function AI.evalatePoint(chessBoardArray, row, col, chessType)
    AI.initChessLineRecord()
    local totalSorce = 0
    local offset = {
                    left     = {{x = -1, y = 1}, {x = 1,  y = -1}},--左斜
                    vertical = {{x = 0,  y = 1}, {x = 0,  y = -1}},--竖直
                    right    = {{x = 1,  y = 1}, {x = -1, y = -1}},--右斜
                    horizon  = {{x = -1, y = 0}, {x = 1, y = 0}}}--水平
    --分析该点的4个方向上的棋子 并保存在chessLineRecord 数组中 遇到连续两个空格或者他方棋子返回
    -- dump(chessBoardArray, "chessBoardArray")
    chessBoardArray[row][col].type = chessType --在该空位上下子
    for direction, v in pairs(offset) do
        Log.d(direction)
        AI.analysisLine(chessBoardArray, chessType, row, col, v[1].x, v[1].y, direction, ORDER_FIRST)
        AI.analysisLine(chessBoardArray, chessType, row + v[2].x, col + v[2].y, v[2].x, v[2].y, direction, ORDER_SECOND)
    end


    -- dump(chessLineRecord, "chessLineRecord")
    for k,v in pairs(chessLineRecord) do
        print(table.concat(v))
        print(type(table.concat( v )))
    end

end

return AI;
