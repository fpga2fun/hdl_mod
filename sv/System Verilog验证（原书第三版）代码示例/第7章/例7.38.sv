program automatic unsynchronized;

  mailbox #(int) mbx;

  class Producer;
    task run();
      for (int i = 1; i < 4; i++) begin
        $display("Producer: before put(%0d)", i);
        mbx.put(i);
      end
    endtask
  endclass

  class Consumer;
    task run();
      int i;
      repeat (3) begin
        mbx.get(i);  // 从 mbx 中提取整数
        $display("Consumer: after get(%0d)", i);
      end
    endtask
  endclass

  Producer p;
  Consumer c;

  initial begin
    // 构建信箱、生产方和消费方
    mbx = new();  // 容量不限
    p   = new();
    c   = new();

    // 并发运行生产方和消费方
    fork
      p.run();
      c.run();
    join
  end
endprogram
