module logic_data_type (
    input logic rst_h
);
  parameter CYCLE = 20;
  logic q, q_l, d, clk, rst_l;
  initial begin
    clk = 0;  // 过程赋值
    forever #(CYCLE / 2) clk = ~clk;
  end

  assign rst_l = ~rst_h;  // 连续赋值
  not n1 (q_l, q);  // q_l 被门驱动
  my_dff d1 (
      q,
      d,
      clk,
      rst_l
  );  // q 被模块驱动

endmodule
