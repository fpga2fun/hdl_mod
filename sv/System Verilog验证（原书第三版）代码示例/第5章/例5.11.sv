class Transaction;
  bit [31:0] addr, csm, data[8];
  function void display();
    $display("@%0t: TR addr = %h, csm = %h, data = %p", $time, addr, csm, data);
  endfunction
endclass

class PCI_Tran;
  bit [31:0] addr, data;  // 使用真实的名字
  function void display();
    $display("@%0t: PCI: addr = %h, data = %h", $time, addr, data);
  endfunction
endclass

Transaction t;
PCI_Tran pc;

initial begin
  t = new();  // 创建一个 Transaction 对象
  t.display();  // 调用 Transaction 的方法
  pc = new();  // 创建一个 PCT 事务
  pc.display();  // 调用 PCI 事务的方法
end
