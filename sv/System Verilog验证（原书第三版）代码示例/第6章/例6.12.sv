class Fib;
  rand bit [7:0] f;
  bit [7:0] vals[] = '{1, 2, 3, 5, 8};
  constraint c_fibonacci {f inside vals;}
endclass
