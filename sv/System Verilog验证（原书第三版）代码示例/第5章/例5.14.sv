class Transaction;
  static int count = 0;  // 已创建的对象的数目
  int id;  // 实例的唯一标志
  function new();
    id = count++;  // 设置标志，count 递增
  endfunction
endclass

Transaction t1, t2;
initial begin
  t1 = new();  // 第一个实例，id = 0, count = 1
  $display("First id = %0d, count = %0d", t2.id, t2.count);
  t2 = new();  // 第二个实例 id = 1, count = 2
  $display("Second id = %0d, count = %0d", t2.id, t2.count);
end
