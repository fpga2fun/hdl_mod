program automatic test();
 int errors, warnings;

 initial begin
 ... // 程序块的主要行为
 end

 final
 $display("Test completed with %0d errors and %0d warnings",errors, warnings);
endprogram