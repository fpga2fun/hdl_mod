task generator_bad(input int n);
  Transaction t;
  t = new();  // 创建一个新对象
  repeat (n) begin
    t.addr = $random();  // 变量初始化
    $display("Sending addr = %h", t.addr);
    transmit(t);  // 将它发送到 DUT
  end
endtask
