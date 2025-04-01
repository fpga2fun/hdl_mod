// 创建代表 0,1,2 的数据类型
typedef enum {
  INIT,
  DECODE,
  IDLE
} fsmstate_e;
fsmstate_e pstate, nstate;  // 声明自定义类型变量

initial begin
  case (pstate)
    IDLE: nstate = INIT;     // 数据赋值
    INIT: nstate = DECODE;
    default: nstate = IDLE;
  endcase
  $display("Next state is %s", nstate.name());  // 显示状态的符号名
end
