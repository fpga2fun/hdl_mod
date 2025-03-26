virtual class Driver_cbs;  // 驱动器回调
  virtual task pre_tx(ref Transaction tr, ref bit drop);
    // 默认情况下回调不做任何动作
  endtask
  virtual task post_tx(ref Transaction tr);
    // 默认情况下回调不做任何动作
  endtask
endclass
