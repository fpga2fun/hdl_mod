class Transaction;
  rand bit [31:0] addr, data;
  constraint c1 {addr inside {[0 : 100], [1000 : 2000]};}
endclass

initial begin
  Transaction t;
  t = new();

  //addr范围： 50-100, 1000-1500, data < 10
  `SV_RAND_CHECK(t.randomize() with {addr >= 50;
                                     addr <= 1500;
                                     data < 10;});

  driveBus(t);
  // 强制 addr 取固定值，data > 10
  `SV_RAND_CHECK(t.randomize() with {addr == 2000;
                                     data > 10;});

  driveBus(t);
end
