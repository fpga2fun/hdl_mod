// 测试平台的 Environment 类
class Environment;
  Generator gen;
  Driver drv;
  mailbox #(Transaction) gen2drv;

  virtual function void build();  // 通过构建邮箱、发生器和驱动器来创建环境
    gen2drv = new();
    gen = new(gen2drv);
    drv = new(gen2drv);
  endfunction

  virtual task run();
    fork
      gen.run();
      drv.run();
    join
  endtask

  virtual task wrap_up();
    // 暂时为空，调用记分板（scoreboard）生成报告
  endtask
endclass
