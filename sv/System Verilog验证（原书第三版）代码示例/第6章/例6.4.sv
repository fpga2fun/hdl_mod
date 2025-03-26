class Stim;
  const bit [31:0] CONGEST_ADDR = 42;
  typedef enum {
    READ,
    WRITE,
    CONTROL
  } stim_e;
  randc stim_e kind;  // 枚举变量
  rand bit [31:0] len, src, dst;
  rand bit congestion_test;

  constraint c_stim {
    len < 1000;
    len > 0;
    if (congestion_test) {
      dst inside {[CONGEST_ADDR - 10 : CONGEST_ADDR + 10]};
      src == CONGEST_ADDR;
    } else
    src inside {0, [2 : 10], [100 : 107]};
  }
endclass
