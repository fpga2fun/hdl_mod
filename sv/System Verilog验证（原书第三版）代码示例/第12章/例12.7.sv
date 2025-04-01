#include <svdpi.h>
void counter7(svBitVecVal *o,
 const svBitVecVal *i,
 const svBit reset,
 const svBit load) {
 static unsigned char count = 0; // 静态的计数变量
 if (reset) count = 0; // 复位
 else if (load) count = *i; // 加载数值
 else count++; // 计数
 count &= 0x7f; // 最高位清 0
 
 *o = count;
}