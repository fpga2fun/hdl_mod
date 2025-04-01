// 将例 12.9 中的 counter7 替换为四状态变量
void counter7(c7 *inst,
 svLogicVecVal* count,
 const svLogicVecVal* i,
 const svLogic reset,
 const svLogic load) {

 if (reset & 0x2) { // 仅检查标量的 bval 位
 io_printf("Error: Z or X detected on reset\n\n");
 return;
 }
 if (load & 0x2) { // 仅检查标量的 bval 位
 io_printf("Error: Z or X detected on load\n\n");
 return;
 }
 if (i -> bval) { // 仅检查 7 比特向量的 bval 位
 io_printf("Error: Z or X detected on i\n\n");
 return;
 }

 if (reset) inst->cnt = 0; // 复位
 else if (load) inst->cnt = i->aval; // 加载数值
 else inst->cnt++; // 计数
 inst -> cnt &= 0x7f; // 最高位清 0
 
 count->aval = inst->cnt; // 赋值给输出变量
 count->bval = 0;
}