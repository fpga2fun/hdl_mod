covergroup CovDstKind32;
  dst: coverpoint tr.dst {bins dst[] = {[0 : $]};}
  kind: coverpoint tr.kind {
    bins zero = {0};  // 1 个仓代表 kind == 0
    bins lo = {[1 : 3]};  // 1 个仓代表 1:3 的值
    bins hi[] = {[8 : $]};  // 8 个独立的仓
    bins misc = default;  // 1 个仓代表剩余的所有值
  }
  cross kind, dst;
endgroup
