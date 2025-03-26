module top;
 bus_ifc bus(); // 例化接口
 test t1(bus); // 通过端口列表传递给测试程序
 dut d1(bus); // 通过端口列表传递给 DUT
 ...
endmodule