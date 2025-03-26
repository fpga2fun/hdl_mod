parameter NUM_XI = 2; // 实例个数

module top;
 // 例化 N 个接口
 X_if xi [NUM_XI] (clk);
 ...
 // 例化测试平台
 test tb(xi);
 
endmodule : top