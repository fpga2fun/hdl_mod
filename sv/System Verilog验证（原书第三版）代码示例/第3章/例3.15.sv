task many(input int a = 1, b = 2, c = 3, d = 4);
  $display("%0d %0d %0d %0d", a, b, c, d);
endtask

initial begin  // a  b  c  d
  many(6, 7, 8, 9);  // 6  7  8  9  指定所有值
  many();  // 1  2  3  4  使用缺省值
  many(.c(5));  // 1  2  5  4  只指定 c
  many(, 6, .d(8));  // 1  6  3  8  混合方式
end
