interface arb_if (
    input bit clk
);
  logic [1:0] grant, request;
  bit rst;

  clocking cb @(posedge clk);  // 声明 cb
    output request;
    input grant;
  endclocking

  modport TEST(clocking cb,  // 使用 cb
      output rst
  );
  modport DUT(input request, rst, clk, output grant);
endinterface

// 这是一个简单的测试程序，更好的测试程序见例 4.21
module test_with_cb (
    arb_if.TEST arbif
);
  initial begin
    @arbif.cb;
    arbif.cb.request <= 2'b01;
    @arbif.cb;
    $display("@%0t: Grant = %b", $time, arbif.cb.grant);
    @arbif.cb;
    $display("@%0t: Grant = %b", $time, arbif.cb.grant);
    $finish;
  end
endmodule
