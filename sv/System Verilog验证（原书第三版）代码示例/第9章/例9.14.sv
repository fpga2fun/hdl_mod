covergroup CovDst14;
  option.auto_bin_max = 2;  // 影响 dst 和 data
  coverpoint tr.dst;  //autobin[0:3], autobin[4:7]
  coverpoint tr.data;  //autobin[0:7], autobin[8:15]
endgroup
