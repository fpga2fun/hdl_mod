interface arb_if (
    input bit clk
);
  logic [1:0] grant, request;
  bit rst;
endinterface
