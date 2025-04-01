class good_sum5;
  rand uint len[];
  constraint c_len {
    foreach (len[i]) len[i] inside {[1 : 255]};
    len.sum < 1024;
    len.size() inside {[1 : 8]};
  }
endclass
