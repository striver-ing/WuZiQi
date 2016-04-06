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

local chessNum = 0
local ABcut  = 0

local chessLineRecord = {
    left     = {}, --左斜
    right    = {},--右斜
    horizon  = {}, --水平
    vertical = {} --垂直
}   --用于存放水平、垂直、左斜、右斜 4 个方向上所有棋型分析结果

---------------------function-------------------------
--设置电脑执棋类型
function AI.setComputerChessType(chessType)
    assert(chessType, "chessType can not nil")
    if computer == chessType then return end

    if chessType == BLACK then
        computer = BLACK
        human = WHITE
    else
        computer = WHITE
        human = BLACK
    end
end

--反转棋子类型
function AI.reverseChessType(chessType)
    assert(chessType, "chessType can not nil")
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
----------评估点分数-----------
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
        {lineType = {NO_CHESS, NO_CHESS, selfChess, NO_CHESS, NO_CHESS, NO_CHESS}                  , score = 20},    -- ++o+++
    }
    return chessLinesSoreTb
end

--分析某一条线上的棋子  order 为前半截 和 后半截
function AI.analysisLine(chessboardArray, chessType, row, col, offsetX, offsetY, direction, order)
    --到达边界 或者 对方棋子 保存对方棋子  返回
    if row < 1 or row > CHESS_GRID_NUM or col < 1 or col > CHESS_GRID_NUM or chessboardArray[row][col].type == AI.reverseChessType(chessType) then
        table.insert(chessLineRecord[direction], AI.reverseChessType(chessType))
        return
    end
    --如果连续两个空 保存空 返回
    if chessboardArray[row][col].type == NO_CHESS and chessboardArray[row - offsetX][col - offsetY].type == NO_CHESS and chessboardArray[row - offsetX * 2][col - offsetY * 2].type == NO_CHESS then
       table.insert(chessLineRecord[direction], NO_CHESS)
       return
    end

    --分上半截和下半截分析  row 和 col 所在的位置为分界点  为了存储顺序 如++++o++++
    --second 为下半截 按搜索顺序存储
    --first  为上半截 倒序存储
    if order == ORDER_SECOND then
       table.insert(chessLineRecord[direction], chessboardArray[row][col].type)
    end
    AI.analysisLine(chessboardArray, chessType, row + offsetX, col + offsetY, offsetX, offsetY, direction, order)
    if order == ORDER_FIRST then
       table.insert(chessLineRecord[direction], chessboardArray[row][col].type)
    end
end


--评估某一点的分数
function AI.evalatePoint(chessboardArray, row, col, chessType)
    AI.initChessLineRecord()
    local totalSorce = 0
    local offset = {
                    left     = {{x = -1, y = 1}, {x = 1,  y = -1}},--左斜
                    vertical = {{x = 0,  y = 1}, {x = 0,  y = -1}},--竖直
                    right    = {{x = 1,  y = 1}, {x = -1, y = -1}},--右斜
                    horizon  = {{x = -1, y = 0}, {x = 1, y = 0}}}--水平
    local chessIndex = {}  -- 用于记录改点在 chessLineRecord 表中的位置 eg +++o+++   则位置为4
    --分析该点的4个方向上的棋子 并保存在chessLineRecord 数组中 遇到连续两个空格或者他方棋子返回
    local currentChessType =  chessboardArray[row][col].type
    if currentChessType == NO_CHESS then
        chessboardArray[row][col].type = chessType --在该空位上下子
    end
    for direction, v in pairs(offset) do
        AI.analysisLine(chessboardArray, chessType, row, col, v[1].x, v[1].y, direction, ORDER_FIRST)
        chessIndex[direction] = #chessLineRecord[direction]
        AI.analysisLine(chessboardArray, chessType, row + v[2].x, col + v[2].y, v[2].x, v[2].y, direction, ORDER_SECOND)
    end
    chessboardArray[row][col].type = currentChessType --恢复该位置的棋子类型

    local chessLinesSoreTb = AI.initChessLineScoreTb(chessType)
    -- 分析该棋子与周围棋子连成的类型 计算得分
    for direction, chessLineTb in pairs(chessLineRecord) do
        -- Log.d("----------------- " .. direction .. " --------------------")
        --遍历评分表
        for _, chessesTb in pairs(chessLinesSoreTb) do
           local begin, ended = AI.findTable(chessLineTb, chessesTb.lineType)
           if  begin ~= nil and chessIndex[direction] >= begin and chessIndex[direction] <= ended then
                totalSorce = totalSorce + chessesTb.score
            end
        end

    end
    return totalSorce
