class Bidir;
  rand bit [15:0] r, s, t;
  constraint c_bidir {  // 所有值都是并行求解的
    r < t;  //r 的值影响 s 和 t
    s == r;
    t < 10;
    s > 5;
  }
endclass
