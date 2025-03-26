module top;
  bit clk;
  always #50 clk = ~clk;

  arb_if arbif (clk);  // 例 4.4
  arb_with_ifc a1 (arbif);  // 例 4.5
  test_with_ifc t1 (arbif);  // 例 4.6
endmodule : top
