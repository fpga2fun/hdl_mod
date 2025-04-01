class Bad_OOB;
  bit [31:0] addr, csm, data[8];  // 类一级的变量
  extern function void display();
endclass

function void display();  // 忘记 “Bad_OOB::”
  $display("addr = %0d", addr);  // 错误：找不到 addr
endfunction
