void mydisplay(const svOpenArrayHandle h) {
 int i, j;
 int lo1 = svLow(h, 1);
 int hi1 = svHigh(h, 1);
 int lo2 = svLow(h, 2);
 int hi2 = svHigh(h, 2);
 for (i = lo1; i <= hi1; i++) {
 for (j = lo2; j <= hi2; j++) {
 int *a = (int*) svGetArrElemPtr2(h, i, j);
 io_printf("C: a[%d][%d] = %d\n", i, j, *a);
 *a = i * j;
 }
 }
}