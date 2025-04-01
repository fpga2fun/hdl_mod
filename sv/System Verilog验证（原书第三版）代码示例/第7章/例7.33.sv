task generator_good(input int n, input mailbox#(Transaction) mbx);
  Transaction tr;
  repeat (n) begin
    tr = new();  // 创建一个新的事务
    `SV_RAND_CHECK(tr.randomize());
    $display("GEN: Sending addr = %h", tr.addr);
    mbx.put(tr);  // 把事务发送给驱动器
  end
endtask
