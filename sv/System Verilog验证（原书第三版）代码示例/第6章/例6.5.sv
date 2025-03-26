class Order_bad;
  rand bit [7:0] lo, med, hi;
  constraint bad {lo < med < hi;}  // 错误 !
endclass
