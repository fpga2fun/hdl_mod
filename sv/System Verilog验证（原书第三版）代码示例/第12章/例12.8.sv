import "DPI-C" function void counter7(
  output bit [6:0] out,
  input bit [6:0] in,
  input bit reset,
  load
);
program automatic counter;
  bit [6:0] out, in;
  bit reset, load;

  initial begin
    $monitor("SV: out = %3d, in = %3d, reset = %0d, load = %0d\n", out, in, reset, load);
    reset = 0;  // 缺省值
    load = 0;
    in = 126;
    counter7(out, in, reset, load);  // 使用缺省值

    #10 reset = 1;
    counter7(out, in, reset, load);  // 复位

    #10 reset = 0;
    load = 1;
    counter7(out, in, reset, load);  // 装载 in = 126

    #10 load = 0;
    counter7(out, in, reset, load);  // 计数

  end
endprogram
