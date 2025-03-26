class Packet;
  rand bit [31:0] length;
  bit [31:0] max_length = 100;  // 配置变量，不是随机数
  constraint c_length {length inside {[1 : max_length]};}
endclass
