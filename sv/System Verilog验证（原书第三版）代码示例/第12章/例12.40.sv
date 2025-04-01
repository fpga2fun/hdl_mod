module memory;
  import "DPI-C" context task read_file(string fname);
  export "DPI-C" task mem_read;
  export "DPI-C" task mem_write;
  export "DPI-C" function mem_build;

  initial read_file("mem.dat");

  int mem[];

  function void mem_build(input int size);
    mem = new[size];
  endfunction

  task mem_read(input int addr, output int data);
    #20 data = mem[addr];
  endtask

  task mem_write(input int addr, input int data);
    #10 mem[addr] = data;
  endtask
endmodule : memory
