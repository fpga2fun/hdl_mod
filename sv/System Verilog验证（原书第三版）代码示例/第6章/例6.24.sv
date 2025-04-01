class BusOp;
  rand bit [31:0] addr;
  rand bit io_space_mode;
  constraint c_io {if (io_space_mode) addr[31] == 1'b1;}
endclass
