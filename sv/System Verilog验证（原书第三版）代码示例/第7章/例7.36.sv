program automatic bounded;
  mailbox #(int) mbx;

  initial begin
    mbx = new(1);  // 容量为 1
    fork

      // 生产方线程
      for (int i = 1; i < 4; i++) begin
        $display("Producer: before put(%0d)", i);
        mbx.put(i);
        $display("Producer: after put(%0d)", i);
      end

      // 消费方线程
      repeat (4) begin
        int j;
        #1ns mbx.get(j);
        $display("Consumer: after get(%0d)", j);
      end
    join
  end
endprogram
