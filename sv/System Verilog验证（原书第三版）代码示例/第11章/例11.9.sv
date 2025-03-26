class Cov_Monitor_cbs extends Monitor_cbs;
  Coverage cov;

  function new(input Coverage cov);
    this.cov = cov;
  endfunction : new

  // 把收到的信元发送到覆盖率类
  virtual task post_rx(input Monitor mon, input NNI_cell c);
    CellCfgType CellCfg = top.squat.lut.read(c.VPI);
    cov.sample(mon.PortID, CellCfg.FWD);
  endtask : post_rx
endclass : Cov_Monitor_cbs
