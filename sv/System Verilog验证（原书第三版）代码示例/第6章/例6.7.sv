class Order_good;
  rand bit [7:0] lo, med, hi;
  constraint good {
    lo < med;  // 只能使用二进制约束
    med < hi;
  }
endclass
