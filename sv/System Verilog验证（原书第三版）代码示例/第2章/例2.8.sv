initial begin
  static int ascend[4] = '{0, 1, 2, 3};  // 对 4 个元素进行初始化
  int descend[5];
  descend = '{4, 3, 2, 1, 0};  // 为 5 个元素赋值
  descend[0:2] = '{7, 6, 5};  // 为前 3 个元素赋值
  ascend = '{4{8}};  // 四个值全部为 8
  ascend = '{default: 42};  // 所有元素赋值为 42
end