end

--判断表A 是否包含表B 返回下标
function AI.findTable(mainTable, sonTable)
    local begin = 0
    local ended = 0

    for i, mainV in ipairs(mainTable) do
        if mainV == sonTable[1] then
            begin = i
            for j = 2, #sonTable do
                if #mainTable - j < #sonTable then
                    ended = 0
                end
                if sonTable[j] ~= mainTable[i + j - 1] then
                    ended = 0
                    break;
                else
                    ended =  i + j -1
                end
            end
            if ended ~= 0 then
                break;
            end
        end
    end
    if ended ~= 0 then
        return begin, ended
    else
        return nil
    end
end
----------评估点分数 finish-----------
-----------------------------------下子相关-----------------------------------
--判断该棋子周围是否有棋子（在一定的矩形框内下子）
function AI.isHasNeighbor(chessboardArray, row, col, distance, chessCount)
    local startX = row - distance > 1 and row - distance or 1
    local startY = col - distance > 1 and col - distance or 1
    local endedX = row + distance < CHESS_GRID_NUM and row + distance or CHESS_GRID_NUM
    local endedY = col + distance < CHESS_GRID_NUM and col + distance or CHESS_GRID_NUM

    for i = startX, endedX do
        for j = startY, endedY do
            if i == row and j == col then
                --do nothing
            else if chessboardArray[i][j].type ~= NO_CHESS then
                chessCount = chessCount - 1
                if chessCount <= 0 then return true end
            end
            end
        end
    end

    return false
end

--找出棋盘中分数最大的点(只看眼前一步) easy
function AI.getMaxSorcePoint(chessboardArray)
    local maxScore = -INFINITY
    local maxScorePoint = {}
    local i = 1

    for row = 1, CHESS_GRID_NUM do
        for col = 1, CHESS_GRID_NUM do
            if chessboardArray[row][col].type == NO_CHESS and AI.isHasNeighbor(chessboardArray, row, col, 2, 1) then
                local computerScore = AI.evalatePoint(chessboardArray, row, col, computer)
                local humanScore = AI.evalatePoint(chessboardArray, row, col, human)
                local score = computerScore >= humanScore and computerScore or humanScore
                if score >= maxScore then
                    if score > maxScore then
                        maxScorePoint = {}
                        i = 1
                    end
                    maxScore = score
                    maxScorePoint[i] = {}
                    maxScorePoint[i].row = row
                    maxScorePoint[i].col = col
                    i = i + 1
                end
            end
        end
    end

    return  #maxScorePoint == 0 and {row = 8, col = 8} or maxScorePoint[1]
    -- return  #maxScorePoint == 0 and {row = 8, col = 8} or maxScorePoint[math.random(1, #maxScorePoint)]
end

------------------下子算法相关------------------------

--找出可能的落子点（todo）
function AI.getPlayChessPosition(chessboardArray)
    local positionTb = {}
    local i = 1
    for row = 1, CHESS_GRID_NUM do
        for col = 1, CHESS_GRID_NUM do
            if chessboardArray[row][col].type == NO_CHESS and AI.isHasNeighbor(chessboardArray, row, col, 2, 1) then
                positionTb[i]     = {}
                positionTb[i].row = row
                positionTb[i].col = col
                i = i + 1
            end
        end
    end
    return positionTb
end

