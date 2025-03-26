class Transaction;
  static int count = 0;  // 创建的对象数
endclass

initial begin
  run_test();
  $display("%d transactions were created", Transaction::count);  // 引用静态 w/o 句柄
end
