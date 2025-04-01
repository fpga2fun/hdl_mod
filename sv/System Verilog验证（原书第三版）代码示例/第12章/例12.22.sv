import "DPI-C" function void fib_oa(output bit [31:0] data[]);
program automatic test;
  localparam SIZE = 20;
  bit [31:0] data[SIZE], r;

  initial begin
    fib_oa(data, SIZE);
    foreach (data[i]) $display(i,, data[i]);
  end
endprogram
