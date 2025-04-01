// 带有 modport 和时钟块的 Tx 接口
interface Tx_if (
    input logic clk
);
  logic [7:0] data;
  logic soc, en, clav, tclk;

  clocking cb @(posedge clk);
    input data, soc, en;
    output clav;
  endclocking : cb

  modport TB(clocking cb);

  modport DUT(output data, soc, en, tclk, input clav);
endinterface : Tx_if
