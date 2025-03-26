class Transaction;
  rand bit [31:0] src;
  virtual function void display(input string prefix = "");
    $display("%sTransaction: src = %0d", prefix, src);
  endfunction
endclass

class BadTr extends Transaction;
  bit bad_csm;
  virtual function void display(input string prefix = "");
    $display("%sBadTr: bad_csm = %b", prefix, bad_csm);
    super.display(prefix);
  endfunction
endclass
