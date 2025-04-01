class bad_sum3;
  rand uint len[];  // 32 位
  constraint c_len {
    len.sum() < 1024;
    len.size() inside {[1 : 8]};
  }
endclass
