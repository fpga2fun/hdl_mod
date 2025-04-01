class Transaction;
  typedef enum {
    BYTE,
    WORD,
    LWRD,
    QWRD
  } length_e;
  typedef enum {
    READ,
    WRITE,
    RMW,
    INTR
  } access_e;

  rand length_e length;
  rand access_e access;
  constraint valid_RMW_LWRD {(access == RMW) -> (length == LWRD);}
endclass
