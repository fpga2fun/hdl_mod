class SignedVars;
  rand byte pkt1_len, pkt2_len;
  constraint total_len {pkt1_len + pkt2_len == 64;}
endclass
