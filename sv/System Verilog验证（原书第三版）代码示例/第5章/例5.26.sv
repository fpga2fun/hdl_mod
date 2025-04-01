function void create(Transaction tr); // 错误，缺少 ref
 tr = new();
 tr.addr = 42;
 // 初始化其他域
  ...
endfunction
Transaction t;
initial begin
 create(t); // 创建一个 transaction
 $display(t.addr); // 失败，因为 t = null
end