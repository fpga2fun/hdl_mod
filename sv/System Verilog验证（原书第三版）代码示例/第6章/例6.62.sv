class UniqueSlow;  // 不好的代码，不要使用
  rand bit [7:0] ua[64];
  constraint c {
    foreach (ua[i])  // 对数组的每个元素操作
    foreach (ua[j])
    if (i != j)  // 除了元素自己
    ua[i] != ua[j];  // 和其他元素比较
  }
endclass
