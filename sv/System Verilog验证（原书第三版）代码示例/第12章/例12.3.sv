program automatic test;
 // C 函数与关键词同名，需要修改函数名
 import "DPI-C" \expect = function int fexpect();
 ...
 if (actual != fexpect()) $display("ERROR");
 ...
 // 把 C 函数名 “stat” 改为 “file_exists”
 import "DPI-C" stat = function int file_exists
 (input string fname, output int buff[1000]);
 initial begin
 int buff[1000];
 $display("file_exists(\"none.such\") = %0d",
 file_exists("none.such", buff));
 end
endprogram