class Transaction;
  bit [31:0] addr, csm, data[8];
  extern function void display();
endclass

function void Transaction::display();
  $display("@%0t: Transaction addr = %h, csm = %h, data = %p", $time, addr, csm, data);
endfunction

class PCI_Tran;
  bit [31:0] addr, data;  // 使用实名
  extern function void display();
endclass

function void PCI_Tran::display();
  $display("@%0t: PCI: addr = %h, data = %h", $time, addr, data);
endfunction
