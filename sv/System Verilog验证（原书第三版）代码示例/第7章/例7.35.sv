program automatic mailbox_example (
    bus_ifc.TB bus
);

  class Generator;
    Transaction tr;
    mailbox #(Transaction) mbx;

    function new(input mailbox#(Transaction) mbx);
      this.mbx = mbx;
    endfunction

    task run(input int count);
      repeat (count) begin
        tr = new();
        `SV_RAND_CHECK(tr.randomize);
        mbx.put(tr);  // 发送事务
      end
    endtask
  endclass

  class Driver;
    Transaction tr;
    mailbox #(Transaction) mbx;

    function new(input mailbox#(Transaction) mbx);
      this.mbx = mbx;
    endfunction

    task run(input int count);
      repeat (count) begin
        mbx.get(tr);  // 获取下一个事务
        // 驱动事务
      end
    endtask
  endclass

  mailbox #(Transaction) mbx;  // 连接发生器（gen）和驱动器（drv）的信箱
  Generator gen;
  Driver drv;
  int count;
  initial begin
    mbx   = new();  // 创建信箱
    gen   = new(mbx);  // 创建发生器
    drv   = new(mbx);  // 创建驱动器
    count = $urandom_range(50);  // 运行最多 50 个事务
    fork
      gen.run(count);  // 运行发生器
      drv.run(count);  // 运行驱动器
    join  // 等待两者结束
  end
endprogram
