`define SV_RAND_CHECK(r) \
 do begin \
 if (!(r)) begin \
 $display("%s:%0d: Randomization failed \"%s\"", \
 `__FILE__, `__LINE__, `"r`"); \
 $finish; \
 end \
 end while (0)

initial begin
  Packet p = new();  // 创建一个包
  `SV_RAND_CHECK(p.randomize());  // 随机化
end
