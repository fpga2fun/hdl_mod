task driver(input mailbox#(Transaction) mbx);
  Transaction tr;
  forever begin
    mbx.get(tr);  // 获取来自信箱的事务
    $display("DRV: Received addr = %h", tr.addr);
    // 驱动事务到待测设计中
  end
endtask
