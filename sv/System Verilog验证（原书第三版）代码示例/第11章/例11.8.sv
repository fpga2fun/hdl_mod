class Scb_Monitor_cbs extends Monitor_cbs;
  Scoreboard scb;

  function new(input Scoreboard scb);
    this.scb = scb;
  endfunction : new

  // 把收到的信元发送到记分牌
  virtual task post_rx(input Monitor mon, input NNI_cell c);
    scb.check_actual(c, mon.PortID);
  endtask : post_rx
endclass : Scb_Monitor_cbs
