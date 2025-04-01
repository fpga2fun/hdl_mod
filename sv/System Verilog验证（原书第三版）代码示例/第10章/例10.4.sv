module top;
  logic clk, rst;
  Rx_if Rx[4] (clk);
  Tx_if Tx[4] (clk);

  test t1 (
      Rx,
      Tx,
      rst
  );  // 见例 10.6 的测试平台
  atm_router a1 (
      Rx[0],
      Rx[1],
      Rx[2],
      Rx[3],
      Tx[0],
      Tx[1],
      Tx[2],
      Tx[3],
      clk,
      rst
  );

  initial begin
    clk = 0;
    forever #20 clk = !clk;
  end
endmodule : top
