class Transaction;
  bit [31:0] addr, csm, data[8];

  function void display();
    $display("Transaction: %h", addr);
  endfunction : display

  function void calc_csm();
    csm = addr ^ data.xor;
  endfunction : calc_csm

endclass : Transaction
