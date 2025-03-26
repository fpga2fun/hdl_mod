class Counter7 {
public:
 Counter7();
 void count();
 void load(const svBitVecVal* i);
 void reset();
 int get();
private:
 unsigned char cnt;
};

Counter7::Counter7() { // 计数器初始化
 cnt = 0;
 
void Counter7::count() { // 计数器递增
 cnt = cnt + 1;
 cnt &= 0x7F; // 最高位清 0
}

void Counter7::load(const svBitVecVal* i) {
 cnt = *i;
 cnt &= 0x7F; // 最高位清 0
}

void Counter7::reset() {
 cnt = 0;
}

// 从 svBitVecVal 指针中获取计数器值
int Counter7::get() {
 return cnt;
}