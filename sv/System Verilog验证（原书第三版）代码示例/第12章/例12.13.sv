class Counter7 {
public:
 Counter7();
 void counter7_signal(svBitVecVal* count,
 const svBitVecVal* i,
 const svBit reset,
 const svBit load);
private:
 unsigned char cnt;
};

Counter7::Counter7() {
 cnt = 0; // 计数器初始化
}

void Counter7::counter7_signal(svBitVecVal* count,
 const svBitVecVal* i,
 const svBit reset,
 const svBit load) {
 if (reset) cnt = 0; // 复位
 else if (load) cnt = *i; // 加载数值
 else cnt++; // 计数
 cnt &= 0x7F; // 最高位清 0
 *count = cnt;
}