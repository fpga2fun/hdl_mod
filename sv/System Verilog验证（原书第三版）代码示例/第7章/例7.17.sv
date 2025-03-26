initial begin
  check_trans(tr0);  // 线程 0
  // 创建一个线程来限制 disable fork 的作用范围
  fork  // 线程 1
    begin
      check_trans(tr1);  // 线程 2
      fork  // 线程 3
        check_trans(tr2);  // 线程 4
      join

      // 停止线程 2 ～ 4，单独保留线程 0
      #(TIME_OUT / 10) disable fork;
    end
  join
end
