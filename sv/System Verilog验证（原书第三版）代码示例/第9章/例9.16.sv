covergroup CovLen16;
  len: coverpoint (p.hdr_len + p.payload_len + 5'b0) {
    bins len[] = {[0 : 23]};
  }  // 有 Bug ？见下面的文字
endgroup
