class Generator #(
    type T = BaseTr
);
  mailbox #(Transaction) gen2drv;
  T blueprint;  // 蓝图对象

  function new(input mailbox#(Transaction) gen2drv);
    this.gen2drv = gen2drv;
    blueprint = new();  // 创建默认类型的对象
  endfunction

  task run(input int num_tr = 10);
    T tr;
    repeat (num_tr) begin
      `SV_RAND_CHECK(blueprint.randomize);
      $cast(tr, blueprint.copy());  // 复制
      gen2drv.put(tr);  // 送给驱动器
    end
  endtask
endclass
