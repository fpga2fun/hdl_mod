Transaction src, dst;
initial begin
  src = new();  // 创建第一个对象
  src.stats.startT = 42;  // 设置起始时间
  dst = src.copy();  // 使用深层复制将 src 复制给 dst 
  dst.stats.startT = 96;  // 仅改变 dst 的 stats 值
  $display(src.stats.startT);  //“42”, 见图 5.8
end
