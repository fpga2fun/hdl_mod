import "DPI-C" function void mydisplay(inout int h[][]);

program automatic test;
  int a[6:1][8:3];  // 注意此处字范围由高到低
  initial begin
    foreach (a[i, j]) a[i][j] = i + j;
    mydisplay(a);
    foreach (a[i, j]) $display("V: a[%0d][%0d] = %0d", i, j, a[i][j]);
  end
endprogram
