covergroup CovDst21;
  // 当 rst == 1 时不收集覆盖率数据
  coverpoint tr.dst iff (!bus_if.rst);
endgroup