--检测棋局是否结束
function AI.isGameOver(chessboardArray, point)
   assert(point, "point is nil")
   --和局判断
   local isNoEmptyPlace = true
   for row = 1, CHESS_GRID_NUM do
        for col = 1, CHESS_GRID_NUM do
            if chessboardArray[row][col].type == NO_CHESS then isNoEmptyPlace = false end
        end
   end
   if isNoEmptyPlace then return true end

   -- 五子判断
   --遍历该棋子的四个方向 看同类棋子个数是否大于5
   --取一个方向上同类棋子的数目
   local function getOneOffsetChessNum(row, col, offsetX, offsetY, chessType)
         local chessNum = 0
         while true do
             if chessNum >= 5 or row < 1 or row > CHESS_GRID_NUM or col < 1 or col > CHESS_GRID_NUM  then return chessNum end
             if chessboardArray[row][col].type ~= chessType then
                  return chessNum
             else
                  chessNum = chessNum + 1
                  row = row + offsetX
                  col = col + offsetY
             end
         end
    end

    --遍历四个方向（轮上半截和下半截的话是8个方向） 求同类棋子数目
    local offset = {
                {{x = -1, y = 1}, {x = 1,  y = -1}},
                {{x = 0,  y = 1}, {x = 0,  y = -1}},
                {{x = 1,  y = 1}, {x = -1, y = -1}},
                {{x = 1,  y = 0}, {x = -1, y = 0}}
            }
    local row , col = point.row, point.col
    local chessType = chessboardArray[row][col].type
    for i = 1, #offset do
        local oneLineChessNum = 1
        for j = 1, 2 do
            oneLineChessNum = oneLineChessNum + getOneOffsetChessNum(row + offset[i][j].x, col + offset[i][j].y, offset[i][j].x, offset[i][j].y, chessType)
            if oneLineChessNum >= 5 then return true end
        end
    end

    return false
end

--评估当前棋盘得分
function  AI.getChessboardScore(chessboardArray, chessType)
    local maxHumanScore = -INFINITY
    local maxComputerScore = -INFINITY

    for row = 1, CHESS_GRID_NUM do
        for col = 1, CHESS_GRID_NUM do
            if chessboardArray[row][col].type ~= NO_CHESS then
                chessNum = chessNum + 1
                if chessboardArray[row][col].type == computer then
                    maxComputerScore =math.max(AI.evalatePoint(chessboardArray, row, col, computer), maxComputerScore)
                else
                    maxHumanScore =math.max(AI.evalatePoint(chessboardArray, row, col, human), maxHumanScore)
                end
            end
        end
    end

    if chessType ~= nil then  --负极大值用
        return  chessType == computer and maxComputerScore - maxHumanScore or maxHumanScore - maxComputerScore
    else --极大极小用
        return maxComputerScore - maxHumanScore
    end
end


--极大极小算法 找出depth步之内的最佳落子点 depth为搜索深度
function AI.maxMin(chessboardArray, point, chessType, depth)
    local bestValue, value

    if depth <= 0 or AI.isGameOver(chessboardArray, point) then
        return AI.getChessboardScore(chessboardArray)
    end

    if chessType == computer then
        bestValue = -INFINITY
    elseif chessType == human then
        bestValue = INFINITY
    end

    local playChessPositionTb = AI.getPlayChessPosition(chessboardArray)
    for _, p in ipairs(playChessPositionTb) do
        chessboardArray[p.row][p.col].type = chessType
        value = AI.maxMin(chessboardArray, p, AI.reverseChessType(chessType), depth - 1)
        chessboardArray[p.row][p.col].type = NO_CHESS

        if chessType == computer then
            bestValue = math.max(value, bestValue)
        elseif chessType == human then
            bestValue = math.min(value, bestValue)
        end
    end

    return bestValue
end


--alpha-beta（对极大极小的优化 剪枝）
function AI.maxMinAplhaBeta(chessboardArray, point, chessType, depth, alpha, beta)
    local value
     if depth <= 0 or AI.isGameOver(chessboardArray, point) then
        return AI.getChessboardScore(chessboardArray)
    end

    local playChessPositionTb = AI.getPlayChessPosition(chessboardArray)
    --取极大值节点
    if chessType == computer then
        for _, p in ipairs(playChessPositionTb) do
           chessboardArray[p.row][p.col].type = chessType
           value = AI.maxMinAplhaBeta(chessboardArray, p, AI.reverseChessType(chessType), depth - 1, alpha, beta)
           chessboardArray[p.row][p.col].type = NO_CHESS

           if value > alpha then
              alpha = value
              if alpha >= beta then
                  ABcut = ABcut + 1
                  return beta
              end
           end
        end
        return alpha
    --取极小值节点
    elseif chessType == human then
        for _, p in ipairs(playChessPositionTb) do
           chessboardArray[p.row][p.col].type = chessType
           value = AI.maxMinAplhaBeta(chessboardArray, p, AI.reverseChessType(chessType), depth - 1, alpha, beta)
           chessboardArray[p.row][p.col].type = NO_CHESS

           if value < beta then
              beta = value
              if alpha >= beta then
                  ABcut = ABcut + 1
                  return alpha
              end
           end
        end
        return beta
    end
