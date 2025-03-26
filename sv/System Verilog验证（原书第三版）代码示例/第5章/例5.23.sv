class Transaction;
  bit [31:0] addr, csm, data[8];
  Statistics stats;  //Statistics 句柄

  function new();
    stats = new();  // 创建 statistics 实例
  endfunction

  task transmit_me();
    // 填充包数据
    stats.start();
    // 传送数据包
    #100;
    stats.stop();
  endtask
endclass
