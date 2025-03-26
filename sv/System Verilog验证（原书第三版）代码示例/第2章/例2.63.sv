bit [7:0] b8;
bit one = 1'b1;               // 单比特
$displayb(one + one);         // A: 1+1 = 0

b8 = one + one;               // B: 1+1 = 2
$displayb(b8);

$displayb(one + one + 2'b0);  // C: 1+1 = 2, 使用了常量

$displayb(2'(one) + one);     // D: 1+1 = 2, 采用强制类型转换
