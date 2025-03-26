class Vars32;
  rand bit [31:0] pkt1_len, pkt2_len;  // 无符号类型
  constraint total_len {pkt1_len + pkt2_len == 64;}
endclass
