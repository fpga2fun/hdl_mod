class dyn_size;
  rand bit [31:0] d[];
  constraint d_size {d.size() inside {[1 : 10]};}
endclass
