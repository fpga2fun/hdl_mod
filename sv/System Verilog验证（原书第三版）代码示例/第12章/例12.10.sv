import "DPI-C" function chandle counter7_new();
import "DPI-C" function void counter7(
  input chandle inst,
  output bit [6:0] out,
  input bit [6:0] in,
  input bit reset,
  load
);

// 测试计数器的两个实例
program automatic test;

  bit [6:0] o1, o2, i1, i2;
  bit reset, load, clk;
  chandle inst1, inst2;  // 指向 C 的存储空间

  initial begin
    inst1 = counter7_new();
    inst2 = counter7_new();
    fork
      forever #10 clk = ~clk;
      forever
      @(posedge clk) begin
        counter7(inst1, o1, i1, reset, load);
        counter7(inst2, o2, i2, reset, load);
      end
    join_none

    reset = 0;  // 初始化信号
    load = 0;
    i1 = 120;
    i2 = 10;

    @(negedge clk) load = 1;  // 装载数据
    @(negedge clk) load = 0;  // 计数
    @(negedge clk) $finish;
  end
endprogram
