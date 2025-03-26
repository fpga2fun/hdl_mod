class bad_sum4;
  rand bit [9:0] len[];  // 10 位，无符号
  constraint c_len {
    len.sum() < 1024;
    len.size() inside {[1 : 8]};
  }
endclass
