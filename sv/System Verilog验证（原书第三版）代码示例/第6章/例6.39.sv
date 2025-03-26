// 产生可变长度有效负载的包
class Packet;
  rand bit [7:0] length, payload[];
  constraint c_valid {
    length > 0;
    payload.size() == length;
  }

  function void display(input string msg);
    $display("\n%s", msg);
    $write("\tPacket len = %0d, bytes = ", length);
    for (int i = 0; (i < 4 && i < payload.size()); i++) $write(" %0d", payload[i]);
    $display;
  endfunction
endclass

Packet p;
initial begin
  p = new();
  `SV_RAND_CHECK(p.randomize());  // 随机化所有变量
  p.display("Simple randomize");

  p.length.rand_mode(0);  // 设置包长为非随机值
  p.length = 42;  // 设置包长为常数
  `SV_RAND_CHECK(p.randomize());  // 再随机化 payload
  p.display("Randomize with rand_mode");
end
