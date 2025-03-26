module top;
 bit clk;
 test t1(.*);
endmodule

`define TOP $root.top
program automatic test;
 initial begin
 // 绝对引用
 $display("clk = %b", $root.top.clk);
 $display("clk = %b", `TOP.clk); // 使用宏
 
 // 相对引用
 $display("clk = %b", top.clk);
endprogram