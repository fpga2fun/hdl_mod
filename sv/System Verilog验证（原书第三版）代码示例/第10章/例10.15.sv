program automatic test();
 virtual bus_ifc bus = top.bus;
 virtual new_ifc newb = top.newb
 
 initial begin
 $display(bus.data); // 使用已有接口
 $display(newb.addr); // 增加一个接口
 end
endprogram