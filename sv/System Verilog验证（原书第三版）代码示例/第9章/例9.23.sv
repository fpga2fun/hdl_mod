typedef enum {
  INIT,
  DECODE,
  IDLE
} fsmstate_e;
fsmstate_e pstate, nstate;  // 声明自有类型变量
covergroup CovFsm23;
  coverpoint pstate;
endgroup
