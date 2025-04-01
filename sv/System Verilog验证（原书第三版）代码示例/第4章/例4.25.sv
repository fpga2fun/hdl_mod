interface bidir_if (
    input bit clk
);
  wire [7:0] data;  // 双向信号
  clocking cb @(posedge clk);
    inout data;
  endclocking
  modport TEST(clocking cb);
endinterface
program automatic test (
    bidir_if.TEST mif
);
  initial begin
    mif.cb.data <= 'z;  // 三态总线
    @mif.cb;
    $displayh(mif.cb.data);  // 从总线读取
    @mif.cb;
    mif.cb.data <= 7'h5a;  // 驱动总线
    @mif.cb;
    $displayh(mif.cb.data);  // 从总线读取
    mif.cb.data <= 'z;  // 释放总线
  end
endprogram
