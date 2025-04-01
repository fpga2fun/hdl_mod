void fib(svLogicVecVal data[20]) {
 int i;
 data[0].aval = 1; // 赋值给 aval 和 bval
 data[0].bval = 0; 
 data[1].aval = 1;
 data[1].bval = 0;
 for (i = 2; i < 20; i++) {
 data[i].aval = data[i-1].aval + data[i-2].aval;
 data[i].bval = 0; // 别忘了将 bval 归零
 }
}