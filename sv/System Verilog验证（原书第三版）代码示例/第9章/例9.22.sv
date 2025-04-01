initial begin
 CovDst22 ck = new(); // 实例化覆盖组
 
 // 复位期间停止收集覆盖率数据
 #1ns ck.stop();
 bus_if.rst <= 1;
 #100ns bus_if.rst <= 0; // 复位结束
 ck.start();
 ...
end