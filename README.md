# 五子棋

### 一、棋盘封装

**棋盘数据结构**  

``` 
struct ChessBoard{
	int type;
	Sprite * chess;
}
ChessBoard[15][15] chessBoard;
````

**所下棋子数据结构**
	

	Vector<Chess> chesses;

`已知`

棋盘左下角格子的起始坐标、格子宽度、总格子数  

**method：**  

* 下子
* 悔棋  
* 重玩  
* 检测是否连成五子

***下子***

1. 为棋盘注册Touch监听事件，并提供事件回调
2. 触摸屏幕时将屏幕坐标转换为棋盘坐标 
3. 将棋盘坐标转换为格子坐标
4. 判断是否超出边界 或 此位置是否下过子
5. 将格子坐标转化为棋盘坐标
6. 在此位置添加棋子，并标记该格子下子类型
7. 将该棋子储存到表中，悔棋时用
8. 更新下子方
9. 检测是否连成五子

***悔棋***

1. 检测棋子表是否为空， 空则返回
2. 从表末位抛出棋子，并把该子在棋盘上删除
3. 更新下子方 （因为下子后更新了一回，轮到对方下子，所以此处更新下，则己方下子）

***重玩***

1. 清空棋盘上的棋子（removeAllChildren）
2. 清空棋盘数组
3. 清空棋子数组

***检测是否连成五子***

1. 所需参数为 格子的行、列以及棋子类型
2. 求该位置的左斜，右斜，水平，竖直四个方向同类棋子的个数( 分上半部分，和下半部分分别计算，然后加上当前棋子 )，超出棋盘边界或者当前格子处的棋子类型不等于所传参数的棋子类型时，返回。
3. 如果棋子个数大于等于5， 则连成五子

---
### 二、游戏基类分装

1. 添加棋盘
2. 提供重玩，悔棋，离开等按钮
3. 提供子程序入口 `onCreate`


### 三、双人对弈


1. 注册触摸事件的回调函数、点击下子

### 四、人机对弈

***封装AI***

* 评估某一点的分数
* .....

**思路  **  
1.评估某一点分数

* 分析改点`左斜，右斜、水平、竖直`四个方向棋子类型，并将其存到表中。
	
 ```
 local chessLineRecord = {
    left     = {}, --左斜
    right    = {},--右斜
    horizon  = {}, --水平
    vertical = {} --垂直
}   --用于存放水平、垂直、左斜、右斜 4 个方向上所有棋型分析结果
 ```
 
 * 填写评分表 
 
 ```
 table:
 {
 	{lineType = {}, score = },
 }
 
 评分规则为：
  1."ooooo"     5000                 2."+0000+"     4320
  3."+ooo++"    720                  4."++ooo+"     720
  5."+oo+o+"    720                  6."+o+oo+"     720
  7."oooo+"     720                  8."+oooo"      720
  9."oo+oo"     720                 10."o+ooo"      720
 11."ooo+o"     720                 12."++oo++"     120
 13."++o+o+"    120                 14."+o+o++"     120
 15."+++o++"    20                  16."++o+++"     20
 ```

* 遍历棋子列表（chessLineRecord），查找列表中是否有对应的棋型，如果有则加上所对应棋型的分数。
* 遍历结束，返回总分，即为该点的分数  
  
**挑选可下子空位**

>如果改空位附近n格内有棋子，则把该空位看作可下子空位（即规定在一定的矩形区域内下子）

**简易算法（眼前利益）**

>观察局势，如果以计算机角度下子的利益大于等于以人角度下子的利益，则以计算机身份下子，否则下在人最有可能下子的位置

**极大极小算法**

>*极大极小算法*，估值函数返回的是当前棋盘 maxComputerSource － maxHumanScore 的分数， 电脑选择极大值， 人选择极小值

```
1.极大极小值算法：
int MinMax(局面 p, int depth)//depth是搜索深度
{
  int bestvalue, value;
  if(isGameOver || depth<=0)//叶子节点
  {
    返回估值(p);//直接返回对局面的估值
  }
  if(当前是计算机走棋){
    bestvalue=-INF;//初始最佳值设为负无穷
  }
  else {
    bestvalue=INF;// 初始最佳值设为正无穷
  }
  
  for(每一个合法的走法)//走法的生成与具体问题紧密相关，具体方法省略
  {
    走一步棋;//局面p随之改变
    value=MinMax(p, depth-1);//搜索子节点
    撤销刚才的一步;//恢复局面p
    if(当前是计算机走棋){
      bestvalue = max(value, bestvalue);//取最大值
    }
    else {
      bestvalue = min(value, bestvalue);//取最大值
    }
  }
  return bestvalue;
}
```
**负极大值算法：**

>*评估函数*： 如果是电脑方返回maxComputerSource － maxHumanScore 的分数，那么它的父节点必然是对手，对手希望取maxHumanScore － maxComputerScore 的最大值，也就是 －max（maxComputerSource － maxHumanScore）
相反如果是人方，估值函数返回 maxHumanScore - maxComputerScore的分数，那么它的父节点是电脑，电脑希望取的maxComputerScore － maxHumanScore 的最大值，也就是 －max（maxHumanScore － maxComputerScore）。所以负号就是这个意思

```
负极大中的估值却是对走棋方敏感的，因此函数参数中需要有一个走棋方的参数
long NegaMax(局面 p, ing Side, int depth)//depth是搜索深度
{
  int bestvalue, value;
 
  if(isGameOver || depth<=0)//叶子节点
  {
    返回估值(p, Side);//直接返回对局面的估值
  }
  bestvalue=-INF;//初始最佳值设为负无穷
  for(每一个合法的走法)//走法的生成与具体问题紧密相关，具体方法省略
  {
    走一步棋;//局面p随之改变
    value= - NegaMax(p, opSide, depth-1);//搜索子节点，注意前面的负号，opSide是对手
    撤销刚才的一步;//恢复局面p
    if(value>bestvalue)//取最大值
    {
      bestvalue=value;
    }
   }
  return bestvalue;
}
```


**alpha-beta 剪枝**
>*思想*：

*伪代码*

```
极大极小AlpahBeta算法

```


```
负极大值AlpahBeta算法

```