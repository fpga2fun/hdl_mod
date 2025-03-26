class Statistics;
  time startT;  // 事务的开始时间
  static int ntrans = 0;  // 事务的数目
  static time total_elapsed_time = 0;

  function void start();
    startT = $time;
  endfunction

  function void stop();
    time how_long = $time - startT;
    ntrans++;  // 另一个事务结束
    total_elapsed_time += how_long;
  endfunction

endclass
