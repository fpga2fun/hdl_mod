class StrobePat;
  rand bit strobe[10];
  constraint c_set_four {strobe.sum() == 4'h4;}
endclass

initial begin
  StrobePat sp;
  int count = 0;  // 数据数组的索引

  sp = new();
  `SV_RAND_CHECK(sp.randomize());

  foreach (sp.strobe[i]) begin
    ##1 bus.cb.strobe <= sp.strobe[i];
    // 如果 strobe 信号有效，输出下一个数据
    if (sp.strobe[i]) bus.cb.data <= data[count++];
  end
end
