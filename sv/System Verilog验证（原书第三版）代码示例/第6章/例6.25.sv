class BusOp;
  rand operand_e op;
  rand length_e  len;
  constraint c_len_rw {
    if (op == READ) {
      len inside {[BYTE : LWRD]};
    } else {
      len == LWRD;
    }
  }
endclass
