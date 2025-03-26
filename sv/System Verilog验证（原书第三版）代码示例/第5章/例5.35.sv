class Transaction;
  bit [31:0] addr, csm, data[8];
  Statistics stats;  // 指向 Statistics 对象的句柄
  static int count = 0;
  int id;

  function new();
    stats = new();
    id = count++;
  endfunction

  function Transaction copy();
    copy = new();  // 创建目标
    copy.addr = addr;  // 填入数值
    copy.csm = csm;
    copy.data = data;
    copy.stats = stats.copy();  // 调用 Statstics::copy 函数
    id = count++;
  endfunction
endclass
