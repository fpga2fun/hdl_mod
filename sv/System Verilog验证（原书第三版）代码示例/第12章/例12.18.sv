void fib(svBitVecVal data[20]) {
 int i;
 data[0] = 1;
 data[1] = 1;
 for (i = 2; i < 20; i++)
 data[i] = data[i-1] + data[i-2];
}