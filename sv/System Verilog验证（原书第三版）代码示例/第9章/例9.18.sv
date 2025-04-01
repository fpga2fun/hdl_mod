covergroup CovKind18;
  coverpoint p.kind {
    bins zero = {0};  //1 个仓代表 kind == 0
    bins lo = {[1 : 3], 5};  //1 个仓代表 1:3 和 5 的值
    bins hi[] = {[8 : $]};  //8 个独立的仓：8...15
    bins misc = default;  //1 个仓代表剩余的所有值
  }  // 没有分号
endgroup
