byte assoc[byte], idx = 1;
initial begin
  // 对稀疏分布的元素进行初始化
  do begin
    assoc[idx] = idx;
    idx = idx << 1;
  end while (idx != 0);

  // 使用 foreach 遍历数组
  foreach (assoc[i]) $display("assoc[%h] = %h", i, assoc[i]);

  // 使用函数遍历数组
  if (assoc.first(idx))  // 得到第一个索引
    do
    $display("assoc[%h] = %h", idx, assoc[idx]);
    while (assoc.next(
        idx
    ));  // 得到下一个索引

  // 找到并删除第一个元素
  void'(assoc.first(idx));
  void'(assoc.delete(idx));
  $display("The array now has %0d elements", assoc.num());
end
