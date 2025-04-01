class UNI_generator;
  UNI_cell blueprint;  // blueprint 信元
  mailbox gen2drv;  // driver 的 Mailbox
  event drv2gen;  // driver 完成时的事件
  int nCells;  // 要产生的信元个数
  int PortID;  // 产生哪个 Rx 端口的信元？
  function new(input mailbox gen2drv, input event drv2gen, input int nCells, PortID);
    this.gen2drv = gen2drv;
    this.drv2gen = drv2gen;
    this.nCells = nCells;
    this.PortID = PortID;
    blueprint = new();
  endfunction : new
  task run();
    UNI_cell c;
    repeat (nCells) begin
      `SV_RAND_CHECK(blueprint.randomize());
      $cast(c, blueprint.copy());
      c.display($sformatf("@%0t: Gen%0d: ", $time, PortID));
      gen2drv.put(c);
      @drv2gen;  // 等待 driver 完成
    end
  endtask : run
endclass : UNI_generator
