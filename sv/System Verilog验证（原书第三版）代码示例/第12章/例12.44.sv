module memory;
  import "DPI-C" context task read_file(string fname);
  export "DPI-C" task mem_read;
  export "DPI-C" task mem_write;
  export "DPI-C" function mem_build;

  initial read_file("mem.dat");  // 调用 C 语言代码读取文件

  class Memory;
    int mem[];

    function new(input int size);
      mem = new[size];
    endfunction

    task mem_read(input int addr, output int data);
      #20 data = mem[addr];
    endtask

    task mem_write(input int addr, input int data);
      #10 mem[addr] = data;
    endtask : mem_write
  endclass : Memory

  Memory memq[$];  // 内存对象队列

  // 创建一个新的内存实例并将其压入队列
  function void mem_build(input int size);
    Memory m;
    m = new(size);
    memq.push_back(m);
  endfunction

  // idx 是 memq 内存句柄的索引
  task mem_read(input int idx, addr, output int data);
    memq[idx].mem_read(addr, data);
  endtask

  task mem_write(input int idx, addr, input int data);
    memq[idx].mem_write(addr, data);
  endtask

endmodule : memory
