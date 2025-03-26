event done[N_GENERATORS];
int done_count;

initial begin
  foreach (gen[i]) begin
    gen[i] = new(done[i]);  // 创建 N 个发生器
    gen[i].run();  // 发生器开始运行
  end

  // 等待所有发生器完成
  foreach (gen[i])
  fork
    automatic int k = i;
    begin
      wait (done[k].triggered);
      done_count++;
    end
  join_none
  wait (done_count == N_GENERATORS);  // 等待触发
end
