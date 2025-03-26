module top;
  bit clk;
  always #50 clk = ~clk;
  arb_if arbif (clk);
  arb_with_port a1 (
      .grant(arbif.grant),  //.port(ifc.signal)
      .request(arbif.request),
      .rst(arbif.rst),
      .clk(arbif.clk)
  );
  test_with_ifc t1 (arbif);  // 来自例 4.6
endmodule : top
