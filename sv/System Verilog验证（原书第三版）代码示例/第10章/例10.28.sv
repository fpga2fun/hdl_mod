module top;
  parameter NUM_XI = 2;  // 实例的个数
  parameter BIT_WIDTH = 4;  // 计数器和总线的位宽

  // 时钟发生器
  bit clk;
  initial begin
    clk <= '0;
    forever #20 clk = ~clk;
  end

  // 例化 N 个接口
  X_if #(.BIT_WIDTH(BIT_WIDTH)) xi[NUM_XI] (clk);

  // 带有接口数量和位宽参数的测试平台
  test #(
      .NUM_XI(NUM_XI),
      .BIT_WIDTH(BIT_WIDTH)
  ) tb ();

  // 产生 N 个计数器实例
  generate
    for (genvar i = 0; i < NUM_XI; i++) begin : count_blk
      counter #(.BIT_WIDTH(BIT_WIDTH)) c (xi[i]);
    end
  endgenerate

endmodule : top
