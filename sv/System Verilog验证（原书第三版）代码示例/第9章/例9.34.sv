covergroup CovDst34;
  dst: coverpoint tr.dst {bins dst[] = {[0 : $]};}
  kind: coverpoint tr.kind {
    bins zero = {0};  // 1 个仓代表 kind == 0
    bins lo = {[1 : 3]};  // 1 个仓代表 1:3 的值
    bins hi[] = {[8 : $]};  // 8 个独立的仓
    bins misc = default;  // 1 个仓代表剩余的所有值
  }
  cross kind, dst{
    ignore_bins hi = binsof (dst) intersect {7};
    ignore_bins md = binsof (dst) intersect {0} && binsof (kind) intersect {[9 : 11]};
    ignore_bins lo = binsof (kind.lo);
  }
endgroup
