bit one[6];  // 元素是单个比特的数组
int total;

initial begin
  foreach (one[i]) one[i] = i;  //one[i] 是 0 或 1

  // 计算单个比特的和
  total = one.sum();  //total = 1 = (0+1+0+1+0+1) & 1

  // 计算 32 位有符号数
  total = one.sum() with (int'(item));  //total = 3
end
