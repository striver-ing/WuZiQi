----------------------------
--版权: 564773807@qq.com
--作用: 全局变量
--作者: liubo
--时间: 20160129
--备注:
----------------------------

--帧数
FPS = 60

--棋盘
-- 左下角坐标
CHESS_OFFSETX = 25
CHESS_OFFSETY = 51
--棋盘格子的宽度
CHESS_SETP    = 48
CHESS_GRID_NUM = 15
--棋子类型
NO_CHESS     = -1
WHITE = 0
BLACK = 1

--无穷大
INFINITY = 0Xffffff

--置换表的大小
HASH_TABLE_SIZE = 1024 * 1024
--描述棋盘估分的含义  准确值 最坏值 最好值
ENTRY_TYPE = {exact = 0, lowerBound = 1, upperBound = 2}

-- --棋型分数  从高位到低位分别表示
-- --连五，活四，眠四，活三，活二/眠三，活一/眠二, 眠一
-- SCORE = {
--   --活
--   ONE = 10,
--   TWO = 100,
--   THREE = 1000,
--   FOUR =100000,
--   FIVE = 1000000,

--   --眠
--   SONE = 1,
--   STWO = 10,
--   STHREE = 100,
--   SFOUR = 10000
-- }

--音效
SAVA_STRING_SOUND_EFFECT_ENABLE = "usersoundeffectenable"
SAVA_STRING_SOUND_MUSIC_ENABLE = "usersoundmusicenable"