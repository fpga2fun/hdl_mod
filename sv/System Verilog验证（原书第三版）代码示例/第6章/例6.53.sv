class bad_sum2;
  rand bit [7:0] len[];  // 8 位无符号类型，不是字节类型
  constraint c_len {
    len.sum() < 1024;
    len.size() inside {[1 : 8]};
  }
endclass
