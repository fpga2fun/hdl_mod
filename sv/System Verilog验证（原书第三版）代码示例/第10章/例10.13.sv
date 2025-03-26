module top;
 bus_ifc bus(); // 例化接口
 test t1(); // 测试程序不使用端口列表
 dut d1(bus); //DUT 仍旧使用端口列表
 ...
endmodule