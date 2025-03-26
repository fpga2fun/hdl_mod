void view_pack(const svOpenArrayHandle h) {
 int i;
 for (i = svLow(h,1); i < svHigh(h,1); i++)
 io_printf("C: b64[%d] = %llx\n",
 i, *(long long int *)svGetArrElemPtr1(h, i));
}