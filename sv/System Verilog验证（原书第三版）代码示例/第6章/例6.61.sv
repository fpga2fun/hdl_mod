class Ascend;
  rand uint d[10];
  constraint c {
    foreach (d[i])  // 对数组的每个元素操作
    if (i > 0)  // 除了第一个元素
    d[i] > d[i-1];  // 和前一个元素比较
  }
endclass
