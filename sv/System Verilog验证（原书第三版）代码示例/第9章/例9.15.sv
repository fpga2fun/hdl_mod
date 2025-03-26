class Packet;
  rand bit [2:0] hdr_len;  // 范围：0:7
  rand bit [3:0] payload_len;  // 范围：0:15
  rand bit [3:0] kind;
endclass
Packet p;

covergroup CovLen15;
  len16: coverpoint (p.hdr_len + p.payload_len);
  len32: coverpoint (p.hdr_len + p.payload_len + 5'b0);
endgroup
