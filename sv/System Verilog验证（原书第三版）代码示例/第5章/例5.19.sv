program automatic test;
  int i;  // 程序级变量

  class Bad;
    logic [31:0] data[];

    // 调用该函数会改变程序级变量 i
    function void display();
      // 在下面的语句里忘了声明循环变量 i
      for (i = 0; i < data.size(); i++) $display("data[%0d] = %x", i, data[i]);
    endfunction
  endclass
endprogram
