import "DPI-C" function chandle counter7_new();
import "DPI-C" function void counter7_count(input chandle inst);
import "DPI-C" function void counter7_load(input chandle inst,
 input bit [6:0] i);
import "DPI-C" function void counter7_reset(input chandle inst);
import "DPI-C" function int counter7_get(input chandle inst);

// 用 SystemVerilog 类静态封装 C 静态函数以隐藏 C++ 实例的句柄
class Counter7;
 chandle inst;

 function new();
 inst = counter7_new();
 endfunction

 function void count();
 counter7_count(inst);
 endfunction

 function void load(input bit [6:0] val);
 counter7_load(inst, val);
 endfunction

 function void reset();
 counter7_reset(inst);
 endfunction

 function bit [6:0] get();
 return counter7_get(inst);
 endfunction

endclass : Counter7

program automatic test;
 Counter7 c1;

 initial begin
 c1 = new;

 c1.reset();
 $display("SV: Post reset: counter1 = %0d", c1.get());

 c1.load(126);
 if (c1.get() == 126) 
 $display("Successful load");
 else
 $display("Error: load, expect 126, got %0d", c1.get());

 c1.count(); // count = 127
 if (c1.get() == 127) 
 $display("Successful count");
 else
 $display("Error: load, expect 127, got %0d”, c1.get());

 c1.count(); // count = 0
 if (c1.get() == 0) 
 $display("Successful rollover");
 else
 $display("Error: rollover, exp 127, got %0d”, c1.get());
 end

endprogram