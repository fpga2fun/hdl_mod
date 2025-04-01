class Transaction;
  bit [31:0] addr, csm, data[8];
  static int count = 0;
  int id;
  Statistics stats;  // 指向 Statistics 对象的句柄

  function new();
    stats = new();  // 构造一个新的 Statistics 对象
    id = count++;
  endfunction
endclass

Transaction src, dst;
initial begin
  src = new();  // 创建一个 Transaction 对象
  src.stats.startT = 42;  // 结果见图 5.5
  dst = new src;  // 用 new 操作符将 src 拷贝到 dst 中，结果见图 5.6
  dst.stats.startT = 96;  // 改变 dst 和 src 的 stats
  $display(src.stats.startT);  //“96”，见图 5.7
end
