// 元素是动态数组的动态数组
int d[][];
initial begin
  // 构造第一个或最左面的维度
  d = new[4];
  // 构造第二个维度，每个数组的宽度都不相同
  foreach (d[i]) d[i] = new[i + 1];
  // 初始化元素 d[4][2] = 42;
  foreach (d[i, j]) d[i][j] = i * 10 + j;
end
