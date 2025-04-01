covergroup CovDst28;
  coverpoint tr.dst {
    option.auto_bin_max = 4;  //0:1, 2:3, 4:5, 6:7
    ignore_bins hi = {6, 7};  // 忽略最后两个值
  }
endgroup
