covergroup CovDst35;
  kind: coverpoint tr.kind {
    bins zero = {0};
    bins lo = {[1 : 3]};
    bins hi[] = {[8 : $]};
    type_option.weight = 5;  // 在总体中所占的分量
  }
  dst: coverpoint tr.dst {
    bins dst[] = {[0 : $]}; type_option.weight = 0;  // 在总体中不占任何分量
  }
  cross kind, dst{type_option.weight = 10;}  // 给予交叉更高的权重
endgroup
