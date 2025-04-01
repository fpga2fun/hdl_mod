typedef class Monitor;

class Monitor_cbs;
  virtual task post_rx(input Monitor mon, input NNI_cell c);
  endtask : post_rx
endclass : Monitor_cbs