end

--负极大值算法
function AI.negaMax(chessboardArray, point, chessType, depth)
    local value
    local bestValue = -INFINITY
    if depth <= 0 or AI.isGameOver(chessboardArray, point) then
        return AI.getChessboardScore(chessboardArray, chessType)
    end

    local nextPositionTb = AI.getPlayChessPosition(chessboardArray)
    for _, p in ipairs(nextPositionTb) do
        chessboardArray[p.row][p.col].type = chessType
        value = -AI.negaMax(chessboardArray, p, AI.reverseChessType(chessType), depth - 1)
        chessboardArray[p.row][p.col].type = NO_CHESS

        bestValue = math.max(value, bestValue)
    end

    return bestValue
end

--负极大值算法剪枝
function AI.negaMaxAlphaBeta(chessboardArray, point, chessType, depth, alpha, beta)
    local value
    if depth <= 0 or AI.isGameOver(chessboardArray, point) then
        return AI.getChessboardScore(chessboardArray, chessType)
    end

    local nextPositionTb = AI.getPlayChessPosition(chessboardArray)
    for _, p in ipairs(nextPositionTb) do
        chessboardArray[p.row][p.col].type = chessType
        value = -AI.negaMaxAlphaBeta(chessboardArray, p, AI.reverseChessType(chessType), depth - 1, -beta, -alpha)
        chessboardArray[p.row][p.col].type = NO_CHESS

        if value > alpha then
            alpha = value
        end

        -- if value >= beta then
        --     ABcut = ABcut + 1
        --     -- break  --beta 剪枝
        --     return beta
        -- end
        if alpha >= beta then
            ABcut = ABcut + 1
            break  --beta 剪枝
        end

    end

    return alpha
end

-------------下子相关算法 end--------------


--找出下一个落子点 返回point｛row = "", col = ""｝
function AI.getNextPlayChessPosition(chessboardArray, depth)
    local beginTime = os.clock()
    chessNum = 1
    local playChessPositionTb = AI.getPlayChessPosition(chessboardArray)
    local maxScore = -INFINITY
    local nextPosition = {}
    local value = 0

    for _, p in ipairs(playChessPositionTb) do
        chessboardArray[p.row][p.col].type = computer
        -- value = AI.maxMin(chessboardArray, p, human, depth - 1)
        value = AI.maxMinAplhaBeta(chessboardArray, p, human, depth - 1, -INFINITY, INFINITY)
        -- value = -AI.negaMax(chessboardArray, p, human, depth - 1)
        -- value = -AI.negaMaxAlphaBeta(chessboardArray, p, human, depth - 1, -INFINITY, INFINITY)
        chessboardArray[p.row][p.col].type = NO_CHESS

        if value >= maxScore then
            if value > maxScore then nextPosition = {} end
            maxScore = value
            table.insert(nextPosition, p)
        end
    end

    local endedTime = os.clock()
    Log.d("-----------------------------")
    Log.d("剪枝数 ＝ " .. ABcut)
    Log.d("遍历的节点数 = " .. chessNum)
    Log.d("maxScore = " .. maxScore)
    Log.d("用时 ＝ " .. endedTime - beginTime .. " seconds ")
    dump(nextPosition, "nextPosition")

    return #nextPosition == 0 and {row = 8, col = 8} or nextPosition[1]  --多个同等价值的候选点 随机返回一个
    -- return #nextPosition == 0 and {row = 8, col = 8} or nextPosition[math.random(1, #nextPosition)]  --多个同等价值的候选点 随机返回一个
end
--------------------------下子相关end---------------------------------------------


return AI;