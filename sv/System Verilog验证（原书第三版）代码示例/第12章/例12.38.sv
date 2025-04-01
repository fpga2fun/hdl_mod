module memory;
  import "DPI-C" context function void read_file(string fname);
  export "DPI-C" function mem_build;  // 没有类型定义或者参数
  initial read_file("mem.dat");
  int mem[];
  function void mem_build(input int size);
    mem = new[size];  // 分配动态内存元素
  endfunction
endmodule : memory
