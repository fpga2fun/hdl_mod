covergroup CrossBinsofIntersect;
  a: coverpoint sam.a {option.weight = 0;}  // 不用计算该点的覆盖率
  b: coverpoint sam.b {option.weight = 0;}  // 不用计算该点的覆盖率
  ab: cross a, b{
    bins a0b0 = binsof (a) intersect {0} && binsof (b) intersect {0};
    bins a1b0 = binsof (a) intersect {1} && binsof (b) intersect {0};
    bins b1 = binsof (b) intersect {1};
  }
endgroup
