class Scb_Driver_cbs extends Driver_cbs;
  Scoreboard scb;

  function new(input Scoreboard scb);
    this.scb = scb;
  endfunction : new

  // 把收到的信元发送到记分牌
  virtual task post_tx(input Driver drv, input UNI_cell c);
    scb.save_expected(c);
  endtask : post_tx
endclass : Scb_Driver_cbs
