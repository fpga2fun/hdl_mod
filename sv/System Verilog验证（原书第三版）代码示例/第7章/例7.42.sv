program automatic mbx_evt;
  mailbox #(int) mbx;
  event handshake;

  class Producer;
    task run();
      for (int i = 1; i < 4; i++) begin
        $display("Producer: before put(%0d)", i);
        mbx.put(i);
        @handshake;
        $display("Producer: after put(%0d)", i);
      end
    endtask
  endclass : Producer

  class Consumer;
    task run();
      int i;
      repeat (3) begin
        mbx.get(i);
        $display("Consumer: after get(%0d)", i);
        ->handshake;
      end
    endtask
  endclass : Consumer

  Producer p;
  Consumer c;

  initial begin
    p   = new();
    c   = new();
    mbx = new();

    // 使生产方和消费方并发运行
    fork
      p.run();
      c.run();
    join
  end
endprogram
