void fib_oa(const svOpenArrayHandle data_oa) {
 int i, *data;
 data = (int *) svGetArrayPtr(data_oa);
 data[0] = 1;
 data[1] = 1;
 for (i = 2; i <= svSize(data_oa, 1); i++)
 data[i] = data[i-1] + data[i-2];
}