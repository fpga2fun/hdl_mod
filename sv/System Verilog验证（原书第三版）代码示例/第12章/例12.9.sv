#include <svdpi.h>
#include <malloc.h>
#include <veriuser.h>

typedef struct { // 保存计数值的结构
 unsigned char cnt;
} c7;

// 创建一个计数器结构
void* counter7_new() {
 c7* c = (c7*) malloc(sizeof(c7)); // 将分配好的存储区地址给 c7
 c -> cnt = 0;
 return c;
}

// 计数器运行一个周期
void counter7(c7 *inst,
 svBitVecVal* count,
 const svBitVecVal* i,
 const svBit reset,
 const svBit load) {

 if (reset) inst -> cnt = 0; // 复位
 else if (load) inst -> cnt = *i; // 加载数值
 else inst -> cnt++; // 计数
 inst -> cnt &= 0x7f; // 最高位置 0
 
 *count = inst -> cnt; // 赋值给输出变量
 io_printf("C: count = %d, i = %d, reset = %d, load = %d\n",
 *count, *i, reset, load);
}