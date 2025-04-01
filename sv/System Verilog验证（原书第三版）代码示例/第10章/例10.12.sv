program automatic test ();
  virtual bus_ifc bus = top.bus;  // 跨模块引用
  initial $display(bus.data);  // 使用接口信号
endprogram
