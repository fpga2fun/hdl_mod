module top;
  logic [1:0] grant, request;
  bit clk;
  always #50 clk = ~clk;

  arb_if arbif (clk);  // 例 4.10
  arb_with_mp a1 (arbif.DUT);  // 例 4.11
  test_with_mp t1 (arbif.TEST);  // 例 4.12
endmodule
