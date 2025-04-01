module top;
  bit clk;
  always #50 clk = !clk;

  arb_if arbif (clk);  // 带有 modport 的接口
  uses_an_interface u1 (arbif);  // 必须这样定义才能被编译
endmodule
