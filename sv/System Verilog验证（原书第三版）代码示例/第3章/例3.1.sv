initial begin : example
  integer array[10], sum, j;

  // 在 for 语句中声明 i
  for (int i = 0; i < 10; i++)  // i 递增
  array[i] = i;

  // 把数组里的元素相加
  sum = array[9];
  j   = 8;
  do  // do...while 循环
  sum += array[j];  // 复合赋值
  while (
  j--
  );  // 判断 j=0 是否成立
  $display("Sum=%4d", sum);  // %4d指定宽度
end : example  // 结束标识符
