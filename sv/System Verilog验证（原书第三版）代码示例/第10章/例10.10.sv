module top;
 bus_ifc bus(); // 例化接口
 new_ifc newb(); // 再例化一个接口
 test t1(bus, newb); // 使用两个接口的测试程序
 dut d1(bus, newb); // 使用两个接口的 DUT 
 ...
endmodule