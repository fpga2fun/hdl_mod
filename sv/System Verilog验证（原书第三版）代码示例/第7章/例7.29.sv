class Generator;
  static int thread_count = 0;

  task run();
    thread_count++;  // 启动另一个线程
    fork
      begin
        // 这里省略实际工作的代码
        // 当工作完成时，对线程数目减计数
        thread_count--;
      end
    join_none
  endtask
endclass

Generator gen[N_GENERATORS];

initial begin
  // 创建 N 个发生器
  foreach (gen[i]) gen[i] = new();

  // 发生器开始运行
  foreach (gen[i]) gen[i].run();

  // 等待所有发生器结束
  wait (Generator::thread_count == 0);
end
