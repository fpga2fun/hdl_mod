module top;
  bit clk, rst;
  always #5 clk = !clk;

  Rx_if Rx0 (clk), Rx1 (clk), Rx2 (clk), Rx3 (clk);
  Tx_if Tx0 (clk), Tx1 (clk), Tx2 (clk), Tx3 (clk);
  atm_router a1 (
      Rx0,
      Rx1,
      Rx2,
      Rx3,  // 或者仅使用 (.*)
      Tx0,
      Tx1,
      Tx2,
      Tx3,
      clk,
      rst
  );

  test t1 (
      Rx0,
      Rx1,
      Rx2,
      Rx3,  // 或者仅使用 (.*)
      Tx0,
      Tx1,
      Tx2,
      Tx3,
      clk,
      rst
  );
endmodule : top
