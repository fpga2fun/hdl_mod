program automatic synch_peek;
  // 使用例 7.38 中的生产方

  mailbox #(int) mbx;

  class Consumer;
    task run();
      int i;
      repeat (3) begin
        mbx.peek(i);  // 从 mbx 里取出一个整数
        $display("Consumer: after get(%0d)", i);
        mbx.get(i);  // 从 mbx 里移出
      end
    endtask
  endclass : consumer

  Producer p;
  Consumer c;

  initial begin
    // 创建信箱、生产方和消费方
    mbx = new(1);  // 定容信箱，容量限定为 1 ！
    p   = new();
    c   = new();

    // 使生产方和消费方并发运行
    fork
      p.run();
      c.run();
    join
  end
endprogram
