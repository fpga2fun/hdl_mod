int i;
covergroup range_cover;
  coverpoint i {
    bins neg = {[$ : -1]};  // 负值
    bins zero = {0};  // 零
    bins pos = {[1 : $]};  // 正值
  }
endgroup
