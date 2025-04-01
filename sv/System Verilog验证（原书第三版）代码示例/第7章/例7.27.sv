event done[N_GENERATORS];
initial begin
  foreach (gen[i]) begin
    gen[i] = new(done[i]);  // 创建 N 个发生器
    gen[i].run();  // 发生器开始运行
  end

  // 通过等待每个事件来等待所有发生器完成
  foreach (gen[i])
  fork
    automatic int k = i;
    wait (done[k].triggered);
  join_none

  wait fork;  // 等待所有触发事件完成
end
