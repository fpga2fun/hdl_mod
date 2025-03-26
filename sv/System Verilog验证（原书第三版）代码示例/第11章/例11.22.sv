typedef class Monitor_cbs;

class Monitor;

  vUtopiaTx Tx;  // 连接 DUT 输出的虚拟接口
  Monitor_cbs cbsq[$];  // 回调对象的队列
  bit [1:0] PortID;

  extern function new(input vUtopiaTx Tx, input int PortID);
  extern task run();
  extern task receive(output NNI_cell c);
endclass : Monitor

//new(): 构造对象
function Monitor::new(input vUtopiaTx Tx, input int PortID);
  this.Tx = Tx;
  this.PortID = PortID;
endfunction : new

//run(): 运行 monitor
task Monitor::run();
  NNI_cell c;

  forever begin
    receive(c);
    foreach (cbsq[i]) cbsq[i].post_rx(this, c);  // 接收信元后的回调
  end
endtask : run

//receive(): 从 DUT 读取信元，打包成 NNI 格式的信元
task Monitor::receive(output NNI_cell cell);
 ATMCellType Pkt;

 Tx.cbt.clav <= 1;
 while (Tx.cbt.soc !== 1'b1 && Tx.cbt.en !== 1'b0) @(Tx.cbt);
 for (int i = 0; i <= 52; i++) begin
 // 如果没有使能，循环等待
 while (Tx.cbt.en !== 1'b0) @(Tx.cbt);

 Pkt.Mem[i] = Tx.cbt.data;
 @(Tx.cbt);
 end

 Tx.cbt.clav <= 0;

 c = new();
 c.unpack(Pkt);
 c.display($sformatf("@%0t: Mon%0d: ", $time, PortID));
endtask : receive
