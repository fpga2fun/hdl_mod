program automatic mbx_mbx2;
  mailbox #(int) mbx, rtn;
  class Producer;
    task run();
      int k;
      for (int i = 1; i < 4; i++) begin
        $display("Producer: before put(%0d)", i);
        mbx.put(i);
        rtn.get(k);
        $display("Producer: after get(%0d)", k);
      end
    endtask
  endclass : Producer

  class Consumer;
    task run();
      int i;
      repeat (3) begin
        $display("Consumer: before get");
        mbx.get(i);
        $display("Consumer: after get(%0d)", i);
        rtn.put(-i);
      end
    endtask
  endclass : Consumer

  Producer p;
  Consumer c;
  initial begin
    p   = new();
    c   = new();
    mbx = new();
    rtn = new();

    // 使生产方和消费方并发运行
    fork
      p.run();
      c.run();
    join
  end
endprogram
