class Sample;
  rand bit a, b;
endclass

Sample sam;

covergroup CrossBinNames;
  a: coverpoint sam.a {
    bins a0 = {0}; bins a1 = {1}; option.weight = 0;
  }  // 不用计算该点的覆盖率
  b: coverpoint sam.b {
    bins b0 = {0}; bins b1 = {1}; option.weight = 0;
  }  // 不用计算该点的覆盖率
  ab: cross a, b{
    bins a0b0 = binsof (a.a0) && binsof (b.b0);
    bins a1b0 = binsof (a.a1) && binsof (b.b0);
    bins b1 = binsof (b.b1);
  }
endgroup
