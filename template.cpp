//极大极小值伪代码
int MinMax(局面 p, int depth) { // depth是搜索深度
  int bestvalue, value;
  if (isGameOver || depth <= 0) { //叶子节点
    返回估值(p);                  //直接返回对局面的估值
  }
  if (当前是计算机走棋) {
    bestvalue = -INF; //初始最佳值设为负无穷
  } else {
    bestvalue = INF; // 初始最佳值设为正无穷
  }
  for (each possible move m) {
    makeMove(m);                  //局面p随之改变
    value = MinMax(p, depth - 1); //搜索子节点
    unmakeMove(m);                //恢复局面p
    if (当前是计算机走棋) {
      bestvalue = max(value, bestvalue); //取最大值
    } else {
      bestvalue = min(value, bestvalue); //取最大值
    }
  }
  return bestvalue;
}

//----------------------------------------

//负极大值算法伪代码
long NegaMax(局面 p, int Side, int depth) { // depth是搜索深度
  int bestvalue, value;
  if (isGameOver || depth <= 0) { //叶子节点
    返回估值(p, Side);            //直接返回对局面的估值
  }
  bestvalue = -INF; //初始最佳值设为负无穷
  for (each possible move m) {
    makeMove(m);
    value = -NegaMax(p, opSide, depth - 1);
    unMakeMove(m);
    if (value > bestvalue) { //取最大值
      bestvalue = value;
    }
  }
  return bestvalue;
}

//----------------------------------------

//极大极小 alpha-beta
int maxMixAlpahBeta(int dept, int alpha, int beta) {
  if (gameOver)
    return evaluation; //胜负已分，返回估值
  if (dept <= 0)
    return evaluation;           //叶子节点，返回估值
  if (is min node) {             //极小节点
    for (each possible move m) { //对每一可能的走法m
      make move m;
      score = maxMixAlpahBeta(dept – 1, alpha, beta);
      unmake move m;
      if (score < beta) {
        beta = score;
        if (alpha > beta)
          return alpha; // alpha 剪枝
      }
    }
    return beta;                 //返回极小值
  } else {                       //取极大节点
    for (each possible move m) { //对每一可能的走法m
      make move m;
      score = maxMixAlpahBeta(dept – 1, alpha, beta);
      unmake move m;
      if (score > alpha) {
        alpha = score;
        if (alpha > beta)
          return beta; // beta 剪枝
      }
    }
    return alpha; //返回极大值
  }
}

//----------------------------------------

//负极大值 alpha-beta
int negativeAlphabeta(int dept, int alpha, int beta) {
  if (gameOver)
    return evaluation; //胜负已分，返回估值
  if (dept <= 0)
    return evaluation;         //叶子节点，返回估值
  for (each possible move m) { //对每一可能的走法m
    make move m;
    score = -negativeAlphabeta(dept – 1, -beta, -alpha);
    unmake move m;
    if (score >= alpha) {
      alpha = score;
      if (alpha >= beta)
        return beta; // beta 剪枝
    }
  }
  return alpha; //返回极小值
}

//----------------------------------------

//置换表结构
struct hashItem {
  int64 checksum; //校验当前项是否符合所查找的节点
  int depth;      //该表项求值时的搜索深度
  enum { exact, lower_bound, upper_bound } entry_type; //准确值、最差值、最好值
  double eval;                                         //代表该节点的值
} hashTable[HASH_TABLE_SIZE]
