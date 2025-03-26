// 带有 modport 和时钟块的 Rx 接口
interface Rx_if (
    input logic clk
);
  logic [7:0] data;
  logic soc, en, clav, rclk;
  clocking cb @(posedge clk);
    output data, soc, clav;  // 方向是相对于测试平台的
    input en;
  endclocking : cb

  modport TB(clocking cb);

  modport DUT(output en, rclk, input data, soc, clav);
endinterface : Rx_if
