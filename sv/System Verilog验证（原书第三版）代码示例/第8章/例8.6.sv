class Generator;
  mailbox #(Transaction) gen2drv;
  Transaction blueprint;

  function new(input mailbox#(Transaction) gen2drv);
    this.gen2drv = gen2drv;
    blueprint = new();
  endfunction

  virtual task run(input int num_tr = 10);
    repeat (num_tr) begin
      `SV_RAND_CHECK(blueprint.randomize);
      gen2drv.put(blueprint.copy());  // 将拷贝发送到驱动器
    end
  endtask
endclass
