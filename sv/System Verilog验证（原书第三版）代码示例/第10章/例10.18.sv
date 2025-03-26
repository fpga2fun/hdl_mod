module top;
  parameter NUM_XI = 2;  // 设计实例的个数

  // 时钟生成器
  bit clk;
  initial begin
    clk <= '0;
    forever #20 clk = ~clk;
  end

  // 例化 NUM_XI 个接口
  X_if xi[NUM_XI] (clk);

  // 例化测试平台，传递接口的数量
  test #(.NUM_XI(NUM_XI)) tb ();
  // 产生 NUM_XI 个 counter 实例
  generate
    for (genvar i = 0; i < NUM_XI; i++) begin : count_blk
      counter c (xi[i]);
    end
  endgenerate

endmodule : top
