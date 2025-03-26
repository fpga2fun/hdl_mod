constraint length {
  len == hdr_len + payload_len;
  solve len before hdr_len, payload_len;
}
