class Tiny;
  int i;
endclass  // Tiny

int i = 42, j = 43, k;  // 要保存到数据库的整数
real pi = 22.0 / 7.0, r;  // 要保存到数据库的实数
Tiny t;  // 要保存到数据库的句柄

initial begin
  config_db#(int)::set("i", i);  // 将整数保存到数据库
  config_db#(int)::set("j", j);  // 将整数保存到数据库 
  config_db#(real)::set("pi", pi);  // 将实数保存到数据库

  t   = new();
  t.i = 8;
  config_db#(Tiny)::set("t", t);  // 将句柄保存到数据库
  config_db#(Tiny)::set("null", null);  // 测试空句柄

  config_db#(int)::get("i", k);  // 从数据库取出一个整数
  $display("Fetched value (%0d) of i (%0d)", i, k);

  config_db#(int)::print();  // 打印整数数据库
  config_db#(real)::print();  // 打印实数数据库
  config_db#(Tiny)::print();  // 打印句柄数据库
end
