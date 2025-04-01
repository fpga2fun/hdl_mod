package Better;
  class Bad;
    logic [31:0] data[];

    // 未定义 i，不会被编译
    function void display();
      for (i = 0; i < data.size(); i++) $display("data[%0d] = %x", i, data[i]);
    endfunction
  endclass
endpackage

program automatic test;
  int i;  // 程序级变量
  import Better::*;
  //...
endprogram
