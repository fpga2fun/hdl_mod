class Packet;
  rand bit [31:0] length;
  constraint c_short {length inside {[1 : 32]};}
  constraint c_long {length inside {[1000 : 1023]};}
endclass

Packet p;
initial begin
  p = new();

  // 通过禁止 c_short 约束产生长包
  p.c_short.constraint_mode(0);
  `SV_RAND_CHECK(p.randomize());

  transmit(p);

  // 通过禁止所有约束，仅仅使能短包约束来产生短包
  //then enabling only the short constraint
  p.constraint_mode(0);
  p.c_short.constraint_mode(1);
  `SV_RAND_CHECK(p.randomize());
  transmit(p);
end
