interface arb_if (
    input bit clk
);
  logic [1:0] grant, request;
  bit rst;

  modport TEST(output request, rst, input grant, clk);

  modport DUT(input request, rst, clk, output grant);

  modport MONITOR(input request, grant, rst, clk);

endinterface
