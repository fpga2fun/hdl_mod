class Transaction;
  bit [31:0] addr, csm, data[8];
  function new();
    $display("In %m");
  endfunction
endclass

Transaction src, dst;
initial begin
  src = new();  // 创建第一个对象
  dst = new src;  // 使用 new 操作符进行复制
end
