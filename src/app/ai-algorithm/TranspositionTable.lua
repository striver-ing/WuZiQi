----------------------------
--版权:
--作者: liubo (564773807@qq.com)
--时间: 2016-04-16 17:16:23
--作用: 置换表
--备注:
----------------------------

local TranspositionTable = {}

local USE_HASH_TABLE = true

local hashTb = {} --储存棋盘的hash表
hashTb[1] = {}
hashTb[2] = {}

-- --hash表里面的每一项属性
-- local hashItem = {
--     checkSum = "",
--     depth = "",
--     score = "",
--     entryType = ""
-- }

local hashChessboardTb32 = {}  --存储棋盘每个位置的hash值 用于生成hash key
local hashChessboardTb64 = {}  -- 用户checkSum 的校验
local hashKey32 = 0
local hashKey64 = 0

-----------------------------------------------------------------------
local function random32()
    return math.random(1, 2^32)
end

local function random64()  -- 貌似Number 只有53位 2^53  待测试
    return math.random(1, 2^64)
end

--遍历棋盘 把每个位置生成一个随机的hash值
function TranspositionTable.initializeHashKey()
    if not USE_HASH_TABLE then return end

    math.randomseed(tostring(os.time()):reverse():sub(1, 6))  --设置随机种子

    for i = 1, CHESS_GRID_NUM do
        hashChessboardTb32[i] = {}
        hashChessboardTb64[i] = {}
        for j = 1, CHESS_GRID_NUM do
            hashChessboardTb32[i][j] = {}
            hashChessboardTb64[i][j] = {}
            hashChessboardTb32[i][j][WHITE] = random32()
            hashChessboardTb32[i][j][BLACK] = random32()
            hashChessboardTb64[i][j][WHITE] = random64()
            hashChessboardTb64[i][j][BLACK] = random64()
        end
    end
end

--计算初始棋盘的hash值
function TranspositionTable.calculateInitHashKey(chessboardArray)
    if not USE_HASH_TABLE then return end

    hashKey32, hashKey64 = 0, 0

    for i = 1, CHESS_GRID_NUM do
        for j = 1, CHESS_GRID_NUM do
            local chessType = chessboardArray[i][j].type
            if chessType ~= NO_CHESS then
                hashKey32 = hashKey32 + hashChessboardTb32[i][j][chessType]
                hashKey64 = hashKey64 + hashChessboardTb64[i][j][chessType]
            end
        end
    end
end

--下子
function TranspositionTable.hashMakeMove(chessType, point)
    if not USE_HASH_TABLE then return end

    hashKey32 = hashKey32 + hashChessboardTb32[point.row][point.col][chessType]
    hashKey64 = hashKey64 + hashChessboardTb64[point.row][point.col][chessType]
end

--撤销下子
function TranspositionTable.hashUnmakeMove(chessType, point)
    if not USE_HASH_TABLE then return end

    hashKey32 = hashKey32 - hashChessboardTb32[point.row][point.col][chessType]
    hashKey64 = hashKey64 - hashChessboardTb64[point.row][point.col][chessType]
end

--将局面存入hash表
--[[entryType: 分数的类型 精确 还是做好最坏tableNo  :奇数层还是偶数层
--]]
function TranspositionTable.enterHashTable(entryType, score, depth, tableNo)
    if not USE_HASH_TABLE then return end
    local hashItem = {}

    hashItem.checkSum = hashKey64
    hashItem.depth = depth
    hashItem.score = score
    hashItem.entryType = entryType

    --存进hash 表
    local tempHashKey32 = hashKey32 % HASH_TABLE_SIZE + 1  --lua 数组从1开始
    hashTb[tableNo][tempHashKey32] = hashItem
end

function TranspositionTable.dumpHashTb()
    table.print(hashTb)
end

--查询hash表
function TranspositionTable.lookUpHashTable(alpha, beta, depth, tableNo)
    if not USE_HASH_TABLE then return INFINITY end
    local tempHashKey32 = hashKey32 % HASH_TABLE_SIZE + 1  --lua 数组从1开始
    if hashTb[tableNo][tempHashKey32] == nil then return INFINITY end
    local hashItem = {}

    hashItem = hashTb[tableNo][tempHashKey32]

    -- dump(hashTb[tableNo][tempHashKey32], "hashTb[" .. tableNo .. "][" .. tempHashKey32 .."]")

    if hashItem.checkSum == hashKey64 then
        Log.d("哈西表中有此局面")
    end

    if hashItem.depth >= depth and hashItem.checkSum == hashKey64 then
        Log.d("命中")
        if hashItem.entryType == ENTRY_TYPE.exact then
            Log.d("精确值 = " .. hashItem.score)
            return hashItem.score
        elseif hashItem.entryType == ENTRY_TYPE.lowerBound then
            if hashItem.score >= beta then
                Log.d("最差值 = " .. hashItem.score)
                return hashItem.score
            end
        elseif hashItem.entryType == ENTRY_TYPE.upperBound then
            if hashItem.score <= alpha then
                Log.d("最好值 = " .. hashItem.score)
                return hashItem.score
            end
        end
    end
    return INFINITY
end

return TranspositionTable