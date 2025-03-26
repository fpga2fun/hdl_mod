program automatic test;

  initial begin
    Generator #(Transaction) gen;
    mailbox #(Transaction)   gen2drv;
    gen2drv = new(1);
    gen = new(gen2drv);

    fork
      gen.run();
      repeat (5) begin
        Transaction tr;
        gen2drv.peek(tr);  // 获取下一个事务
        tr.display();
        gen2drv.get(tr);  // 删除事务
      end

    join_any
  end
endprogram  // test
