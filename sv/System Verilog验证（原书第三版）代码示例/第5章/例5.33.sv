class Transaction;
  bit [31:0] addr, csm, data[8];  // 没有 Statistic 句柄

  function Transaction copy();
    copy = new();  // 创建目标对象
    copy.addr = addr;  // 填入数值
    copy.csm = csm;
    copy.data = data;  // 复制数组
  endfunction
endclass
