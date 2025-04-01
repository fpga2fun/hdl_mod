class Vars8;
  rand bit [7:0] pkt1_len, pkt2_len;  //8 位位宽
  constraint total_len {
    pkt1_len + pkt2_len == 9'd64;  // 和是 9 位位宽
  }
endclass
