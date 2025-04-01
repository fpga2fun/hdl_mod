program automatic test (
    bus_if.TB bus
);
  initial begin
    @bus.cb;  // 在时钟块的有效时钟沿继续
    repeat (3) @bus.cb;  // 等待 3 个有效时钟沿
    @bus.cb.grant;  // 在任何边沿继续
    @(posedge bus.cb.grant);  // 上升沿继续
    @(negedge bus.cb.grant);  // 下降沿继续
    wait (bus.cb.grant == 1);  // 等待表达式被执行，如果已经是真，不做任何延时
    @(posedge bus.cb.grant or negedge bus.rst);  // 等待几个信号
  end
endprogram
