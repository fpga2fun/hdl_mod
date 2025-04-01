module clock_generator (
    output bit clk
);
  bit local_clk = 0;
  assign clk = local_clk;  // 用本地信号驱动端口
  always #50 local_clk = ~local_clk;
endmodule
