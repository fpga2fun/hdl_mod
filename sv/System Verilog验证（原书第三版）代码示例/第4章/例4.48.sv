interface Tx_if (
    input logic clk
);
  logic [7:0] data;
  logic soc, en, clav, tclk;

  clocking cb @(posedge clk);
    input data, soc, en;
    output clav;
  endclocking : cb

  modport DUT(output data, soc, en, tclk, input clk, clav);

  modport TB(clocking cb);
endinterface : Tx_if
