import "DPI-C" function void fib(output bit [31:0] data[20]);

program automatic test;
  bit [31:0] data[20];

  initial begin
    fib(data);
    foreach (data[i]) $display(i,, data[i]);
  end
endprogram
