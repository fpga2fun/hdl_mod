// 使用 Transaction 对象的发生器类
// 第一个尝试 ... 只有有限的功能
class Generator;
  mailbox #(Transaction) gen2drv;  // 将事务传递给驱动器
  Transaction tr;

  function new(input mailbox#(Transaction) gen2drv);
    this.gen2drv = gen2drv;  //this-> 类一级变量
  endfunction

  virtual task run(input int num_tr = 10);
    repeat (num_tr) begin
      tr = new();  // 创建事务
      `SV_RAND_CHECK(tr.randomize());  // 随机化
      gen2drv.put(tr.copy());  // 复制一份送入驱动器
    end
  endtask
endclass
