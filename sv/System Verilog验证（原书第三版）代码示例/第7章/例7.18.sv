initial begin
  check_trans(tr0);  // 线程 0
  fork  // 线程 1
    begin : threads_inner
      check_trans(tr1);  // 线程 2
      check_trans(tr2);  // 线程 3
    end

    // 停止线程 2 和线程 3，单独保留线程 0
    #(TIME_OUT / 10) disable threads_inner;
  join
end
