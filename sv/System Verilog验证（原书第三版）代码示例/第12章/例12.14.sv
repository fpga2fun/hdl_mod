extern "C" void* counter7_new()
{
 return new Counter7;
 }

// 调用一个计数器实例，传递信号值
extern "C" void counter7(void* inst,svBitVecVal* count,const svBitVecVal* i,const svBit reset,const svBit load)
{
 Counter7 * c7 = (Counter7 *) inst;
 c7 -> counter7_signal(count, i, reset, load);
}