module top;
  logic [1:0] grant, request;
  bit clk;
  always #50 clk = ~clk;

  arb_with_port a1 (
      grant,
      request,
      rst,
      clk
  );  // 例 4.1
  test_with_port t1 (
      grant,
      request,
      rst,
      clk
  );  // 例 4.2
endmodule
