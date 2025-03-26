typedef class Driver_cbs;

class Driver;

  mailbox gen2drv;  // 用于存储发生器发送的信元
  event drv2gen;  // 通知发生器已经处理完毕
  vUtopiaRx Rx;  // 发送信元的虚拟 IFC
  Driver_cbs cbsq[$];  // 回调对象的队列
  int PortID;

  extern function new(input mailbox gen2drv, input event drv2gen, input vUtopiaRx Rx,
                      input int PortID);
  extern task run();
  extern task send(input UNI_cell c);

endclass : Driver

//new(): 构造 driver 对象
function Driver::new(input mailbox gen2drv, input event drv2gen, input vUtopiaRx Rx,
                     input int PortID);
  this.gen2drv = gen2drv;
  this.drv2gen = drv2gen;
  this.Rx = Rx;
  this.PortID = PortID;
endfunction : new

//run(): 运行 driver
// 获取发生器的事务，发送给 DUT
task Driver::run();
  UNI_cell c;
  bit drop = 0;

  // 初始化端口
  Rx.cbr.data <= 0;
  Rx.cbr.soc  <= 0;
  Rx.cbr.clav <= 0;

  forever begin
    // 从 mailbox 队列中读取一个信元
    gen2drv.peek(c);
    begin : Tx
      // 发送前的回调
      foreach (cbsq[i]) begin
        cbsq[i].pre_tx(this, c, drop);
        if (drop) disable Tx;  // 不发送这个信元
      end

      c.display($sformatf("@%0t: Drv%0d: ", $time, PortID));
      send(c);

      // 发送后的回调
      foreach (cbsq[i]) cbsq[i].post_tx(this, c);
    end : Tx

    gen2drv.get(c);  // 从 mailbox 中删除该信元
    ->drv2gen;  // 通知发生器该信元处理完毕
  end
endtask : run

//send(): 把信元发送给 DUT
task Driver::send(input UNI_cell c);
  ATMCellType Pkt;

  c.pack(Pkt);
  $write("Sending cell: ");
  foreach (Pkt.Mem[i]) $write("%x ", Pkt.Mem[i]);
  $display;

  // 遍历整个信元
  @(Rx.cbr);
  Rx.cbr.clav <= 1;
  for (int i = 0; i <= 52; i++) begin
    // 如果没有使能，循环等待
    while (Rx.cbr.en === 1'b1) @(Rx.cbr);

    // 置位信元开始信号、使能信号，发送字节 0(i == 0)
    Rx.cbr.soc  <= (i == 0);
    Rx.cbr.data <= Pkt.Mem[i];
    @(Rx.cbr);
  end
  Rx.cbr.soc  <= 'z;
  Rx.cbr.data <= 8'bx;
  Rx.cbr.clav <= 0;
endtask
