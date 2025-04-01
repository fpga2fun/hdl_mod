module top;
  bit clk;
  always #50 clk = ~clk;

  arb_if arbif (.*);  // … arbif(clk) 来自例 4.4
  arb_with_ifc a1 (.*);  // … a1(arbif) 来自例 4.5
  test_with_ifc t1 (.*);  // … t1(arbif) 来自例 4.6
endmodule : top
