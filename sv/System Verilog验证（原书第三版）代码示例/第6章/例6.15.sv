initial begin
  Fib fib;
  int count[9], maxx[$];

  fib = new();
  repeat (20_000) begin
    `SV_RAND_CHECK(fib.randomize());
    count[fib.f]++;  // 统计值的个数
  end
  maxx = count.max();  // 获取最大值

  // 输出值的分布
  foreach (count[i])
  if (count[i]) begin
    $write("count[%0d] = %5d", i, count[i]);
    repeat (count[i] * 40 / maxx[0]) $write("*");
    $display;
  end
end
