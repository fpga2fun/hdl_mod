class Transaction;
  rand bit [31:0] src, dst, data[8];  // 随机变量
  bit [31:0] csm;  // 计算得到的校验和

  virtual function void calc_csm();
    csm = src ^ dst ^ data.xor;
  endfunction

  virtual function void display(input string prefix = "");
    $display("%sTr: src = %h, dst = %h, csm = %h, data = %p", prefix, src, dst, csm, data);
  endfunction
endclass
