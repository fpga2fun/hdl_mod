event trans_ready;
covergroup CovDst9 @(trans_ready);
  coverpoint ifc.cb.dst;  // 测量覆盖率
endgroup
