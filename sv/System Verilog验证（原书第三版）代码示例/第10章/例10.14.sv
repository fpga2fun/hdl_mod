module top;
 bus_ifc bus(); // 例化接口
 new_ifc newb(); // 例化另一个接口
 test t1(); // 实例保持不变
 dut d1(bus, newb);
 ...
endmodule