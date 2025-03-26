class Transaction;
  logic [31:0] addr, csm, data[8];
endclass : Transaction
class Driver;
  Transaction tr;
  function new();  // Driver 的 new() 函数
    tr = new();  // 调用 Transaction 的 new() 函数
  endfunction
endclass : Driver
