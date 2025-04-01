class Ranges;
  rand bit [31:0] c;  // 随机变量
  bit [31:0] lo, hi;  // 作为上限和下限的非随机变量
  constraint c_range {
    c inside {[lo : hi]};  //lo <= c 并且 c <= hi
  }
endclass
