program automatic test (
    bus_ifc bus,
    new_ifc newb
);
  initial $display(bus.data);  // 使用接口信号
endprogram
