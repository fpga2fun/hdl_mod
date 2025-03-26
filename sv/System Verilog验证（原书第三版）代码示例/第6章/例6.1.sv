class Packet;
  // 随机变量
  rand bit  [31:0] src,  dst, data[8];
  randc bit [ 7:0] kind;
  //src 的约束
  constraint c {
    src > 10;
    src < 15;
  }
endclass

Packet p;
initial begin
  p = new();  // 产生一个包
  if (!p.randomize()) $finish;
  transmit(p);
end
