task generator_bad(input int n, input mailbox#(Transaction) mbx);
  Transaction tr;
  tr = new();  // 只创建一个事务
  repeat (n) begin
    `SV_RAND_CHECK(tr.randomize());
    $display("GEN: Sending addr = %h", tr.addr);
    mbx.put(tr);  // 把事务发送给驱动器
  end
endtask
