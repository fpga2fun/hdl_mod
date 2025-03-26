interface Rx_if (
    input logic clk
);
  logic [7:0] data;
  logic soc, en, clav, rclk;

  clocking cb @(posedge clk);
    output data, soc, clav;  // 方向是相对测试平台的
    input en;
  endclocking : cb

  modport DUT(output en, rclk, input data, soc, clav);

  modport TB(clocking cb);
endinterface : Rx_if
