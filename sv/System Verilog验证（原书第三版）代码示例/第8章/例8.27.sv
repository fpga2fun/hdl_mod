// 局部示例，详细信息见例 8.4
class Driver;
  Driver_cbs cbs[$];  // 回调对象的队列

  task run();
    bit drop;
    Transaction tr;

    forever begin
      drop = 0;
      agt2drv.get(tr);  // 驱动器邮箱的代理
      foreach (cbs[i]) cbs[i].pre_tx(tr, drop);
      if (drop) continue;
      transmit(tr);  // 实际工作
      foreach (cbs[i]) cbs[i].post_tx(tr);
    end
  endtask
endclass
