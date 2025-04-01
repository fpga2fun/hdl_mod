task generator();
  Transaction tarray[10];
  foreach (tarray[i]) begin
    tarray[i] = new();  // 创建每一个对象
    transmit(tarray[i]);
  end
endtask
