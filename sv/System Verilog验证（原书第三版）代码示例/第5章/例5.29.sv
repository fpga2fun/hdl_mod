task generator_good(input int n);
  Transaction t;
  repeat (n) begin
    t = new();  // 创建一个新对象
    t.addr = $random();  // 变量初始化
    $display("Sending addr = %h", t.addr);
    transmit(t);  // 将它发送到 DUT
  end
endtask
