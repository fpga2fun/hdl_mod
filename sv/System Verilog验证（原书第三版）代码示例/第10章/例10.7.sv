typedef virtual Tx_if vTx_t;

class Monitor;
  int stream_id;
  mailbox rcv_mbx;
  vTx_t Tx;

  function new(input mailbox rcv_mbx, input int stream_id, input vTx_t Tx);
    this.rcv_mbx = rcv_mbx;
    this.stream_id = stream_id;
    this.Tx = Tx;
  endfunction  // new

  task run();
    ATM_Cell ac;
    fork
      begin

        // 初始化输出信号
        Tx.cb.clav <= 0;  // 还没准备好接收
        @Tx.cb;

        $display("@%0d: Monitor::run [%0d] starting", $time, stream_id);
        forever begin
          receive_cell(ac);
        end
      end
    join_none
  endtask : run

  task receive_cell(input ATM_Cell ac);
    bit [7:0] bytes[];

    bytes = new[ATM_CELL_SIZE];
    ac = new();  // 初始化信元

    @Tx.cb;
    Tx.cb.clav <= 1;  // 置位，准备接收
    while (Tx.cb.soc !== 1'b1)  // 等待信元的开始
      @Tx.cb;

    foreach (bytes[i]) begin
      while (Tx.cb.en != 0)  // 等待使能信号
      @Tx.cb;
      bytes[i] = Tx.cb.data;
      @Tx.cb;
      Tx.cb.clav <= 0;  // 释放流控信号
    end

    ac.byte_unpack(bytes);
    $display("@%0d: Monitor::run (%0d) received cell vci = %h", $time, stream_id, ac.vci);

    // 将信元送至记分牌
    rcv_mbx.put(ac);
  endtask : receive_cell

endclass : Monitor
